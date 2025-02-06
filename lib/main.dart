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
        useMaterial3: true,
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

class WeatherForecast {
  final String day;
  final String temperature;
  final String condition;

  WeatherForecast({
    required this.day,
    required this.temperature,
    required this.condition,
  });
}

class _WeatherHomePageState extends State<WeatherHomePage> with SingleTickerProviderStateMixin {
  final TextEditingController _cityController = TextEditingController();
  final Random _random = Random();
  String _cityName = "";
  String _temperature = "--°C";
  String _weatherCondition = "Unknown";
  List<WeatherForecast> _forecast = [];
  late TabController _tabController;

  final List<String> _weatherConditions = ['Sunny', 'Cloudy', 'Rainy'];
  final List<String> _daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  String _generateRandomTemperature() {
    int temp = _random.nextInt(16) + 15;
    return '${temp.toString()}°C';
  }

  String _generateRandomWeatherCondition() {
    return _weatherConditions[_random.nextInt(_weatherConditions.length)];
  }

  void _fetchWeather() {
    if (_cityController.text.isEmpty) {
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

  void _fetch7DayForecast() {
    if (_cityController.text.isEmpty) {
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
      _forecast = List.generate(
        7,
        (index) => WeatherForecast(
          day: _daysOfWeek[index],
          temperature: _generateRandomTemperature(),
          condition: _generateRandomWeatherCondition(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Info'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Current Weather'),
            Tab(text: '7-Day Forecast'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Current Weather Tab
          Padding(
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
          // 7-Day Forecast Tab
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
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
                  onPressed: _fetch7DayForecast,
                  child: const Text('Fetch 7-Day Forecast'),
                ),
                const SizedBox(height: 32),
                if (_cityName.isNotEmpty)
                  Text(
                    'Forecast for $_cityName',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: _forecast.length,
                    itemBuilder: (context, index) {
                      final forecast = _forecast[index];
                      return Card(
                        child: ListTile(
                          title: Text(forecast.day),
                          subtitle: Text(forecast.condition),
                          trailing: Text(
                            forecast.temperature,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}