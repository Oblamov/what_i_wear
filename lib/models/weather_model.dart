class Weather {
  final String city;
  final String weatherCondition;
  final double temperature;
  final double humidity;
  final double windSpeed;

  Weather({
    required this.city,
    required this.weatherCondition,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['name'],
      weatherCondition: json['weather'][0]['description'],
      temperature: json['main']['temp'].toDouble(), // Already in Celsius
      humidity: json['main']['humidity'].toDouble(),
      windSpeed: json['wind']['speed'].toDouble(),
    );
  }
}
