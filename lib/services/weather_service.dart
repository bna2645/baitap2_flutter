import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/hourly_weather.dart';

class WeatherService {
  final String apiKey = 'eee3af494508d9f551fc5119b374bcdd';
  final double lat = 10.762622; // Tọa độ mẫu (TP.HCM)
  final double lon = 106.660172;

  Future<List<HourlyWeather>> fetchHourlyWeather() async {
    final url =
        'https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lon&exclude=current,minutely,daily,alerts&units=metric&appid=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> hourlyData = data['hourly'];
      return hourlyData
          .take(24)
          .map((e) => HourlyWeather.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
