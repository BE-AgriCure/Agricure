import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherService {
  static const String API_KEY = 'YOUR_OPENWEATHER_API_KEY'; // Get from openweathermap.org
  static const String BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';

  static Future<Map<String, dynamic>> getWeather(double lat, double lon) async {
    try {
      final url = '$BASE_URL?lat=$lat&lon=$lon&appid=$API_KEY&units=metric';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      print('Weather error: $e');
      rethrow;
    }
  }

  static String getWeatherAction(Map<String, dynamic> weather) {
    try {
      double temp = weather['main']['temp'].toDouble();
      double humidity = weather['main']['humidity'].toDouble();
      double rain = (weather['rain']?['1h']?.toDouble() ?? 0);

      if (rain > 2) {
        return '🌧️ Heavy Rain: Delay watering, check for fungal diseases.';
      } else if (rain > 0.5) {
        return '🌧️ Light Rain: Good for plants, monitor soil moisture.';
      } else if (temp > 35) {
        return '🌡️ Very Hot: Increase watering frequency, provide shade.';
      } else if (temp > 30) {
        return '☀️ Hot: Water early morning/evening, avoid midday watering.';
      } else if (temp < 5) {
        return '❄️ Cold: Reduce watering, protect from frost.';
      } else if (humidity > 80) {
        return '💧 High Humidity: Increase ventilation, watch for fungus.';
      } else {
        return '✓ Optimal: Good conditions for plant growth!';
      }
    } catch (e) {
      return 'Weather data unavailable.';
    }
  }

  static String getWeatherDescription(Map<String, dynamic> weather) {
    try {
      double temp = weather['main']['temp'].toDouble();
      double humidity = weather['main']['humidity'].toDouble();
      String condition = weather['weather'][0]['main'] ?? '';
      
      return 'Temp: ${temp.toStringAsFixed(1)}°C | Humidity: $humidity% | $condition';
    } catch (e) {
      return 'Weather data unavailable.';
    }
  }
}
