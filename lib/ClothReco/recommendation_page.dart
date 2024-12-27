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
    weatherCondition = weatherCondition.toLowerCase();

    if (weatherCondition == 'rain' || weatherCondition == 'drizzle') {
      if (temperature <= 15) {
        return 'Yağmurluk, su geçirmez bot ve kalın giysiler giyin.';
      } else {
        return 'Yağmurluk, hafif giysiler ve su geçirmez ayakkabılar tercih edin.';
      }
    } else if (weatherCondition == 'thunderstorm') {
      return 'Dışarı çıkmaktan kaçının! Sağlam ayakkabılar ve su geçirmez mont giyin.';
    } else if (weatherCondition == 'snow') {
      return 'Kalın mont, atkı, bere ve su geçirmez bot giyin.';
    } else if (weatherCondition == 'mist' || weatherCondition == 'fog' || weatherCondition == 'haze') {
      return 'Görüş mesafesi düşük olabilir. Yansıtıcı giysiler ve dikkatli olun.';
    } else if (weatherCondition == 'clouds') {
      if (temperature <= 15) {
        return 'Hafif mont ve uzun kollu giysiler tercih edin.';
      } else {
        return 'Hafif giysiler ve ince bir ceket tercih edin.';
      }
    } else if (weatherCondition == 'clear') {
      if (temperature <= 15) {
        return 'Hafif mont ve kalın giysiler giyin.';
      } else if (temperature <= 25) {
        return 'Uzun kollu giysiler ve hafif mont tercih edin.';
      } else if (temperature <= 35) {
        return 'T-shirt, şort ve güneş gözlüğü takın.';
      } else {
        return 'Çok sıcak! Hafif, nefes alabilir giysiler tercih edin ve bol su için.';
      }
    } else if (weatherCondition == 'windy' || weatherCondition == 'squall') {
      if (temperature <= 15) {
        return 'Rüzgarlık ve kalın giysiler tercih edin.';
      } else {
        return 'Hafif rüzgarlık ve rahat giysiler tercih edin.';
      }
    } else if (weatherCondition == 'smoke' || weatherCondition == 'sand' || weatherCondition == 'dust') {
      return 'Koruyucu maske takın ve mümkünse dışarı çıkmaktan kaçının.';
    } else if (weatherCondition == 'hot') {
      return 'Çok sıcak hava! Hafif ve nefes alabilir giysiler tercih edin, bol su için.';
    } else if (weatherCondition == 'cold') {
      return 'Çok soğuk hava! Kalın mont, bere ve eldiven kullanın.';
    } else if (weatherCondition == 'tornado') {
      return 'Acil durum uyarılarını takip edin ve güvenli bir alana sığının.';
    } else {
      return 'Bu hava durumu için özel bir öneri yok.';
    }
  }



}
