import 'package:dio/dio.dart';
import 'network_client.dart';
import 'auth_storage.dart';

class ApiService {
  static final Dio _dio = NetworkClient.instance;

  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 2);

  static Future<Options> _options({bool requiresAuth = true}) async {
    final Map<String, dynamic> headers = {};
    if (requiresAuth) {
      final token = await AuthStorage.getToken();
      if (token != null) {
        headers['X-JWT-Token'] = 'Bearer $token';
      }
    }
    return Options(headers: headers);
  }

  static Future<Map<String, dynamic>> getPlantCare(String plantName) async {
    if (plantName.trim().isEmpty) {
      return {'success': false, 'message': 'Plant name is empty'};
    }

    final encodedName = Uri.encodeComponent(plantName.trim());
    print("🔍 Getting care for: $encodedName"); // ← debug

    return await get('/api/Conditions/plant/$encodedName', requiresAuth: true);
  }

  static dynamic _parseResponse(Response response) {
    final data = response.data;
    if (data is String && data.trimLeft().startsWith('<')) {
      throw Exception('السيرفر رجع HTML — مشكلة في الـ Basic Auth');
    }
    return data;
  }

  static Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    bool requiresAuth = true,
  }) async {
    int retryCount = 0;
    while (retryCount < _maxRetries) {
      try {
        final options = await _options(requiresAuth: requiresAuth);
        final response = await _dio.get(
          endpoint,
          queryParameters: queryParams,
          options: options,
        );
        return {'success': true, 'data': _parseResponse(response)};
      } on DioException catch (e) {
        if (_shouldRetry(e) && retryCount < _maxRetries - 1) {
          retryCount++;
          await Future.delayed(_retryDelay);
          continue;
        }
        return _handleError(e);
      } catch (e) {
        return {'success': false, 'message': e.toString()};
      }
    }
    return {'success': false, 'message': 'فشل بعد $_maxRetries محاولات'};
  }

  static Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
    bool isMultipart = false,
    FormData? formData,
  }) async {
    int retryCount = 0;
    while (retryCount < _maxRetries) {
      try {
        final options = await _options(requiresAuth: requiresAuth);
        if (isMultipart) options.contentType = 'multipart/form-data';
        final response = await _dio.post(
          endpoint,
          data: isMultipart ? formData : body,
          options: options,
        );
        return {'success': true, 'data': _parseResponse(response)};
      } on DioException catch (e) {
        if (_shouldRetry(e) && retryCount < _maxRetries - 1) {
          retryCount++;
          await Future.delayed(_retryDelay);
          continue;
        }
        return _handleError(e);
      } catch (e) {
        return {'success': false, 'message': e.toString()};
      }
    }
    return {'success': false, 'message': 'فشل بعد $_maxRetries محاولات'};
  }

  static Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    int retryCount = 0;
    while (retryCount < _maxRetries) {
      try {
        final options = await _options(requiresAuth: requiresAuth);
        final response = await _dio.put(endpoint, data: body, options: options);
        return {'success': true, 'data': _parseResponse(response)};
      } on DioException catch (e) {
        if (_shouldRetry(e) && retryCount < _maxRetries - 1) {
          retryCount++;
          await Future.delayed(_retryDelay);
          continue;
        }
        return _handleError(e);
      } catch (e) {
        return {'success': false, 'message': e.toString()};
      }
    }
    return {'success': false, 'message': 'فشل بعد $_maxRetries محاولات'};
  }

  static bool _shouldRetry(DioException e) {
    return e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError ||
        (e.type == DioExceptionType.badResponse &&
            (e.response?.statusCode == 500 || e.response?.statusCode == 503));
  }

  static Map<String, dynamic> _handleError(DioException e) {
    String message;
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'انتهى وقت الاتصال، تأكد من النت';
        break;
      case DioExceptionType.connectionError:
        message = 'مفيش اتصال بالسيرفر';
        break;
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        if (statusCode == 401) {
          message = 'غير مصرح، سجّل دخول تاني';
        } else if (statusCode == 404) {
          message = 'المسار مش موجود';
        } else if (statusCode == 500) {
          message = 'خطأ في السيرفر - حاول مرة أخرى';
        } else if (data is Map) {
          message = data['message'] ?? data['error'] ?? 'حصل خطأ ($statusCode)';
        } else {
          message = 'حصل خطأ ($statusCode)';
        }
        break;
      default:
        message = e.message ?? 'حصل خطأ غير معروف';
    }
    print('❌ API Error: $message');
    return {'success': false, 'message': message};
  }

  // ══════════════════════════════════════════
  //  AUTH
  // ══════════════════════════════════════════

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final result = await post(
      '/api/auth/login',
      body: {'email': email, 'password': password},
    );
    if (result['success']) {
      final data = result['data'];
      // ← الاسم جوه user object
      final user = data['user'] ?? data;
      await AuthStorage.saveTokens(
        token: data['token'],
        refreshToken: data['refreshToken'] ?? '',
        userId: user['id'].toString(),
        fullName: user['fullName'] ?? '',
      );
    }
    return result;
  }

  static Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String phone = '',
  }) async {
    final result = await post(
      '/api/auth/register',
      body: {
        'fullName': '$firstName $lastName',
        'email': email,
        'password': password,
        'phone': phone,
      },
    );
    if (result['success'] && result['data']['token'] != null) {
      final data = result['data'];
      final user = data['user'] ?? data;
      await AuthStorage.saveTokens(
        token: data['token'],
        refreshToken: data['refreshToken'] ?? '',
        userId: user['id'].toString(),
        fullName: user['fullName'] ?? '$firstName $lastName',
      );
    }
    return result;
  }

  static Future<bool> refreshToken() async {
    final accessToken = await AuthStorage.getToken();
    final refreshTok = await AuthStorage.getRefreshToken();
    if (accessToken == null || refreshTok == null) return false;
    final result = await post(
      '/api/auth/refresh-token',
      body: {'accessToken': accessToken, 'refreshToken': refreshTok},
    );
    if (result['success']) {
      final data = result['data'];
      await AuthStorage.saveTokens(
        token: data['token'],
        refreshToken: data['refreshToken'],
        userId: await AuthStorage.getUserId() ?? '',
        fullName: await AuthStorage.getFullName() ?? '',
      );
      return true;
    }
    return false;
  }

  // ══════════════════════════════════════════
  //  DIAGNOSIS
  // ══════════════════════════════════════════

  static Future<Map<String, dynamic>> scanPlant({
    required String plantType,
    required String conditionName,
    required String detectedCategory,
  }) async {
    final result = await post(
      '/api/diagnosis/scan',
      body: {
        'plantType': plantType,
        'conditionName': conditionName,
        'detectedCategory': detectedCategory,
      },
      requiresAuth: true,
    );
    // print("📥 Scan result: $result");
    return result;
  }

  // ══════════════════════════════════════════
  //  USER PLANTS
  // ══════════════════════════════════════════

  static Future<Map<String, dynamic>> getUserPlants({
    int page = 1,
    int pageSize = 10,
  }) async {
    final userId = await AuthStorage.getUserId();
    return await get(
      '/api/userplants/user/$userId',
      queryParams: {'pageNumber': page, 'pageSize': pageSize},
    );
  }

  static Future<Map<String, dynamic>> savePlant({
    required String name,
    required String disease,
    required String treatment,
  }) async {
    final userId = await AuthStorage.getUserId();
    return await post(
      '/api/userplants/save',
      body: {
        'userId': userId,
        'plantName': name,
        'disease': disease,
        'treatment': treatment,
      },
      requiresAuth: true,
    );
  }
}
