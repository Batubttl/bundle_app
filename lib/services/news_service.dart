import 'package:bundle_app/model/article_model.dart';
import '../core/constants/app_constants.dart';
import 'package:dio/dio.dart';
import '../core/network/api_client.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

//TODO : Refactor
class NewsService {
  final ApiClient _apiClient;
  static const String baseUrl = 'https://newsapi.org/v2';
  static const String apiKey = 'c01000e7c81c40f890d0e4a6400fad53';

  NewsService(this._apiClient);

  // Her kategorinin özel domain'leri
  final Map<NewsCategory, List<String>> _categoryDomains = {
    NewsCategory.gundem: ['hurriyet.com.tr', 'milliyet.com.tr', 'sabah.com.tr'],
    NewsCategory.spor: ['sporx.com', 'fanatik.com.tr', 'ntvspor.net'],
    NewsCategory.teknoloji: [
      'webtekno.com',
      'shiftdelete.net',
      'donanimhaber.com'
    ],
    NewsCategory.bilim: ['bilimfili.com', 'populerbilim.com.tr'],
  };

  Future<List<Article>> getNewsByCategory(NewsCategory category,
      {int page = 1}) async {
    try {
      print('Fetching news for category: ${category.toString()}, page: $page');

      final response = await _apiClient.dio.get(
        '$baseUrl/everything',
        queryParameters: {
          'q': _getCategoryQuery(category),
          'language': 'tr',
          'sortBy': 'publishedAt',
          'pageSize': 20,
          'page': page,
          'apiKey': apiKey,
        },
      );

      print('API Response Status: ${response.statusCode}');
      print('API Response Data: ${response.data}');

      final articles = _parseResponse(response, category);
      return articles;
    } catch (e) {
      print('Detailed error in getNewsByCategory: $e');
      if (e is DioException) {
        print('DioError type: ${e.type}');
        print('DioError message: ${e.message}');
        print('DioError response: ${e.response}');
      }
      rethrow;
    }
  }

  String _getCategoryQuery(NewsCategory category) {
    switch (category) {
      case NewsCategory.tumu:
        return '(türkiye OR türk OR ankara OR istanbul)';
      case NewsCategory.gundem:
        return '(gündem OR siyaset OR politika)';
      case NewsCategory.spor:
        return '(spor OR futbol OR basketbol OR fenerbahçe OR galatasaray OR beşiktaş)';
      case NewsCategory.teknoloji:
        return '(teknoloji OR yazılım OR bilişim OR yapay zeka)';
      case NewsCategory.bilim:
        return '(bilim OR uzay OR araştırma OR keşif)';
      case NewsCategory.ekonomi:
        return '(ekonomi OR finans OR borsa OR dolar OR altın)';
      case NewsCategory.eglence:
        return '(magazin OR sinema OR dizi OR müzik)';
    }
  }

  Future<List<Article>> searchNews(String keyword) async {
    if (keyword.trim().isEmpty) return [];

    try {
      print('Searching news with keyword: $keyword');

      final response = await _apiClient.dio.get(
        '$baseUrl/everything',
        queryParameters: {
          'q': keyword,
          'language': 'tr',
          'sortBy': 'publishedAt',
          'pageSize': 20,
          'apiKey': apiKey,
        },
      );

      print('Search Response Status: ${response.statusCode}');
      print('Search Response Data: ${response.data}');

      final articles = _parseResponse(response, NewsCategory.tumu);
      return articles;
    } catch (e) {
      print('Detailed error in searchNews: $e');
      if (e is DioException) {
        print('DioError type: ${e.type}');
        print('DioError message: ${e.message}');
        print('DioError response: ${e.response}');
      }
      rethrow;
    }
  }

  List<Article> _parseResponse(Response response, NewsCategory category) {
    if (response.statusCode == 200) {
      final data = response.data;
      if (data['status'] == 'ok') {
        final List<dynamic> articles = data['articles'];
        return articles
            .where((article) =>
                article['title'] != null &&
                article['urlToImage'] != null &&
                article['description'] != null)
            .map((json) => Article.fromJson(json, category))
            .toList();
      }
    }
    print('Parse error - Status Code: ${response.statusCode}');
    print('Parse error - Response Data: ${response.data}');
    return [];
  }

