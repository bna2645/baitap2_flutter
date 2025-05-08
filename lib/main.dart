import 'package:flutter/material.dart';
import 'models/hourly_weather.dart';
import 'services/weather_service.dart';

void main() => runApp(const WeatherApp());

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WeatherScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final service = WeatherService();
  late Future<List<HourlyWeather>> futureWeather;

  @override
  void initState() {
    super.initState();
    futureWeather = service.fetchHourlyWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dự báo thời tiết 24 giờ")),
      body: FutureBuilder<List<HourlyWeather>>(
        future: futureWeather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          } else {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return ListTile(
                  leading: Image.network(
                    'https://openweathermap.org/img/wn/${item.icon}@2x.png',
                  ),
                  title: Text(
                    '${item.time.hour}:00 - ${item.temperature.toStringAsFixed(1)}°C',
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
