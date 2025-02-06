import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final TextEditingController _cityController = TextEditingController();
  final Random _random = Random();
  String _cityName = "";
  String _temperature = "--°C";
  String _weatherCondition = "Unknown";

  // List of possible weather conditions
  final List<String> _weatherConditions = ['Sunny', 'Cloudy', 'Rainy'];

  // Generate random temperature between 15°C and 30°C
  String _generateRandomTemperature() {
    int temp = _random.nextInt(16) + 15; // Random number between 15 and 30
    return '${temp.toString()}°C';
  }

  // Select random weather condition
  String _generateRandomWeatherCondition() {
    return _weatherConditions[_random.nextInt(_weatherConditions.length)];
  }

  void _fetchWeather() {
    if (_cityController.text.isEmpty) {
      // Show error if city name is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a city name'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _cityName = _cityController.text;
      _temperature = _generateRandomTemperature();
      _weatherCondition = _generateRandomWeatherCondition();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather Info')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter City Name',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchWeather,
              child: const Text('Fetch Weather'),
            ),
            const SizedBox(height: 32),
            Text(
              'City: $_cityName',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Temperature: $_temperature',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Condition: $_weatherCondition',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}