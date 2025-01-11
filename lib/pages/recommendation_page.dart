import 'package:flutter/material.dart';
import 'dart:io';
import '../controllers/weather_controller.dart';
import '../models/weather_model.dart';
import '../models/clothing_item.dart';
import '../services/api_service.dart';

class RecommendationPage extends StatefulWidget {
  final String city;
  final List<ClothingItem> wardrobe;
  final Weather weather;

  RecommendationPage({
    required this.city,
    required this.wardrobe,
    required this.weather,
  });

  @override
  _RecommendationPageState createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  bool isLoading = false;
  String errorMessage = '';
  List<ClothingItem> recommendedOutfit = [];
  String? aiRecommendation;

  @override
  void initState() {
    super.initState();
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

  Widget _buildWeatherCard() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7), // Transparan siyah
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'City: ${widget.weather.city}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Weather: ${widget.weather.weatherCondition}',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          Text(
            'Temperature: ${widget.weather.temperature.toStringAsFixed(1)}°C',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          Text(
            'Humidity: ${widget.weather.humidity.toString()}%',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          Text(
            'Wind Speed: ${widget.weather.windSpeed.toString()} km/h',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
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

    // Eğer uygun kıyafet yoksa bir mesaj göster
    if (filteredItems.isEmpty) {
      return Center(
        child: Text(
          'No suitable clothes found for current weather conditions.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white60, // Slightly dimmer white
          ),
        ),
      );
    }

    // ListView içinde kategorileri, alt kategorileri ve öğeleri göster
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: groupedItems.keys.length,
      itemBuilder: (context, categoryIndex) {
        String category = groupedItems.keys.elementAt(categoryIndex);
        Map<String, List<ClothingItem>> subCategories = groupedItems[category]!;

        return ExpansionTile(
          // Category Title
          title: Text(
            category,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white, // White text
            ),
          ),
          // Subcategories
          children: subCategories.keys.map((subCategory) {
            return ExpansionTile(
              // Subcategory Title
              title: Text(
                subCategory,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white, // White text
                ),
              ),
              // Items in this subcategory
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
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white, // White text
                    ),
                  ),
                  subtitle: Text(
                    item.tags.join(', '),
                    style: TextStyle(color: Colors.white70), // Slightly dimmer white
                  ),
                );
              }).toList(),
            );
          }).toList(),
        );
      },
    );
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
  @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.grey[900], // Koyu gri arka plan
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom AppBar
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      'Recommendations for ${widget.city}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // İçerik
                Expanded(
                  child: isLoading
                      ? Center(child: CircularProgressIndicator(color: Colors.teal))
                      : errorMessage.isNotEmpty
                      ? Center(
                    child: Text(
                      errorMessage,
                      style: TextStyle(
                          fontSize: 16, color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  )
                      : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 🌤️ Weather Details
                        _buildWeatherCard(),
                        SizedBox(height: 20),

                        // 👗 Recommended Wardrobe Items
                        Text(
                          textAlign: TextAlign.center,
                          '👗 Clothes Suitable for Current Weather',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        _buildWeatherSuitableWardrobeList(),

                        // 🔄 Refresh Button
                        SizedBox(height: 20),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: _generateOutfit,
                            icon: Icon(Icons.refresh),
                            label: Text('Generate New Recommendation'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange, // Turuncu buton
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ),
                          ),
                        ),

                        // OpenAI Bölümü
                        SizedBox(height: 20),

// Wrap AI recommendation text in a center-aligned container
                        SizedBox(height: 20),
                        Center(
                          child: Container(
                            width: double.infinity, // Fill the available width
                            margin: EdgeInsets.symmetric(horizontal: 16.0),
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.black12, // Semi-transparent box color
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,            // Wrap content vertically
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Image above the text
                                Image.asset(
                                  color: Colors.white,
                                  'assets/openai.png', // Replace with your image path
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(height: 12), // Spacing between image and text

                                // AI recommendation text
                                aiRecommendation != null
                                    ? Text(
                                  aiRecommendation!,
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                  textAlign: TextAlign.center,
                                )
                                    : Text(
                                  'No AI Recommendation yet.',
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 40),

// ...

                      ],
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
