import 'package:flutter/material.dart';
import 'package:http/http.dart';

class WeathIWearStartScreen extends StatefulWidget {
  @override
  _WeathIWearStartScreenState createState() => _WeathIWearStartScreenState();
}

class _WeathIWearStartScreenState extends State<WeathIWearStartScreen> {
  double _dragPosition = 0.0;
  final double _dragEndThreshold = 200.0; // Adjust as needed

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [
          // Background image for the whole screen
          Positioned.fill(
            child: Image(
              image: AssetImage('images/onOfAll.jpg'),
              fit: BoxFit.cover, // Ensure the image fills the entire screen
            ),
          ),
          // Overlay content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Main Title
                Text(
                  'Weath I Wear',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),

                // Subtitle
                Text(
                  'Find Your Best Look',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),

                SizedBox(height: 50),

                // Sliding Start Button
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
                      Navigator.pushNamed(context, '/mainScreen');
                    } else {
                      // Reset the drag position if the user didn't complete the slide
                      setState(() {
                        _dragPosition = 0;
                      });
                    }
                  },
                  child: Stack(
                    children: [
                      // Background bar
                      Container(
                        width: _dragEndThreshold + 50,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.purple.shade100,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      // Sliding button
                      Positioned(
                        left: _dragPosition,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.arrow_forward_ios, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: WeathIWearStartScreen(),
    debugShowCheckedModeBanner: false,
    routes: {
      '/mainScreen': (context) => WeathIWearStartScreen(), // Define your main screen here
    },
  ));
}
