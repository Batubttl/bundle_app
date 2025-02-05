import 'dart:convert';
import 'package:bundle_app/core/constants/api_constants.dart';
import 'package:bundle_app/model/article_model.dart';
import 'package:http/http.dart' as http;
import '../core/constants/app_constants.dart';
import 'package:dio/dio.dart';
import '../core/network/api_client.dart';
import '../core/extensions/news_category_extension.dart';

class NewsService {
  final ApiClient _apiClient;
  static const String baseUrl = 'https://newsapi.org/v2';
  static const String apiKey = '2a3eb28f3687475c833ad29a6085fcb2';

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

      return _parseResponse(response, category);
    } catch (e) {
      print('Error in getNewsByCategory: $e');
      throw Exception('Haberler yüklenirken bir hata oluştu');
    }
  }

  String _getCategoryQuery(NewsCategory category) {
    switch (category) {
      case NewsCategory.tumu:
        return '(gündem OR spor OR ekonomi OR teknoloji OR siyaset OR magazin)';
      case NewsCategory.gundem:
        return '(gündem OR siyaset OR politika)';
      case NewsCategory.spor:
        return '(spor OR futbol OR basketbol OR fenerbahçe OR galatasaray OR beşiktaş)';
      case NewsCategory.teknoloji:
        return '(teknoloji OR yazılım OR bilişim OR yapay zeka OR mobil)';
      case NewsCategory.bilim:
        return '(bilim OR uzay OR araştırma OR keşif)';
      case NewsCategory.ekonomi:
        return '(ekonomi OR finans OR borsa OR dolar OR altın)';
      case NewsCategory.eglence:
        return '(magazin OR sinema OR dizi OR müzik OR eğlence)';
    }
  }

  Future<List<Article>> searchNews(String keyword) async {
    if (keyword.trim().isEmpty) return [];

    try {
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

      final articles = _parseResponse(response, NewsCategory.tumu);
      return articles;
    } catch (e) {
      print('Error in searchNews: $e');
      throw Exception('Arama yapılırken bir hata oluştu');
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
    return [];
  }

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

//extension
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
