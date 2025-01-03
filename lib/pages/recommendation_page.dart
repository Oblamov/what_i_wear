import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../controllers/weather_controller.dart';
import '../models/weather_model.dart';
import '../models/clothing_item.dart';
import '../services/api_service.dart';
import '../pages/wardrobe_page.dart' as war;


class RecommendationPage extends StatefulWidget {
  final String city;
  final List<ClothingItem> wardrobe;

  final Weather weather; // Pass weather data

  RecommendationPage({
    required this.city,
    required this.wardrobe,
    required this.weather,
  });

  @override
  _RecommendationPageState createState() => _RecommendationPageState();
}


class _RecommendationPageState extends State<RecommendationPage> {
  final WeatherController weatherController = WeatherController();
  Weather? weatherData;
  bool isLoading = false; //change to true for real state
  String errorMessage = '';
  List<ClothingItem> recommendedOutfit = [];
  String? aiRecommendation;
  List<ClothingItem> wardrobe = [];

  @override
  void initState() {
    super.initState();
    print('👗 Wardrobe Item Count on RecommendationPage: ${wardrobe.length}');
    _filterOutfit();
  }

  Map<String, dynamic> _prepareDataForAI() {
    final double temperature = widget.weather.temperature;
    final double humidity = widget.weather.humidity ?? 0.0;
    final double windSpeed = widget.weather.windSpeed ?? 0.0;

    // Hava koşullarına uygun kıyafetleri filtrele
    List<ClothingItem> filteredItems = widget.wardrobe.where((item) {
      return (item.minTemperature <= temperature && item.maxTemperature >= temperature) &&
          (item.minHumidity <= humidity && item.maxHumidity >= humidity) &&
          (item.minWindSpeed <= windSpeed && item.maxWindSpeed >= windSpeed);
    }).toList();

    // AI için uygun kıyafetleri hazırlama
    Map<String, List<String>> groupedItems = {
      'upper_body': [],
      'lower_body': [],
      'accessories': [],
      'shoes': [],
      'full_body': [],
      'headwear': [],
    };

    for (var item in filteredItems) {
      switch (item.primaryCategory) {
        case 'Upper Body':
          groupedItems['upper_body']?.add('#${item.uniqueName}');
          break;
        case 'Lower Body':
          groupedItems['lower_body']?.add('#${item.uniqueName}');
          break;
        case 'Accessories':
          groupedItems['accessories']?.add('#${item.uniqueName}');
          break;
        case 'Footwear':
          groupedItems['shoes']?.add('#${item.uniqueName}');
          break;
        case 'Full Body':
          groupedItems['full_body']?.add('#${item.uniqueName}');
          break;
        case 'Headwear':
          groupedItems['headwear']?.add('#${item.uniqueName}');
          break;
      }
    }

    print('✅ Prepared Items for AI: $groupedItems');

    return {
      "weather": {
        "temperature": temperature,
        "humidity": humidity,
        "wind_speed": windSpeed,
      },
      "available_items": groupedItems,
    };
  }

