import 'package:flutter/material.dart';
import '../services/weather_service.dart';

class WeatherViewModel extends ChangeNotifier {
  final WeatherService _weatherService;

  WeatherViewModel(this._weatherService);

  WeatherData? weatherData;
  bool isLoading = false;
  String? error;

  Future<void> getWeatherDetails() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      weatherData = await _weatherService.getWeatherDetails();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
