import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class PlantInferenceService {
  Interpreter? _validatorInterpreter;
  Interpreter? _diseaseInterpreter;

  final List<String> _diseaseLabels = [
    'healthy',
    'fungi',
    'bacteria',
    'virus',
    'pests',
  ];

  Future<void> initModels() async {
    try {
      _validatorInterpreter = await Interpreter.fromAsset(
        'assets/leaf_validator.tflite',
      );
      _diseaseInterpreter = await Interpreter.fromAsset(
        'assets/disease_classifier.tflite',
      );
      print("✅ Models loaded successfully");
    } catch (e) {
      print("❌ Failed to load models: $e");
    }
  }

  Future<String> processImage(File imageFile) async {
    if (_validatorInterpreter == null || _diseaseInterpreter == null) {
      return "ERROR: Models not initialized";
    }

    final bytes = await imageFile.readAsBytes();
    img.Image? originalImage = img.decodeImage(bytes);
    if (originalImage == null) return "ERROR: Could not decode image";

    var inputTensor = _preprocessImage(originalImage);

    // Stage 1: التأكد إنها ورقة نبات
    var validatorOutput = List.filled(2, 0.0).reshape([1, 2]);
    _validatorInterpreter!.run(inputTensor, validatorOutput);

    double leafConfidence = validatorOutput[0][1];
    if (leafConfidence < 0.80) {
      return "INVALID_IMAGE: الصورة مش ورقة نبات، ركز على ورقة النبتة وحاول تاني";
    }

    // Stage 2: تحديد المرض
    var diseaseOutput = List.filled(5, 0.0).reshape([1, 5]);
    _diseaseInterpreter!.run(inputTensor, diseaseOutput);

    return _getHighestLabel(diseaseOutput[0]);
  }

  List<List<List<List<double>>>> _preprocessImage(img.Image image) {
    img.Image resized = img.copyResize(image, width: 224, height: 224);
    return List.generate(
      1,
      (_) => List.generate(
        224,
        (y) => List.generate(224, (x) {
          final pixel = resized.getPixel(x, y);
          return [
            (pixel.r / 127.5) - 1.0,
            (pixel.g / 127.5) - 1.0,
            (pixel.b / 127.5) - 1.0,
          ];
        }),
      ),
    );
  }

  String _getHighestLabel(List<dynamic> output) {
    double maxConf = -1.0;
    int maxIdx = 0;
    for (int i = 0; i < output.length; i++) {
      if ((output[i] as num).toDouble() > maxConf) {
        maxConf = (output[i] as num).toDouble();
        maxIdx = i;
      }
    }
    return _diseaseLabels[maxIdx];
  }

  void dispose() {
    _validatorInterpreter?.close();
    _diseaseInterpreter?.close();
  }
}
