import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/weather_controller.dart';
import '../models/weather_model.dart';
import 'wardrobe_page.dart';
import 'recommendation_page.dart';
import '../models/clothing_item.dart';

class MainPage extends StatefulWidget {
  final String city;

  MainPage({required this.city});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final WeatherController weatherController = WeatherController();
  Weather? weatherData;
  bool isLoading = true;
  String errorMessage = '';
  List<ClothingItem> wardrobe = [];

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
    _loadWardrobeData();
  }

  /// Fetch Weather Data from API
  Future<void> _loadWeatherData() async {
    try {
      final weather = await weatherController.getWeather(widget.city);
      setState(() {
        weatherData = weather;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  /// Load Wardrobe Data (Example Dummy Data)
  void _loadWardrobeData() async {
    final prefs = await SharedPreferences.getInstance();
    final wardrobeData = prefs.getStringList('wardrobe');

    if (wardrobeData != null) {
      setState(() {
        wardrobe = wardrobeData
            .map((item) => ClothingItem.fromJson(item))
            .toList();
      });
    } else {
      print('ℹ️ No wardrobe data found in SharedPreferences.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather in ${widget.city}'),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text('Error: $errorMessage'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Weather Details
            Text('City: ${weatherData?.city ?? 'N/A'}',
                style: TextStyle(fontSize: 20)),
            Text(
                'Weather: ${weatherData?.weatherCondition ?? 'N/A'}',
                style: TextStyle(fontSize: 18)),
            Text(
                'Temperature: ${weatherData?.temperature.toStringAsFixed(1) ?? 'N/A'}°C',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 30),

            // Navigation Buttons
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WardrobePage(),
                  ),
                );
              },
              icon: Icon(Icons.checkroom),
              label: Text('Go to Wardrobe'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(
                    horizontal: 30, vertical: 12),
              ),
            ),
            SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () {
            if (weatherData != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    print("🌤️ Navigating to RecommendationPage");
                    print("🔄 Weather Data: ${weatherData?.temperature}, ${weatherData?.humidity}, ${weatherData?.windSpeed}");
                    print("👗 Wardrobe Item Count: ${wardrobe.length}");

                    return RecommendationPage(
                      city: widget.city,
                      wardrobe: wardrobe, // Güncel listeyi aktar
                      weather: weatherData!,
                    );
                  },
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Weather data not loaded. Please wait.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          icon: Icon(Icons.recommend),
          label: Text('Get Recommendations'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.greenAccent,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          ),
        ),
        ],
        ),
      ),
    );
  }
}
