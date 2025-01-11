import 'package:flutter/material.dart';
import 'main_page.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final TextEditingController _cityController = TextEditingController();

  /// Navigate to Main Page with the entered city
  void _navigateToMainPage() {
    final city = _cityController.text.trim();

    if (city.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a city name!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainPage(city: city),
      ),
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
              'assets/startscreenBackground.jpeg',
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // App Title
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [Colors.orange, Colors.deepOrangeAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: Text(
                      'What I Wear',
                      style: TextStyle(
                        fontFamily: 'DEBROSEE',
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent.shade200,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            offset: Offset(-1, 10),
                            blurRadius: 20.0,
                            color: Colors.black,
                          ),
                          Shadow(
                            offset: Offset(0, -5),
                            blurRadius: 10.0,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // City Input Field
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: _cityController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Enter City",
                        prefixIcon: Icon(Icons.location_city, color: Colors.orange),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Navigate to Main Page
                  ElevatedButton(
                    onPressed: _navigateToMainPage,
                    child: Text('Get Weather'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange, // Turuncu renk
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
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

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }
}
