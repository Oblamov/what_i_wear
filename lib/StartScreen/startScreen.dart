import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:weath_i_wear/MainPage/main_page.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  TextEditingController _cityController = TextEditingController();

  Future<void> fetchWeatherData(String city) async {
    final apiKey = 'ae245924e7e70054ad9ca23543ae25c7';
    final url = 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String weather = data['weather'][0]['main'];
        double temperature = data['main']['temp'] - 273.15; // Kelvin to Celsius

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(),
            settings: RouteSettings(arguments: {
              'weather': weather,
              'temperature': temperature,
            }),
          ),
        );
      } else {
        print('City not found');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/startscreenBackground.jpeg', // Ensure this file exists
              fit: BoxFit.cover,
            ),
          ),

          // Foreground Content
          SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'What I Wear',
                      style: TextStyle(
                        fontFamily: 'DEBROSEE',
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(height: 30),

                    // Search Bar
                    TextField(
                      controller: _cityController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        hintText: "Enter City Name",
                        prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Search Button
                    ElevatedButton(
                      onPressed: () {
                        String city = _cityController.text.trim();
                        if (city.isNotEmpty) fetchWeatherData(city);
                      },
                      child: Text('Get Weather'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),

                    SizedBox(height: 30),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
