import 'package:bundle_app/core/constants/api_constants.dart';
import 'package:dio/dio.dart';

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

class WeatherService {
  final Dio _dio = Dio();

  Future<WeatherData> getWeatherDetails() async {
    try {
      // Mevcut hava durumu
      final currentResponse = await _dio.get(
        '${ApiConstants.weatherBaseUrl}/weather',
        queryParameters: {
          'q': 'Istanbul',
          'appid': ApiConstants.weatherApiKey,
          'units': 'metric',
        },
      );

      // 5 günlük tahmin
      final forecastResponse = await _dio.get(
        '${ApiConstants.weatherBaseUrl}/forecast',
        queryParameters: {
          'q': 'Istanbul',
          'appid': ApiConstants.weatherApiKey,
          'units': 'metric',
        },
      );

      if (currentResponse.statusCode == 200 &&
          forecastResponse.statusCode == 200) {
        final List<HourlyWeather> hourlyList = [];
        final List<DailyWeather> dailyList = [];

        // Saatlik tahminleri işle
        for (var item in (forecastResponse.data['list'] as List).take(24)) {
          hourlyList.add(HourlyWeather(
            time:
                '${DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000).hour.toString().padLeft(2, '0')}:00',
            temperature: '${item['main']['temp'].round()}°',
            icon: item['weather'][0]['icon'],
          ));
        }

        // Günlük tahminleri işle
        var processedDays = <String>{};
        for (var item in forecastResponse.data['list']) {
          var date = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
          var dayName = _getDayName(date);

          if (!processedDays.contains(dayName) && dailyList.length < 5) {
            processedDays.add(dayName);
            dailyList.add(DailyWeather(
              day: dayName,
              temperature: '${item['main']['temp'].round()}°',
              icon: item['weather'][0]['icon'],
            ));
          }
        }

        return WeatherData(
          temperature: '${currentResponse.data['main']['temp'].round()}°',
          description: currentResponse.data['weather'][0]['description'],
          icon: currentResponse.data['weather'][0]['icon'],
          hourlyForecast: hourlyList,
          dailyForecast: dailyList,
        );
      }
      throw Exception('Veri alınamadı');
    } catch (e) {
      print('Hava durumu verisi alınamadı: $e');
      throw Exception('Hava durumu verisi alınamadı');
    }
  }

  String _getDayName(DateTime date) {
    final now = DateTime.now();
    if (date.day == now.day) return 'Bugün';

    final days = [
      'Pazartesi',
      'Salı',
      'Çarşamba',
      'Perşembe',
      'Cuma',
      'Cumartesi',
      'Pazar'
    ];
    return days[date.weekday - 1];
  }
}
