import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agricare/services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Map<String, dynamic>? _weatherData;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _getWeather();
  }

  Future<void> _getWeather() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Request location permission
      final status = await Permission.location.request();
      if (status.isDenied) {
        setState(() => _error = 'Location permission denied');
        return;
      }

      // Get current location
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Fetch weather
      final weather = await WeatherService.getWeather(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _weatherData = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _getWeather,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _getWeather,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _weatherData == null
                  ? const Center(child: Text('No weather data'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Location
                          Text(
                            _weatherData!['name'] ?? 'Unknown Location',
                            style: Theme.of(context).textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),

                          // Weather Info Card
                          Card(
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Text(
                                    '${_weatherData!['main']['temp']}°C',
                                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _weatherData!['weather'][0]['main'] ?? 'N/A',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Details
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildWeatherDetail(
                                    'Humidity',
                                    '${_weatherData!['main']['humidity']}%',
                                    Icons.water_drop,
                                  ),
                                  const Divider(),
                                  _buildWeatherDetail(
                                    'Feels Like',
                                    '${_weatherData!['main']['feels_like']}°C',
                                    Icons.thermostat,
                                  ),
                                  const Divider(),
                                  _buildWeatherDetail(
                                    'Wind Speed',
                                    '${_weatherData!['wind']['speed']} m/s',
                                    Icons.air,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Recommendation Card
                          Card(
                            color: Colors.green[50],
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Care Recommendation',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    WeatherService.getWeatherAction(_weatherData!),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildWeatherDetail(String label, String value, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(width: 12),
            Text(label),
          ],
        ),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
