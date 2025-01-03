import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class ApiService {
  // OpenWeatherMap API for Weather Data
  final String _weatherBaseUrl = '${dotenv.env['WEATHERAPIEND']}';

  // OpenAI API for Outfit Recommendations
  final String _chatGptApiUrl = '${dotenv.env['OPENAI_API_END']}';


  /// Fetch Outfit Recommendation from OpenAI ChatGPT
  Future<String> fetchOutfitRecommendation(Map<String, dynamic> payload) async {
    print("📤 Sending Payload to AI: ${jsonEncode(payload)}");

    try {
      final response = await http.post(
        Uri.parse(_chatGptApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${dotenv.env['OPENAI_API_KEY']}',
        },
        body: jsonEncode({
          "model": "gpt-4-turbo",
          "messages": [
            {
              "role": "system",
              "content": "You are a fashion assistant. Create outfit combinations using the exact unique names from the wardrobe provided."
            },
            {
              "role": "user",
              "content": '''
Temperature: ${payload['weather']['temperature']}
Humidity: ${payload['weather']['humidity']}
Wind Speed: ${payload['weather']['wind_speed']}

Available Items:
${payload['available_items'].entries.map((category) {
                final categoryName = category.key;
                final itemsList = category.value; // This is a List<String>
                return "$categoryName -> ${itemsList.join(', ')}";
              }).join('\n')}"
              
Just fill that table and dont give me any explanation. And if some field is empty just stay empty.
If a category has more than one subcategory with an appropriate outfit, randomly select one from each of the appropriate subcategories for the parent category.
              
1)
Upper Body:
Lower Body:
Accessories:
Shoes:
Head Wear:
               
               
2)
Full Body:
Accessories:
Shoes:
Headwear:
               
Randomly choese  first or second table and dont show un selected one in response.

'''
            }
          ],
          "max_tokens": 500
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception('Failed to fetch AI recommendation: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('API Call Error: $e');
    }
  }



  /// Fetch Weather Data from OpenWeatherMap
  Future<Weather> fetchWeather(String city) async {
    final Uri url = Uri.parse('$_weatherBaseUrl?q=$city&appid=${dotenv.env['WEATHERAPIKEY']}&units=metric');

    try {
      final response = await http.get(url);

      print("🌦️ Weather API Status Code: ${response.statusCode}");
      print("🌦️ Weather API Response: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Weather.fromJson(data); // Map JSON to Weather object
      } else {
        throw Exception('Failed to fetch weather data: ${response.statusCode}');
      }
    } catch (e) {
      print("❌ Weather API Error: $e");
      throw Exception('Error: $e');
    }
  }

}