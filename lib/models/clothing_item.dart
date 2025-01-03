import 'dart:convert';

/// Represents a clothing item in the wardrobe.
class ClothingItem {
  final String uniqueName; // Unique name for each clothing item
  final String imagePath;
  final String primaryCategory;
  final String subCategory;
  final List<String> tags;
  final double minTemperature;
  final double maxTemperature;
  final double minHumidity;
  final double maxHumidity;
  final double minWindSpeed;
  final double maxWindSpeed;
  final DateTime addedDate;

  ClothingItem({
    required this.uniqueName,
    required this.imagePath,
    required this.primaryCategory,
    required this.subCategory,
    required this.tags,
    required this.minTemperature,
    required this.maxTemperature,
    required this.minHumidity,
    required this.maxHumidity,
    required this.minWindSpeed,
    required this.maxWindSpeed,
    required this.addedDate,
  });

  /// Predefined mapping based on subCategory
  factory ClothingItem.withPredefinedValues({
    required String uniqueName,
    required String imagePath,
    required String primaryCategory,
    required String subCategory,
    required DateTime addedDate,
  }){
    Map<String, Map<String, dynamic>> predefinedRanges = {
      // 🌟 Upper Body
      'T-Shirt': {'minTemp': 20.0, 'maxTemp': 35.0, 'minHumidity': 30.0, 'maxHumidity': 90.0, 'minWind': 0.0, 'maxWind': 15.0, 'tags': ['Casual', 'Summer Wear']},
      'Crop Top': {'minTemp': 20.0, 'maxTemp': 35.0, 'minHumidity': 20.0, 'maxHumidity': 80.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Casual', 'Summer Wear']},
      'Blouse': {'minTemp': 18.0, 'maxTemp': 28.0, 'minHumidity': 30.0, 'maxHumidity': 70.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Casual', 'Business Casual']},
      'Tank Top': {'minTemp': 20.0, 'maxTemp': 35.0, 'minHumidity': 20.0, 'maxHumidity': 80.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Casual', 'Beachwear']},
      'Camisole': {'minTemp': 20.0, 'maxTemp': 35.0, 'minHumidity': 20.0, 'maxHumidity': 80.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Casual', 'Summer Wear']},
      'Shirt': {'minTemp': 15.0, 'maxTemp': 25.0, 'minHumidity': 40.0, 'maxHumidity': 80.0, 'minWind': 0.0, 'maxWind': 15.0, 'tags': ['Business Casual', 'Formal']},
      'Polo Shirt': {'minTemp': 18.0, 'maxTemp': 30.0, 'minHumidity': 30.0, 'maxHumidity': 80.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Casual', 'Sportswear']},
      'Hoodie': {'minTemp': 5.0, 'maxTemp': 20.0, 'minHumidity': 40.0, 'maxHumidity': 80.0, 'minWind': 0.0, 'maxWind': 20.0, 'tags': ['Casual', 'Loungewear']},
      'Sweatshirt': {'minTemp': 10.0, 'maxTemp': 18.0, 'minHumidity': 40.0, 'maxHumidity': 80.0, 'minWind': 0.0, 'maxWind': 15.0, 'tags': ['Casual', 'Sportswear']},
      'Jacket': {'minTemp': 0.0, 'maxTemp': 15.0, 'minHumidity': 70.0, 'maxHumidity': 100.0, 'minWind': 2.0, 'maxWind': 30.0, 'tags': ['Casual', 'Winter Wear']},
      'Blazer': {'minTemp': 10.0, 'maxTemp': 25.0, 'minHumidity': 40.0, 'maxHumidsity': 100.0, 'minWind': 0.0, 'maxWind': 15.0, 'tags': ['Formal', 'Business Casual']},
      'Coat': {'minTemp': -8.0, 'maxTemp': 10.0, 'minHumidity': 50.0, 'maxHumidity': 100.0, 'minWind': 0.0, 'maxWind': 30.0, 'tags': ['Formal', 'Winter Wear']},
      'Cardigan': {'minTemp': 5.0, 'maxTemp': 18.0, 'minHumidity': 30.0, 'maxHumidity': 80.0, 'minWind': 0.0, 'maxWind': 15.0, 'tags': ['Casual', 'Loungewear']},
      'Dress Shirt': {'minTemp': 10.0, 'maxTemp': 25.0, 'minHumidity': 30.0, 'maxHumidity': 80.0, 'minWind': 0.0, 'maxWind': 15.0, 'tags': ['Formal', 'Business Casual']},
      'Suit Jacket': {'minTemp': 5.0, 'maxTemp': 20.0, 'minHumidity': 40.0, 'maxHumidity': 80.0, 'minWind': 0.0, 'maxWind': 20.0, 'tags': ['Formal']},
      'Waistcoat': {'minTemp': 10.0, 'maxTemp': 20.0, 'minHumidity': 20.0, 'maxHumidity': 80.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Formal']},

      // 🌟 Lower Body
      'Jeans': {'minTemp': 10.0, 'maxTemp': 25.0, 'minHumidity': 40.0, 'maxHumidity': 70.0, 'minWind': 0.0, 'maxWind': 20.0, 'tags': ['Casual', 'Business Casual']},
      'Trousers': {'minTemp': 12.0, 'maxTemp': 28.0, 'minHumidity': 30.0, 'maxHumidity': 70.0, 'minWind': 0.0, 'maxWind': 15.0, 'tags': ['Formal', 'Business Casual']},
      'Leggings': {'minTemp': 5.0, 'maxTemp': 20.0, 'minHumidity': 50.0, 'maxHumidity': 90.0, 'minWind': 0.0, 'maxWind': 15.0, 'tags': ['Sportswear', 'Casual']},
      'Cargo Pants': {'minTemp': 10.0, 'maxTemp': 25.0, 'minHumidity': 40.0, 'maxHumidity': 80.0, 'minWind': 5.0, 'maxWind': 20.0, 'tags': ['Outdoor Adventure']},
      'Sweatpants': {'minTemp': 8.0, 'maxTemp': 20.0, 'minHumidity': 40.0, 'maxHumidity': 70.0, 'minWind': 0.0, 'maxWind': 15.0, 'tags': ['Loungewear', 'Sportswear']},
      'Mini Skirt': {'minTemp': 20.0, 'maxTemp': 30.0, 'minHumidity': 30.0, 'maxHumidity': 60.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Casual', 'Party']},
      'Midi Skirt': {'minTemp': 18.0, 'maxTemp': 28.0, 'minHumidity': 30.0, 'maxHumidity': 60.0, 'minWind': 0.0, 'maxWind': 15.0, 'tags': ['Casual', 'Formal']},
      'Maxi Skirt': {'minTemp': 15.0, 'maxTemp': 25.0, 'minHumidity': 30.0, 'maxHumidity': 70.0, 'minWind': 0.0, 'maxWind': 15.0, 'tags': ['Casual', 'Evening Wear']},
      'Pencil Skirt': {'minTemp': 18.0, 'maxTemp': 28.0, 'minHumidity': 40.0, 'maxHumidity': 70.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Formal', 'Business Casual']},
      'Casual Shorts': {'minTemp': 22.0, 'maxTemp': 35.0, 'minHumidity': 30.0, 'maxHumidity': 60.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Casual', 'Summer Wear']},
      'Bermuda Shorts': {'minTemp': 25.0, 'maxTemp': 35.0, 'minHumidity': 30.0, 'maxHumidity': 50.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Casual', 'Beachwear']},
      'Cycling Shorts': {'minTemp': 18.0, 'maxTemp': 30.0, 'minHumidity': 30.0, 'maxHumidity': 60.0, 'minWind': 0.0, 'maxWind': 15.0, 'tags': ['Sportswear']},
      'Overalls': {'minTemp': 12.0, 'maxTemp': 25.0, 'minHumidity': 40.0, 'maxHumidity': 70.0, 'minWind': 0.0, 'maxWind': 15.0, 'tags': ['Casual', 'Workwear']},
      'Jumpsuit': {'minTemp': 11.0, 'maxTemp': 28.0, 'minHumidity': 30.0, 'maxHumidity': 60.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Casual', 'Formal']},

      // 🌟 Full Body
      'Casual Dress': {'minTemp': 20.0, 'maxTemp': 30.0, 'minHumidity': 30.0, 'maxHumidity': 70.0, 'minWind': 0.0, 'maxWind': 15.0, 'tags': ['Casual', 'Party']},
      'Evening Dress': {'minTemp': 15.0, 'maxTemp': 25.0, 'minHumidity': 40.0, 'maxHumidity': 80.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Party', 'Evening Wear']},
      'Maxi Dress': {'minTemp': 18.0, 'maxTemp': 28.0, 'minHumidity': 30.0, 'maxHumidity': 70.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Casual', 'Summer Wear']},
      'Cocktail Dress': {'minTemp': 15.0, 'maxTemp': 25.0, 'minHumidity': 40.0, 'maxHumidity': 70.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Party', 'Formal']},
      'Casual Romper': {'minTemp': 22.0, 'maxTemp': 35.0, 'minHumidity': 30.0, 'maxHumidity': 60.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Casual', 'Summer Wear']},
      'Dressy Romper': {'minTemp': 18.0, 'maxTemp': 28.0, 'minHumidity': 30.0, 'maxHumidity': 70.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Formal', 'Evening Wear']},
      'Casual Jumpsuit': {'minTemp': 18.0, 'maxTemp': 30.0, 'minHumidity': 30.0, 'maxHumidity': 60.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Casual', 'Outdoor Wear']},
      'Formal Jumpsuit': {'minTemp': 15.0, 'maxTemp': 25.0, 'minHumidity': 40.0, 'maxHumidity': 70.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Formal', 'Evening Wear']},
      'Formal Suit': {'minTemp': 10.0, 'maxTemp': 20.0, 'minHumidity': 40.0, 'maxHumidity': 70.0, 'minWind': 0.0, 'maxWind': 15.0, 'tags': ['Formal', 'Business Wear']},
      'Casual Suit': {'minTemp': 15.0, 'maxTemp': 25.0, 'minHumidity': 40.0, 'maxHumidity': 70.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Casual', 'Business Casual']},

      // 🌟 Headwear
      'Cap': {'minTemp': 20.0, 'maxTemp': 35.0, 'minHumidity': 30.0, 'maxHumidity': 60.0, 'minWind': 0.0, 'maxWind': 15.0, 'tags': ['Casual', 'Summer Wear']},
      'Beanie': {'minTemp': -5.0, 'maxTemp': 10.0, 'minHumidity': 50.0, 'maxHumidity': 90.0, 'minWind': 0.0, 'maxWind': 20.0, 'tags': ['Winter Wear']},
      'Beret': {'minTemp': 10.0, 'maxTemp': 20.0, 'minHumidity': 40.0, 'maxHumidity': 70.0, 'minWind': 0.0, 'maxWind': 15.0, 'tags': ['Casual', 'Formal']},
      'Fedora': {'minTemp': 15.0, 'maxTemp': 25.0, 'minHumidity': 30.0, 'maxHumidity': 60.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Formal', 'Business Casual']},
      'Top Hat': {'minTemp': 10.0, 'maxTemp': 20.0, 'minHumidity': 40.0, 'maxHumidity': 70.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Formal']},
      'Bowler Hat': {'minTemp': 15.0, 'maxTemp': 25.0, 'minHumidity': 30.0, 'maxHumidity': 60.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Formal', 'Business Casual']},
      'Sun Hat': {'minTemp': 25.0, 'maxTemp': 35.0, 'minHumidity': 20.0, 'maxHumidity': 50.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Summer Wear', 'Beachwear']},
      'Bucket Hat': {'minTemp': 15.0, 'maxTemp': 30.0, 'minHumidity': 30.0, 'maxHumidity': 60.0, 'minWind': 0.0, 'maxWind': 15.0, 'tags': ['Casual', 'Outdoor Adventure']},
      'Winter Hat': {'minTemp': -10.0, 'maxTemp': 5.0, 'minHumidity': 50.0, 'maxHumidity': 90.0, 'minWind': 0.0, 'maxWind': 20.0, 'tags': ['Winter Wear']},
      'Turban': {'minTemp': 15.0, 'maxTemp': 25.0, 'minHumidity': 40.0, 'maxHumidity': 70.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Cultural', 'Formal']},
      'Veil': {'minTemp': 18.0, 'maxTemp': 28.0, 'minHumidity': 30.0, 'maxHumidity': 60.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Cultural', 'Formal']},
      // 🌟 Accessories
      'Scarf': {'minTemp': -10.0, 'maxTemp': 15.0, 'minHumidity': 50.0, 'maxHumidity': 90.0, 'minWind': 3.0, 'maxWind': 25.0, 'tags': ['Winter Wear', 'Casual']},
      'Tie': {'minTemp': -5.0, 'maxTemp': 25.0, 'minHumidity': 40.0, 'maxHumidity': 70.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Formal', 'Business Casual']},
      'Bowtie': {'minTemp': -5.0, 'maxTemp': 25.0, 'minHumidity': 40.0, 'maxHumidity': 70.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Formal', 'Business Casual']},
      'Gloves': {'minTemp': -5.0, 'maxTemp': 10.0, 'minHumidity': 50.0, 'maxHumidity': 90.0, 'minWind': 0.0, 'maxWind': 20.0, 'tags': ['Winter Wear']},
      'Mittens': {'minTemp': -10.0, 'maxTemp': 5.0, 'minHumidity': 60.0, 'maxHumidity': 90.0, 'minWind': 5.0, 'maxWind': 20.0, 'tags': ['Winter Wear']},
      'Sunglasses': {'minTemp': -15.0, 'maxTemp': 35.0, 'minHumidity': 20.0, 'maxHumidity': 50.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Summer Wear', 'Casual']},
      'Prescription Glasses': {'minTemp': -10.0, 'maxTemp': 30.0, 'minHumidity': 30.0, 'maxHumidity': 60.0, 'minWind': 10.0, 'maxWind': 15.0, 'tags': ['Everyday Wear']},
      'Necklace': {'minTemp': -10.0, 'maxTemp': 30.0, 'minHumidity': 0.0, 'maxHumidity': 90.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Formal', 'Casual']},
      'Bracelet': {'minTemp': -10.0, 'maxTemp': 30.0, 'minHumidity': 0.0, 'maxHumidity': 90.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Casual', 'Party']},
      'Rings': {'minTemp': -10.0, 'maxTemp': 25.0, 'minHumidity': 0.0, 'maxHumidity': 90.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Casual', 'Formal']},
      'Earrings': {'minTemp': -10.0, 'maxTemp': 30.0, 'minHumidity': 0.0, 'maxHumidity': 90.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Casual', 'Party']},
      'Waist Belt': {'minTemp': -10.0, 'maxTemp': 25.0, 'minHumidity': 0.0, 'maxHumidity': 90.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Formal', 'Casual']},
      'Suspender Belt': {'minTemp': -10.0, 'maxTemp': 20.0, 'minHumidity': 0.0, 'maxHumidity': 90.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Formal']},
      'Backpack': {'minTemp': -10.0, 'maxTemp': 25.0, 'minHumidity': 0.0, 'maxHumidity': 90.0, 'minWind': 0.0, 'maxWind': 20.0, 'tags': ['Outdoor Adventure', 'Travel']},
      'Handbag': {'minTemp': -10.0, 'maxTemp': 25.0, 'minHumidity': 0.0, 'maxHumidity': 90.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Formal', 'Casual']},

      // 🌟 Footwear
      'Sneakers': {'minTemp': 0.0, 'maxTemp': 30.0, 'minHumidity': 30.0, 'maxHumidity': 70.0, 'minWind': 0.0, 'maxWind': 20.0, 'tags': ['Casual', 'Sportswear']},
      'Loafers': {'minTemp': 10.0, 'maxTemp': 25.0, 'minHumidity': 30.0, 'maxHumidity': 60.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Formal', 'Business Casual']},
      'Oxfords': {'minTemp': 10.0, 'maxTemp': 20.0, 'minHumidity': 40.0, 'maxHumidity': 70.0, 'minWind': 0.0, 'maxWind': 15.0, 'tags': ['Formal', 'Business Casual']},
      'Brogues': {'minTemp': 10.0, 'maxTemp': 20.0, 'minHumidity': 40.0, 'maxHumidity': 70.0, 'minWind': 0.0, 'maxWind': 15.0, 'tags': ['Formal', 'Business Casual']},
      'Heels': {'minTemp': 15.0, 'maxTemp': 25.0, 'minHumidity': 30.0, 'maxHumidity': 60.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Formal', 'Party']},
      'Boots (Ankle)': {'minTemp': -10.0, 'maxTemp': 15.0, 'minHumidity': 40.0, 'maxHumidity': 80.0, 'minWind': 0.0, 'maxWind': 25.0, 'tags': ['Winter Wear', 'Casual']},
      'Boots (Knee-High)': {'minTemp': -10.0, 'maxTemp': 10.0, 'minHumidity': 20.0, 'maxHumidity': 100.0, 'minWind': 10.0, 'maxWind': 30.0, 'tags': ['Winter Wear', 'Formal']},
      'Sandals': {'minTemp': 25.0, 'maxTemp': 35.0, 'minHumidity': 20.0, 'maxHumidity': 50.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Casual', 'Summer Wear']},
      'Flip-Flops': {'minTemp': 25.0, 'maxTemp': 35.0, 'minHumidity': 20.0, 'maxHumidity': 50.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Beachwear', 'Casual']},
      'Sports Shoes': {'minTemp': 10.0, 'maxTemp': 30.0, 'minHumidity': 30.0, 'maxHumidity': 70.0, 'minWind': 0.0, 'maxWind': 20.0, 'tags': ['Sportswear', 'Outdoor Adventure']},
      'Hiking Boots': {'minTemp': 5.0, 'maxTemp': 20.0, 'minHumidity': 40.0, 'maxHumidity': 80.0, 'minWind': 1.0, 'maxWind': 25.0, 'tags': ['Outdoor Adventure', 'Winter Wear']},
      'Ballet Flats': {'minTemp': 15.0, 'maxTemp': 25.0, 'minHumidity': 30.0, 'maxHumidity': 60.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Casual', 'Formal']},
      'Moccasins': {'minTemp': 15.0, 'maxTemp': 25.0, 'minHumidity': 30.0, 'maxHumidity': 60.0, 'minWind': 0.0, 'maxWind': 10.0, 'tags': ['Casual', 'Business Casual']},
    };

    var range = predefinedRanges[subCategory] ?? {
      'minTemp': 0.0,
      'maxTemp': 0.0,
      'minHumidity': 0.0,
      'maxHumidity': 0.0,
      'minWind': 0.0,
      'maxWind': 0.0,
      'tags': ['General']
    };

    return ClothingItem(
      uniqueName: uniqueName,
      imagePath: imagePath,
      primaryCategory: primaryCategory,
      subCategory: subCategory,
      tags: List<String>.from(range['tags']),
      minTemperature: range['minTemp'],
      maxTemperature: range['maxTemp'],
      minHumidity: range['minHumidity'],
      maxHumidity: range['maxHumidity'],
      minWindSpeed: range['minWind'],
      maxWindSpeed: range['maxWind'],
      addedDate: addedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uniqueName': uniqueName,
      'imagePath': imagePath,
      'primaryCategory': primaryCategory,
      'subCategory': subCategory,
      'tags': tags,
      'minTemperature': minTemperature,
      'maxTemperature': maxTemperature,
      'minHumidity': minHumidity,
      'maxHumidity': maxHumidity,
      'minWindSpeed': minWindSpeed,
      'maxWindSpeed': maxWindSpeed,
      'addedDate': addedDate.toIso8601String(),
    };
  }

  factory ClothingItem.fromMap(Map<String, dynamic> map) {
    return ClothingItem(
      uniqueName: map['uniqueName'],
      imagePath: map['imagePath'],
      primaryCategory: map['primaryCategory'],
      subCategory: map['subCategory'],
      tags: List<String>.from(map['tags']),
      minTemperature: map['minTemperature'],
      maxTemperature: map['maxTemperature'],
      minHumidity: map['minHumidity'],
      maxHumidity: map['maxHumidity'],
      minWindSpeed: map['minWindSpeed'],
      maxWindSpeed: map['maxWindSpeed'],
      addedDate: DateTime.parse(map['addedDate']),
    );
  }

  String toJson() => json.encode(toMap());
  factory ClothingItem.fromJson(String source) => ClothingItem.fromMap(json.decode(source));
}