import 'package:flutter/material.dart';
import 'pages/startScreen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  // Load env variables from the .env file
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'What I Wear',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: StartScreen(),
    );
  }
}
