
class ApiConstants {
  static const String baseUrl = 'https://newsapi.org/v2';
  static const String apiKey = '2a3eb28f3687475c833ad29a6085fcb2';

  // API endpoint'leri
  static String getNewsByCategory(String category, {int page = 1}) {
    return '$baseUrl?q=$category&apiKey=$apiKey&page=$page&language=tr';
  }

  static String searchNews(String query, {int page = 1}) {
    return '$baseUrl?q=$query&apiKey=$apiKey&page=$page&language=tr';
  }
}