  void _filterOutfit() {
    final double temperature = widget.weather.temperature;
    final double humidity = widget.weather.humidity ?? 0.0;
    final double windSpeed = widget.weather.windSpeed ?? 0.0;

    // Hava koşullarına uygun kıyafetleri filtrele
    List<ClothingItem> filteredItems = widget.wardrobe.where((item) {
      return (item.minTemperature <= temperature && item.maxTemperature >= temperature) &&
          (item.minHumidity <= humidity && item.maxHumidity >= humidity) &&
          (item.minWindSpeed <= windSpeed && item.maxWindSpeed >= windSpeed);
    }).toList();

    // Kategorilere ve Alt Kategorilere göre grupla
    Map<String, Map<String, List<ClothingItem>>> categorizedItems = {};

    for (var item in filteredItems) {
      if (!categorizedItems.containsKey(item.primaryCategory)) {
        categorizedItems[item.primaryCategory] = {};
      }
      if (!categorizedItems[item.primaryCategory]!.containsKey(item.subCategory)) {
        categorizedItems[item.primaryCategory]![item.subCategory] = [];
      }
      categorizedItems[item.primaryCategory]![item.subCategory]?.add(item);
    }

    print('✅ Categorized Items by Weather: $categorizedItems');

    setState(() {
      recommendedOutfit = filteredItems; // Tüm uygun kıyafetler gösterilecek
    });
  }
  Widget _buildWeatherSuitableWardrobeList() {
    final double temperature = widget.weather.temperature;
    final double humidity = widget.weather.humidity ?? 0.0;
    final double windSpeed = widget.weather.windSpeed ?? 0.0;

    // Hava koşullarına uygun kıyafetleri filtrele
    List<ClothingItem> filteredItems = widget.wardrobe.where((item) {
      return (item.minTemperature <= temperature && item.maxTemperature >= temperature) &&
          (item.minHumidity <= humidity && item.maxHumidity >= humidity) &&
          (item.minWindSpeed <= windSpeed && item.maxWindSpeed >= windSpeed);
    }).toList();

    // Kategorilere ve alt kategorilere göre gruplandır
    Map<String, Map<String, List<ClothingItem>>> groupedItems = {};

    for (var item in filteredItems) {
      if (!groupedItems.containsKey(item.primaryCategory)) {
        groupedItems[item.primaryCategory] = {};
      }
      if (!groupedItems[item.primaryCategory]!.containsKey(item.subCategory)) {
        groupedItems[item.primaryCategory]![item.subCategory] = [];
      }
      groupedItems[item.primaryCategory]![item.subCategory]?.add(item);
    }

    return filteredItems.isEmpty
        ? Center(
      child: Text(
        'No suitable clothes found for current weather conditions.',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    )
        : ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: groupedItems.keys.length,
      itemBuilder: (context, categoryIndex) {
        String category = groupedItems.keys.elementAt(categoryIndex);
        Map<String, List<ClothingItem>> subCategories = groupedItems[category]!;

        return ExpansionTile(
          title: Text(
            category,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          children: subCategories.keys.map((subCategory) {
            return ExpansionTile(
              title: Text(
                subCategory,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              children: subCategories[subCategory]!.map((item) {
                return ListTile(
                  leading: Image.file(
                    File(item.imagePath),
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    item.uniqueName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  subtitle: Text(item.tags.join(', ')),
                );
              }).toList(),
            );
          }).toList(),
        );
      },
    );
  }

  // Filter wardrobe items based on weather conditions
  List<ClothingItem> _filterWardrobeByWeather({
    required double temperature,
    required double humidity,
    required double windSpeed,
  }) {return widget.wardrobe.where((item) {
      return item.minTemperature <= temperature &&
          item.maxTemperature >= temperature &&
          item.minHumidity <= humidity &&
          item.maxHumidity >= humidity &&
          item.minWindSpeed <= windSpeed &&
          item.maxWindSpeed >= windSpeed;
    }).toList();
  }

  void _generateOutfit() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {

      final recommendation = await ApiService().fetchOutfitRecommendation(_prepareDataForAI());

      setState(() {
        aiRecommendation = recommendation;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Widget build(BuildContext context) {
    print("🛠️ Build Method Triggered");
    print("🌤️ Weather City: ${widget.weather.city}");
    print("🌡️ Weather Temperature: ${widget.weather.temperature}");
    print("💧 Weather Humidity: ${widget.weather.humidity}");
    print("💨 Weather Wind Speed: ${widget.weather.windSpeed}");
    print("👗 Wardrobe Items: ${widget.wardrobe.length}");
    print("🤖 AI Recommendation: $aiRecommendation");
    print("🔄 Loading State: $isLoading");
    print("❌ Error Message: $errorMessage");

    return Scaffold(
      appBar: AppBar(
        title: Text('Recommendation for ${widget.city}'),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading spinner
          : errorMessage.isNotEmpty
          ? Center(
        child: Text(
          errorMessage,
          style: TextStyle(fontSize: 16, color: Colors.red),
          textAlign: TextAlign.center,
        ),
      ) // Show error message
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🌤️ Weather Details
              Text('City: ${widget.weather.city}',
                  style: TextStyle(fontSize: 20)),
              Text('Weather: ${widget.weather.weatherCondition}',
                  style: TextStyle(fontSize: 18)),
              Text(
                  'Temperature: ${widget.weather.temperature.toStringAsFixed(1)}°C',
                  style: TextStyle(fontSize: 18)),
              Text('Humidity: ${widget.weather.humidity.toString()}%',
                  style: TextStyle(fontSize: 18)),
              Text('Wind Speed: ${widget.weather.windSpeed.toString()} km/h',
                  style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),

              // 👗 Recommended Wardrobe Items
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('👗 Clothes Suitable for Current Weather:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              _buildWeatherSuitableWardrobeList(),
              SizedBox(height: 20),

              Text('AI-Generated Recommendation:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              aiRecommendation != null
                  ? Text(
                aiRecommendation!,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.justify,
              )
                  : Text(
                'No AI Recommendation yet.',
                style: TextStyle(fontSize: 16, color: Colors.grey[400]),
              ),
              SizedBox(height: 20),
// 🔄 Refresh Button
              Center(
                child: ElevatedButton.icon(
                  onPressed: _generateOutfit,
                  icon: Icon(Icons.refresh),
                  label: Text('Generate New Recommendation'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}