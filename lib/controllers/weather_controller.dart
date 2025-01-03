import '../services/api_service.dart';
import '../models/weather_model.dart';

class WeatherController {
  final ApiService _apiService = ApiService();

  /// Fetch weather data and provide it to the UI
  Future<Weather> getWeather(String city) async {
    try {
      Weather weather = await _apiService.fetchWeather(city);
      return weather;
    } catch (e) {
      throw Exception('Failed to fetch weather data: $e');
    }
  }
}
