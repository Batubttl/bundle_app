import 'package:bundle_app/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import '../../model/article_model.dart';
import '../../services/news_service.dart';
import 'package:get_it/get_it.dart';

class FeaturedViewModel extends ChangeNotifier {
  final NewsService _newsService = GetIt.I<NewsService>();

  List<Article> _articles = [];
  bool _isLoading = true;
  String? _error;

  // Getter'lar
  List<Article> get articles => _articles;
  bool get isLoading => _isLoading;
  String? get error => _error;

  FeaturedViewModel() {
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Tüm haberleri çek
      _articles = await _newsService.getNewsByCategory(NewsCategory.tumu);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error in _initializeData: $e');
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Story getirme metodları
  List<Article> getFeaturedStories() {
    return _articles
        .where((article) => article.category == NewsCategory.tumu)
        .take(5)
        .toList();
  }

  List<Article> getLatestStories() {
    // Son 5 haberi al, kategori farketmeksizin
    return _articles.take(5).toList();
  }

  List<Article> getScienceStories() {
    return _articles
        .where((article) => article.category == NewsCategory.bilim)
        .take(5)
        .toList();
  }

  // Story görüntülenme durumunu işaretleme
  void markCategoryAsViewed(String categoryId) {
    // İleride kullanılabilir
    notifyListeners();
  }
}
