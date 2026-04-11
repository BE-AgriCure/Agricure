import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String BASE_URL = 'http://10.0.2.2:8000'; // For Android emulator
  // Use 'http://localhost:8000' for iOS simulator or device
  // For physical device, use actual machine IP: 'http://192.168.x.x:8000'

  static Future<Map<String, dynamic>> predictDisease(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$BASE_URL/predict'),
      );

      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(
          Map.from(Uri.parse('data:application/json;base64,').replace(
            path: responseData,
          ).data as Map? ?? {}),
        );
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      print('API Error: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> healthCheck() async {
    try {
      final response = await http.get(Uri.parse('$BASE_URL/health'));
      if (response.statusCode == 200) {
        return {'status': 'healthy'};
      } else {
        throw Exception('Server not available');
      }
    } catch (e) {
      return {'status': 'offline'};
    }
  }
}
