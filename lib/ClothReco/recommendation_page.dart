import 'package:flutter/material.dart';

class RecommendationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    String weather = args['weather'] ?? 'Bilinmiyor';
    double temperature = args['temperature'] ?? 0.0;

    String recommendation = getOutfitRecommendation(weather, temperature);

    return Scaffold(
      appBar: AppBar(title: Text('Kıyafet Önerisi')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Hava Durumu: $weather', style: TextStyle(fontSize: 18)),
              Text('Sıcaklık: ${temperature.toStringAsFixed(1)}°C',
                  style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              Text(
                recommendation,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
                child: Text('Başa Dön'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getOutfitRecommendation(String weatherCondition, double temperature) {
    if (weatherCondition == 'Yağmurlu' || weatherCondition.toLowerCase() == 'rainy') {
      if (temperature <= 15) {
        return 'Yağmurluk, su geçirmez bot ve kalın giysiler giyin.';
      } else {
        return 'Yağmurluk, hafif giysiler ve su geçirmez ayakkabılar tercih edin.';
      }
    } else if (weatherCondition == 'Karlı' || weatherCondition.toLowerCase() == 'snowy') {
      return 'Kalın mont, atkı, bere ve su geçirmez bot giyin.';
    } else if (weatherCondition == 'Rüzgarlı' || weatherCondition.toLowerCase() == 'windy') {
      if (temperature <= 15) {
        return 'Rüzgarlık ve kalın giysiler tercih edin.';
      } else {
        return 'Hafif rüzgarlık ve rahat giysiler tercih edin.';
      }
    } else if (weatherCondition == 'Güneşli' || weatherCondition.toLowerCase() == 'sunny') {
      if (temperature <= 15) {
        return 'Kalın giysiler ve hafif mont giyin.';
      } else if (temperature <= 35) {
        return 'T-shirt, şort ve güneş gözlüğü takın.';
      } else {
        return 'Çok sıcak! Hafif, nefes alabilir giysiler tercih edin.';
      }
    } else {
      return 'Geçersiz hava durumu bilgisi.';
    }
  }

}
