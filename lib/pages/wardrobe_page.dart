import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/clothing_item.dart';

class WardrobePage extends StatefulWidget {
  @override
  _WardrobePageState createState() => _WardrobePageState();
}

class _WardrobePageState extends State<WardrobePage> {
  final picker = ImagePicker();
  List<ClothingItem> wardrobe = [];
  File? _selectedImage;
  String _selectedCategory = 'Upper Body';
  String _selectedSubCategory = 'T-Shirt';
  String _selectedCategoryTitle = 'Select Category';
  String _selectedSubCategoryTitle = 'Select Subcategory';


  final Map<String, List<String>> categoryMap = {
    // 🌟 Upper Body
    'Upper Body': [
      'T-Shirt',
      'Crop Top',
      'Blouse',
      'Tank Top',
      'Camisole',
      'Shirt',
      'Polo Shirt',
      'Hoodie',
      'Sweatshirt',
      'Jacket',
      'Blazer',
      'Coat',
      'Cardigan',
      'Dress Shirt',
      'Suit Jacket',
      'Waistcoat',
      'Tunic',
      'Corset',
      'Kimono',
      'Poncho',
    ],

    // 🌟 Lower Body
    'Lower Body': [
      'Jeans',
      'Trousers',
      'Leggings',
      'Cargo Pants',
      'Sweatpants',
      'Mini Skirt',
      'Midi Skirt',
      'Maxi Skirt',
      'Pencil Skirt',
      'Casual Shorts',
      'Bermuda Shorts',
      'Cycling Shorts',
      'Overalls',
      'Jumpsuit',
    ],

    // 🌟 Full Body
    'Full Body': [
      'Casual Dress',
      'Evening Dress',
      'Maxi Dress',
      'Cocktail Dress',
      'Casual Romper',
      'Dressy Romper',
      'Casual Jumpsuit',
      'Formal Jumpsuit',
      'Formal Suit',
      'Casual Suit',
    ],

    // 🌟 Headwear
    'Headwear': [
      'Cap',
      'Beanie',
      'Beret',
      'Fedora',
      'Top Hat',
      'Bowler Hat',
      'Sun Hat',
      'Bucket Hat',
      'Winter Hat',
      'Turban',
      'Veil',
    ],

    // 🌟 Accessories
    'Accessories': [
      'Scarf',
      'Tie',
      'Bowtie',
      'Gloves',
      'Mittens',
      'Sunglasses',
      'Prescription Glasses',
      'Necklace',
      'Bracelet',
      'Rings',
      'Earrings',
      'Waist Belt',
      'Suspender Belt',
      'Backpack',
      'Handbag',
      'Clutch Bag',
      'Tote Bag',
    ],

    // 🌟 Footwear
    'Footwear': [
      'Sneakers',
      'Loafers',
      'Oxfords',
      'Brogues',
      'Heels',
      'Boots (Ankle)',
      'Boots (Knee-High)',
      'Sandals',
      'Flip-Flops',
      'Sports Shoes',
      'Hiking Boots',
      'Ballet Flats',
      'Moccasins',
    ],
  };
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadWardrobe();
    });
  }
  bool _isUniqueName(String uniqueName) {
    return wardrobe.every((item) => item.uniqueName != uniqueName);
  }

  /// Kategorilere ve alt kategorilere göre kıyafetleri gruplar
  Map<String, Map<String, List<ClothingItem>>> _groupWardrobeItems() {
    Map<String, Map<String, List<ClothingItem>>> groupedWardrobe = {};

    for (var item in wardrobe) {
      if (!groupedWardrobe.containsKey(item.primaryCategory)) {
        groupedWardrobe[item.primaryCategory] = {};
      }

      if (!groupedWardrobe[item.primaryCategory]!.containsKey(item.subCategory)) {
        groupedWardrobe[item.primaryCategory]![item.subCategory] = [];
      }

      groupedWardrobe[item.primaryCategory]![item.subCategory]!.add(item);
    }

    return groupedWardrobe;
  }

  Future<void> _loadWardrobe() async {
    final prefs = await SharedPreferences.getInstance();
    final wardrobeData = prefs.getStringList('wardrobe');

    if (wardrobeData != null) {
      try {
        setState(() {
          wardrobe = wardrobeData
              .map((item) => ClothingItem.fromJson(item))
              .toList();
        });
      } catch (e) {
        print('❌ Failed to load wardrobe: $e');

        // Eğer dönüşüm başarısızsa eski veriyi temizle
        await prefs.remove('wardrobe');
      }
    } else {
      print('ℹ️ No wardrobe data found.');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  Future<void> _saveClothingItem({required String uniqueName}) async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select an image before saving!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (!_isUniqueName(uniqueName)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('This name is already used. Please choose another name!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
      final imageFile = await _selectedImage!.copy(imagePath);

      final newItem = ClothingItem.withPredefinedValues(
        uniqueName: uniqueName,
        imagePath: imageFile.path,
        primaryCategory: _selectedCategory,
        subCategory: _selectedSubCategory,
        addedDate: DateTime.now(),
      );

      wardrobe.add(newItem);
      await _saveWardrobe();

      setState(() {
        _selectedImage = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Clothing item saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('❌ Failed to save clothing item: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save clothing item: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
  Future<void> _saveWardrobe() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> wardrobeData = wardrobe.map((item) => item.toJson()).toList();
      await prefs.setStringList('wardrobe', wardrobeData);
      print('✅ Wardrobe saved successfully.');
    } catch (e) {
      print('❌ Failed to save wardrobe: $e');
    }
  }

  //Bu methodu bi kez çalıştır ve sil
  Future<void> _clearWardrobeData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('wardrobe');
    print('✅ Wardrobe data cleared.');
  }
  Future<void> _debugWardrobeData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.get('wardrobe');
    print('🛠️ Debug Wardrobe Data: $data');
  }

  Future<void> _deleteClothingItem(int index) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> wardrobeData = prefs.getStringList('wardrobe') ?? [];

      setState(() {
        wardrobe.removeAt(index);
        wardrobeData.removeAt(index);

        // Reset dropdown values if the selected item no longer exists
        if (!categoryMap[_selectedCategory]!.contains(_selectedSubCategory)) {
          _selectedCategory = 'Upper Body';
          _selectedSubCategory = categoryMap[_selectedCategory]!.first;
        }
      });

      await prefs.setStringList('wardrobe', wardrobeData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item deleted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete item: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    var groupedWardrobe = _groupWardrobeItems();
    if (!categoryMap.keys.contains(_selectedCategory)) {
      _selectedCategory = 'Upper Body';
      _selectedSubCategory = categoryMap[_selectedCategory]!.first;
    }
    if (!categoryMap[_selectedCategory]!.contains(_selectedSubCategory)) {
      _selectedSubCategory = categoryMap[_selectedCategory]!.first;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wardrobe',
          style: TextStyle(
            fontSize: 18,

            fontWeight: FontWeight.bold,
            color: Colors.white, // White text
          ),
        ),
        backgroundColor: Colors.grey[900], // Dark grey app bar
        iconTheme: IconThemeData(color: Colors.white), // Back button and other icons to white
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white,),
            tooltip: 'Reset Wardrobe Data',
            onPressed: _clearWardrobeData,
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[850], // Dark grey background
        child: groupedWardrobe.isEmpty
            ? Center(
          child: Text(
            'No items in your wardrobe yet.',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white, // White text
            ),
          ),
        )
            : ListView.builder(
          itemCount: groupedWardrobe.keys.length,
          itemBuilder: (context, categoryIndex) {
            String category = groupedWardrobe.keys.elementAt(categoryIndex);
            Map<String, List<ClothingItem>> subCategories =
            groupedWardrobe[category]!;

            return ExpansionTile(
              title: Text(
                category,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // White text
                ),
              ),
              children: subCategories.keys.map((subCategory) {
                return ExpansionTile(
                  title: Text(
                    subCategory,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white, // White text
                    ),
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white, // White text
                        ),
                      ),
                      subtitle: Text(
                        item.tags.join(', '),
                        style: TextStyle(color: Colors.white70), // Slightly faded white
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteClothingItem(wardrobe.indexOf(item)),
                      ),
                      onTap: () => _showItemDetails(item),
                    );
                  }).toList(),
                );
              }).toList(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddClothingDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
  void _showItemDetails(ClothingItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${item.primaryCategory} - ${item.subCategory}'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display Item Image
                Center(
                  child: Image.file(
                    File(item.imagePath),
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 16),

                // Display Weather Details
                Text(
                  '🌡️ Temperature: ${item.minTemperature}°C - ${item.maxTemperature}°C',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  '💧 Humidity: ${item.minHumidity}% - ${item.maxHumidity}%',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  '💨 Wind Speed: ${item.minWindSpeed} km/h - ${item.maxWindSpeed} km/h',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 16),

                // Display Tags
                Text(
                  '🏷️ Tags: ${item.tags.join(", ")}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
  void _showAddClothingDialog() {
    TextEditingController nameController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Enter Unique Name', style: TextStyle(fontSize: 16)),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Unique Name',
                      hintText: 'Enter a unique name for the clothing item',
                    ),
                  ),
                  SizedBox(height: 10),

                  Text('Select Category', style: TextStyle(fontSize: 16)),
                  DropdownButton<String>(
                    value: _selectedCategory,
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                        _selectedSubCategory = categoryMap[_selectedCategory]!.first;
                      });
                    },
                    items: categoryMap.keys.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                  ),
                  Text('Select Subcategory', style: TextStyle(fontSize: 16)),
                  DropdownButton<String>(
                    value: _selectedSubCategory,
                    onChanged: (value) {
                      setState(() {
                        _selectedSubCategory = value!;
                      });
                    },
                    items: categoryMap[_selectedCategory]!.map((subCategory) {
                      return DropdownMenuItem(
                        value: subCategory,
                        child: Text(subCategory),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10),

                  Text('Upload Image', style: TextStyle(fontSize: 16)),
                  _selectedImage != null
                      ? Center(
                    child: Image.file(
                      _selectedImage!,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                      : Center(
                    child: Placeholder(
                      fallbackHeight: 150,
                      fallbackWidth: double.infinity,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.camera),
                        icon: Icon(Icons.camera_alt),
                        label: Text('Camera'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        icon: Icon(Icons.photo),
                        label: Text('Gallery'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (nameController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please enter a unique name!'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        await _saveClothingItem(uniqueName: nameController.text);
                        Navigator.of(context).pop();
                      },
                      child: Text('Save Clothing Item'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}