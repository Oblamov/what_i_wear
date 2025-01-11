import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:http/http.dart' as http;

class NotificationManager {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  NotificationManager() {
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    bool? initialized = await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        final String? payload = response.payload;
        if (payload != null) {
          print('Notification payload: $payload');
          // Handle the payload (e.g., navigate to a specific screen)
        }
      },
    );
    if (initialized == true) {
      print("Notifications initialized successfully.");
    } else {
      print("Notifications initialization failed.");
    }

    tz.initializeTimeZones();
  }


  Future<void> saveCity(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_city', cityName);
  }

  Future<String?> getLastCity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('last_city');
  }

  Future<String> fetchWeather(String cityName) async {
    final apiKey = 'ae245924e7e70054ad9ca23543ae25c7'; // OpenWeatherMap API key
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return "Bugün ${data['weather'][0]['description']}, sıcaklık: ${data['main']['temp']}°C";
      } else {
        return 'Hava durumu alınamadı. Lütfen şehri kontrol edin.';
      }
    } catch (e) {
      return 'Bir hata oluştu: $e';
    }
  }

  Future<void> scheduleDailyWeatherNotification(String cityName) async {
    final weatherMessage = await fetchWeather(cityName);
    final scheduledTime = _nextInstanceOfTime(8, 0); // Schedule for 8:00 AM

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Günlük Hava Durumu',
      weatherMessage,
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_weather_channel',
          'Günlük Hava',
          channelDescription: 'Günlük hava durumu bildirimleri',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'Daily weather update',
    );
  }

  Future<void> showLoginNotification() async {
    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Login Successful', // Title
      'Successfully logged in', // Body
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'login_channel',
          'Login Notifications',
          channelDescription: 'Notifications for successful logins',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      payload: 'Login notification',
    );
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
