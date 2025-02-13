import 'package:bundle_app/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import '../../model/article_model.dart';
import '../../services/news_service.dart';

class FeaturedViewModel extends ChangeNotifier {
  final NewsService _newsService;
  List<Article> articles = [];
  bool isLoading = false;
  String? error;

  FeaturedViewModel(this._newsService) {
    loadFeaturedNews();
  }

  Future<void> loadFeaturedNews() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final fetchedArticles = await _newsService.getNewsByCategory(
        NewsCategory.tumu,
      );

      articles = fetchedArticles;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
      print('Hata: $e');
    }
  }
}
