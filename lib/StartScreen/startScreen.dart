// Add this to pubspec.yaml (if not already added):
// flutter:
//   fonts:
//     - family: CustomFont
//       fonts:
//         - asset: assets/fonts/CustomFont.ttf // Replace with your font

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../MainPage/main_page.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  double _dragPosition = 0.0;
  final double _dragEndThreshold = 200.0;
  final TextEditingController _cityController = TextEditingController();
  String _weatherData = '';
  bool _isLoading = false;
  bool _isSliderVisible = false;

  // Fetch weather data
  Future<void> fetchWeatherData(String city) async {
    final apiKey = 'ae245924e7e70054ad9ca23543ae25c7';
    final url = 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey';

    setState(() => _isLoading = true);

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _weatherData = '''
          City: ${data['name']}
          Temperature: ${(data['main']['temp'] - 273.15).toStringAsFixed(1)} °C
          Weather: ${data['weather'][0]['description']}
          ''';
          _isSliderVisible = true; // Show slider after successful fetch
        });
      } else {
        setState(() {
          _weatherData = 'Error: City not found';
          _isSliderVisible = false;
        });
      }
    } catch (e) {
      setState(() {
        _weatherData = 'Error: Something went wrong';
        _isSliderVisible = false;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Navigate to MainPage
  void _navigateToMainPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/startscreenBackground.jpeg', // Replace with your image
              fit: BoxFit.cover,
            ),
          ),

          // Content
          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Application Title with Custom Font and Shadow
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [Colors.blueAccent, Colors.purpleAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: Text(
                      'What I Wear',
                      style: TextStyle(
                        fontFamily: 'DEBROSEE', // Use your custom font here
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent.shade200,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            offset: Offset(-1, 10),
                            blurRadius: 20.0,
                            color: Colors.black, // Shadow color
                          ),
                          Shadow(
                            offset: Offset(0, -5),
                            blurRadius: 10.0,
                            color: Colors.black.withOpacity(0.5), // Glow effect
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Search Bar
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: _cityController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(1),
                        hintText: "Search City",
                        prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: BorderSide.none,
                        ),
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
                      padding:
                      EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Weather Feedback
                  _isLoading
                      ? CircularProgressIndicator()
                      : Text(
                    _weatherData,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Slide Bar
                  GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      setState(() {
                        _dragPosition += details.delta.dx;
                        if (_dragPosition < 0) {
                          _dragPosition = 0;
                        } else if (_dragPosition > _dragEndThreshold) {
                          _dragPosition = _dragEndThreshold;
                        }
                      });
                    },
                    onHorizontalDragEnd: (details) {
                      if (_dragPosition >= _dragEndThreshold) {
                        // Navigate to the next screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainPage(),
                          ),
                        );
                      } else {
                        // Reset the drag position if the user didn't complete the slide
                        setState(() {
                          _dragPosition = 0;
                        });
                      }
                    },
                    child: Stack(
                      children: [
                        // Transparent Background Bar
                        Container(
                          width: _dragEndThreshold + 50,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.5),
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Slide to Continue',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        // Sliding Button
                        Positioned(
                          left: _dragPosition,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.blueAccent.withOpacity(0.0),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0),
                                  blurRadius: 5,
                                  offset: Offset(0, 1.5),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
