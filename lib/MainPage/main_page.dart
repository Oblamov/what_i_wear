import 'package:flutter/material.dart';
import '../StartScreen/startScreen.dart';

class MainPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};

    String weather = args['weather'] ?? 'Unknown';
    double temperature = args['temperature'] ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Weather: $weather',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Temperature: ${temperature.toStringAsFixed(1)} °C',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/recommendation', arguments: {
                  'weather': weather,
                  'temperature': temperature,
                });
              },
              child: const Text('Go to Recommendation Page'),
            ),
          ],
        ),
      ),
    );
  }

}
