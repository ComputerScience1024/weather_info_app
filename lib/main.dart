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

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> with SingleTickerProviderStateMixin {
  final TextEditingController _cityController = TextEditingController();
  final Random _random = Random();
  late TabController _tabController;
  String _cityName = "";
  String _temperature = "--°C";
  String _weatherCondition = "Unknown";
  List<WeatherForecast> _forecast = [];
  bool _hasData = false;

  final List<String> _weatherConditions = ['Sunny', 'Cloudy', 'Rainy'];
  final List<String> _daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  final Map<String, IconData> _weatherIcons = {
    'Sunny': Icons.wb_sunny,
    'Cloudy': Icons.cloud,
    'Rainy': Icons.beach_access,
  };

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
      _hasData = true;
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
      _hasData = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Info'),
        elevation: 2,
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _cityController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter City Name',
                            prefixIcon: Icon(Icons.location_city),
                          ),
                          textCapitalization: TextCapitalization.words,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _fetchWeather,
                          icon: const Icon(Icons.search),
                          label: const Text('Fetch Weather'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (_hasData) ...[
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            _cityName,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Icon(
                                    _weatherIcons[_weatherCondition],
                                    size: 48,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _weatherCondition,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                _temperature,
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // 7-Day Forecast Tab
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _cityController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter City Name',
                            prefixIcon: Icon(Icons.location_city),
                          ),
                          textCapitalization: TextCapitalization.words,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _fetch7DayForecast,
                          icon: const Icon(Icons.calendar_today),
                          label: const Text('Fetch 7-Day Forecast'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (_cityName.isNotEmpty)
                  Text(
                    'Forecast for $_cityName',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: _forecast.length,
                    itemBuilder: (context, index) {
                      final forecast = _forecast[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Icon(
                            _weatherIcons[forecast.condition],
                            color: Colors.blue,
                          ),
                          title: Text(forecast.day),
                          subtitle: Text(forecast.condition),
                          trailing: Text(
                            forecast.temperature,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
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