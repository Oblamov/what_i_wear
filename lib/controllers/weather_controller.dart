import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/weather_model.dart';

class WeatherController {
  Future<Weather> getWeather(String city) async {
    // Load the API key and base URL from the .env file
    final apiKey = dotenv.env['WEATHERAPIKEY'];
    final apiBaseUrl = dotenv.env['WEATHERAPIEND'];

    // Validate the API key and base URL
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('Weather API Key is missing. Please check your .env file.');
    }
    if (apiBaseUrl == null || apiBaseUrl.isEmpty) {
      throw Exception('Weather API Base URL is missing. Please check your .env file.');
    }

    // Construct the full API URL
    final url = Uri.parse('${apiBaseUrl}/weather?q=$city&appid=$apiKey&units=metric');

    print('🌍 Fetching weather for city: $city');
    print('🔑 API Key: $apiKey');
    print('🔗 API URL: $url');

    // Perform the HTTP GET request
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Parse the JSON response into the Weather model
      final data = json.decode(response.body);
      print('✅ Weather Data Received: $data');
      return Weather.fromJson(data);
    } else {
      // Handle HTTP errors
      throw Exception('Failed to fetch weather data: ${response.statusCode}');
    }
  }
}
