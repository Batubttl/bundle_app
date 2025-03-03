class ApiConstants {
  static const String baseUrl = 'https://newsapi.org/v2';
  static const String apiKey = '2a3eb28f3687475c833ad29a6085fcb2';

  static const String weatherBaseUrl =
      'https://api.openweathermap.org/data/2.5';
  static const String weatherApiKey = '1591d9e0f1306f40414f5001a56737ea';
  static const String weatherIconBaseUrl = 'https://openweathermap.org/img/w';

  static const String currencyBaseUrl = 'https://v6.exchangerate-api.com/v6';
  static const String currencyApiKey = 'cf8e52206f0dc198db9822c6';

  static const Map<String, String> categoryQueries = {
    'tumu': '(türkiye OR türk OR ankara OR istanbul)',
    'gundem': '(gündem OR siyaset OR politika)',
  };

  static String getCurrencyRate() {
    return '$currencyBaseUrl/$currencyApiKey/latest/USD';
  }

  static String getNewsByCategory(String category, {int page = 1}) {
    return '$baseUrl?q=$category&apiKey=$apiKey&page=$page&language=tr';
  }

  static String searchNews(String query, {int page = 1}) {
    return '$baseUrl?q=$query&apiKey=$apiKey&page=$page&language=tr';
  }
}
