import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class TFLiteService {
  Interpreter? interpreter;
  List<String>? labels;
  Map<String, dynamic>? remedies;

  Future<void> loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset('assets/model.tflite');
      
      // Load labels from asset
      final labelsContent = await rootBundle.loadString('assets/labels.txt');
      labels = labelsContent.split('\n').where((l) => l.isNotEmpty).toList();
      
      // Load remedies from asset
      final remediesContent = await rootBundle.loadString('assets/remedies.json');
      remedies = jsonDecode(remediesContent) as Map<String, dynamic>;
      
      print('✓ TFLite model loaded (${labels!.length} classes)');
    } catch (e) {
      print('Error loading model: $e');
      rethrow;
    }
  }

  Map<String, dynamic> predict(Uint8List imageBytes) {
    try {
      if (interpreter == null || labels == null || remedies == null) {
        throw Exception('Model not loaded');
      }

      // Decode image
      img.Image? image = img.decodeImage(imageBytes);
      if (image == null) throw Exception('Could not decode image');

      // Resize to 224x224
      image = img.copyResize(image, width: 224, height: 224);

      // Convert to input format [1, 224, 224, 3]
      var input = image.getBytes();
      var inputList = List.generate(
        1,
        (i) => List.generate(
          224 * 224 * 3,
          (j) => input[j].toDouble() / 255.0,
        ),
      );

      // Prepare output
      var output = [List<double>.filled(labels!.length, 0.0)];

      // Run inference
      interpreter!.run(inputList, output);

      // Get top prediction
      List<double> outputList = output[0].cast<double>();
      int predIdx = outputList.indexWhere((v) => v == outputList.reduce((a, b) => a > b ? a : b));
      double confidence = outputList[predIdx];
      String disease = labels![predIdx];

      return {
        'disease': disease,
        'confidence': confidence,
        'remedy': remedies![disease] ?? 'Consult an agricultural expert.',
      };
    } catch (e) {
      print('Prediction error: $e');
      return {
        'disease': 'Error',
        'confidence': 0.0,
        'remedy': 'Please try again with a clearer image.',
      };
    }
  }

  void dispose() {
    interpreter?.close();
  }
}