  // TODO : Extension / Sete çevirilebilir.
  List<Article> _removeDuplicates(List<Article> articles) {
    final uniqueArticles = <Article>[];
    final seenUrls = <String>{};

    for (var article in articles) {
      if (!seenUrls.contains(article.url)) {
        seenUrls.add(article.url);
        uniqueArticles.add(article);
      }
    }

    return uniqueArticles;
  }

  // TODO : Extension
  String _normalizeText(String text) {
    // Başlıktaki özel karakterleri ve boşlukları kaldır
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  String _normalizeUrl(String url) {
    // URL'deki query parametrelerini kaldır
    final uri = Uri.parse(url);
    return '${uri.scheme}://${uri.host}${uri.path}';
  }

  // TODO : Enum
  String _getCategoryKeywords(NewsCategory category) {
    switch (category) {
      case NewsCategory.tumu:
        return '';
      case NewsCategory.gundem:
        return '(türkiye) AND (gündem OR siyaset OR haber)';
      case NewsCategory.spor:
        return '(spor OR futbol OR basketbol) AND (türkiye)';
      case NewsCategory.teknoloji:
        return '(teknoloji OR yazılım OR bilişim OR yapay zeka)';
      case NewsCategory.bilim:
        return '(bilim OR uzay OR keşif OR nasa OR araştırma)';
      case NewsCategory.eglence:
        return '(magazin OR sinema OR dizi OR müzik OR sanat)';
      case NewsCategory.ekonomi:
        return '(ekonomi OR finans OR borsa OR dolar OR altın)';
    }
  }
  //extension

  String _getApiCategory(NewsCategory category) {
    switch (category) {
      case NewsCategory.tumu:
        return 'general';
      case NewsCategory.gundem:
        return 'general';
      case NewsCategory.spor:
        return 'sports';
      case NewsCategory.teknoloji:
        return 'technology';
      case NewsCategory.bilim:
        return 'science';
      case NewsCategory.eglence:
        return 'entertainment';
      case NewsCategory.ekonomi:
        return 'business';
    }
  }

  Future<List<Article>> getTopHeadlines() async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/top-headlines?country=tr&pageSize=20&apiKey=$apiKey',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> articles = data['articles'];
        return articles
            .map((json) => Article.fromJson(
                  json,
                  NewsCategory.tumu,
                ))
            .toList();
      } else {
        throw Exception('Popüler haberler yüklenemedi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Popüler haberler yüklenemedi: $e');
    }
  }

  Future<List<Article>> getFeaturedNews() async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/top-headlines?country=tr&sortBy=popularity&pageSize=10&apiKey=$apiKey',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> articles = data['articles'];
        return articles
            .map((json) => Article.fromJson(
                  json,
                  NewsCategory.tumu,
                ))
            .toList();
      } else {
        throw Exception(
            'Öne çıkan haberler yüklenemedi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Öne çıkan haberler yüklenemedi: $e');
    }
  }

  // String kategoriyi NewsCategory enum'ına çeviren yardımcı metod
  NewsCategory _getCategoryFromString(String category) {
    switch (category.toLowerCase()) {
      case 'general':
        return NewsCategory.tumu;
      case 'business':
        return NewsCategory.ekonomi;
      case 'technology':
        return NewsCategory.teknoloji;
      case 'science':
        return NewsCategory.bilim;
      case 'entertainment':
        return NewsCategory.eglence;
      case 'sports':
        return NewsCategory.spor;
      default:
        return NewsCategory.tumu;
    }
  }
}

class NewsResponse {
  final List<Article> articles;
  final int totalResults;
  final bool hasMore;

  NewsResponse({
    required this.articles,
    required this.totalResults,
    required this.hasMore,
  });
}
