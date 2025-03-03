import 'package:bundle_app/core/constants/app_constants.dart';
import 'package:bundle_app/core/enum/news_category_enum.dart';
import 'package:bundle_app/model/article_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../core/network/api_client.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsService {
  final ApiClient _apiClient;
  static const String baseUrl = 'https://newsapi.org/v2';
  static const String apiKey = 'c01000e7c81c40f890d0e4a6400fad53';

  NewsService(this._apiClient);

  Future<List<Article>> getNewsByCategory(NewsCategory category,
      {int page = 1}) async {
    try {
      debugPrint(
          'Fetching news for category: ${category.toString()}, page: $page');

      final response = await _apiClient.dio.get(
        '$baseUrl/everything',
        queryParameters: {
          'q': category.queryString,
          'language': 'tr',
          'sortBy': 'publishedAt',
          'pageSize': 20,
          'page': page,
          'apiKey': apiKey,
        },
      );

      debugPrint('API Response Status: ${response.statusCode}');
      debugPrint('API Response Data: ${response.data}');

      final articles = _parseResponse(response, category);
      return articles;
    } catch (e) {
      debugPrint('Detailed error in getNewsByCategory: $e');
      if (e is DioException) {
        debugPrint('DioError type: ${e.type}');
        debugPrint('DioError message: ${e.message}');
        debugPrint('DioError response: ${e.response}');
      }
      rethrow;
    }
  }

  Future<List<Article>> searchNews(String keyword) async {
    if (keyword.trim().isEmpty) return [];

    try {
      debugPrint('Searching news with keyword: $keyword');

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

      debugPrint('Search Response Status: ${response.statusCode}');
      debugPrint('Search Response Data: ${response.data}');

      final articles = _parseResponse(response, NewsCategory.tumu);
      return articles;
    } catch (e) {
      debugPrint('Detailed error in searchNews: $e');
      if (e is DioException) {
        debugPrint('DioError type: ${e.type}');
        debugPrint('DioError message: ${e.message}');
        debugPrint('DioError response: ${e.response}');
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
    debugPrint('Parse error - Status Code: ${response.statusCode}');
    debugPrint('Parse error - Response Data: ${response.data}');
    return [];
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
        throw Exception(
            '${AppStrings.popularNewsError}: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('${AppStrings.popularNewsError}: $e');
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
