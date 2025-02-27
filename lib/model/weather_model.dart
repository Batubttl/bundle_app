class WeatherData {
  final String temperature;
  final String description;
  final String icon;
  final List<HourlyWeather> hourlyForecast;
  final List<DailyWeather> dailyForecast;

  WeatherData({
    required this.temperature,
    required this.description,
    required this.icon,
    required this.hourlyForecast,
    required this.dailyForecast,
  });
}

class HourlyWeather {
  final String time;
  final String temperature;
  final String icon;

  HourlyWeather({
    required this.time,
    required this.temperature,
    required this.icon,
  });
}

class DailyWeather {
  final String day;
  final String temperature;
  final String icon;

  DailyWeather({
    required this.day,
    required this.temperature,
    required this.icon,
  });
}
