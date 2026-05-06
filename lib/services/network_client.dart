import 'dart:convert';
import 'package:dio/dio.dart';

class NetworkClient {
  static const String baseUrl = 'http://fayez24-001-site1.ntempurl.com';

  // ── Basic Auth credentials (server-level) ──
  static const String _basicUser = 'fayez24-001';
  static const String _basicPass = '[Fayez2004..]';

  static Dio? _dio;

  static Dio get instance {
    _dio ??= _createDio();
    return _dio!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          // Basic Auth header على كل request أوتوماتيك
          'Authorization': _buildBasicAuth(),
        },
      ),
    );

    dio.interceptors.add(_AuthInterceptor());
    dio.interceptors.add(_LogInterceptor());

    return dio;
  }

  static String _buildBasicAuth() {
    final credentials = base64Encode(utf8.encode('$_basicUser:$_basicPass'));
    return 'Basic $credentials';
  }
}

// ── Interceptor بيضيف الـ Bearer Token لو موجود ──
class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Basic Auth اتضاف في الـ default headers
    // لو عندنا Bearer Token نضيفه جنب البيزك
    // (هيتضاف من الـ ApiService لو محتاج)
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // لو السيرفر رجع HTML بدل JSON
    if (err.response?.data is String &&
        (err.response!.data as String).contains('<html')) {
      err = err.copyWith(
        message: 'السيرفر رجع HTML — تأكد من الـ Basic Auth credentials',
      );
    }
    handler.next(err);
  }
}

// ── Interceptor للـ Logging ──
class _LogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('📤 REQUEST: ${options.method} ${options.path}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('✅ RESPONSE: ${response.statusCode} ${response.requestOptions.path}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('❌ ERROR: ${err.message} | ${err.response?.statusCode}');
    handler.next(err);
  }
}
