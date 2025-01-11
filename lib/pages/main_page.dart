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

  String _getBackgroundImage(String? condition) {
    if (condition == null) {
      return 'assets/default.png';
    }
    switch (condition.toLowerCase()) {
      case 'clear sky':
        return 'assets/sunny.png';
      case 'rain':
        return 'assets/rainy.png';
      case 'snow':
        return 'assets/snowy.png';
      case 'clouds':
        return 'assets/cloudy.png';
      case 'shower rain':
        return 'assets/rainy.png';
      case 'broken clouds':
        return 'assets/cloudy.png';
      case 'scattered clouds':
        return 'assets/cloudy.png';
      case 'few clouds':
        return 'assets/cloudy.png';
      case 'thunderstorm':
        return 'assets/rainy.png';
      case 'mist':
        return 'assets/misty.png';
      case 'overcast clouds':
        return 'assets/cloudy.png';
      case 'light snow':
        return 'assets/snowy.png';
      default:
        return 'assets/deafult.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arka Plan
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  _getBackgroundImage(weatherData?.weatherCondition),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Geri Dön Tuşu
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          // İçerik
          isLoading
              ? Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
              ? Center(child: Text('Error: $errorMessage'))
              : Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Şeffaf Bilgi Kutusu
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Şehir Adı
                      Text(
                        weatherData?.city ?? 'City',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),

                      // Derece (Sıcaklık)
                      Text(
                        '${weatherData?.temperature.toStringAsFixed(1) ?? 'N/A'}°C',
                        style: TextStyle(
                          fontSize: 60, // Büyük font
                          fontWeight: FontWeight.bold,
                          color: Colors.orangeAccent,
                        ),
                      ),
                      SizedBox(height: 10),

                      // Hava Durumu Bilgisi
                      Text(
                        weatherData?.weatherCondition?.toUpperCase() ??
                            'N/A',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),

                // Düzenlenmiş Butonlar (Alt Alta ve Büyük)
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WardrobePage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black.withOpacity(0.7), // Siyah ve şeffaf
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.checkroom, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          'Go to Wardrobe',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () {
                      if (weatherData != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return RecommendationPage(
                                city: widget.city,
                                wardrobe: wardrobe,
                                weather: weatherData!,
                              );
                            },
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Weather data not loaded. Please wait.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black.withOpacity(0.7), // Siyah ve şeffaf
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.recommend, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          'Get Recommendations',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
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
