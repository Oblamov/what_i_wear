import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/startScreen.dart';
import 'pages/authentication_page.dart';
import 'pages/main_page.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  print("Weather API Key: ${dotenv.env['WEATHERAPIKEY']}"); //later delete
  print("Weather API Endpoint: ${dotenv.env['WEATHERAPIEND']}");//later delete
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'What I Wear',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login', // Define the initial route
      routes: {
        '/login': (context) => AuthenticationPage(), // Default page on app start
        '/start': (context) => StartScreen(), // Route after successful login
        '/main': (context) => MainPage(city: 'DefaultCity'),
      },
    );
  }
}
