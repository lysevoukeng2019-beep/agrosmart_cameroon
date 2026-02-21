import 'package:dio/dio.dart';

class WeatherService {
  final String apiKey = "WEATHER"; 
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    try {
      final response = await _dio.get(
        'https://api.openweathermap.org/data/2.5/weather',
        queryParameters: {
          'q': city,
          'appid': apiKey,
          'units': 'metric',
          'lang': 'fr',
        },
      );
      return response.data;
    } catch (e) {
      throw Exception("Erreur météo : $e");
    }
  }
}
