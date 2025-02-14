import 'package:bundle_app/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import '../../model/article_model.dart';
import '../../services/news_service.dart';
import 'package:get_it/get_it.dart';

class FeaturedViewModel extends ChangeNotifier {
  final NewsService _newsService = GetIt.I<NewsService>();

  Map<NewsCategory, List<Article>> _categoryArticles = {};
  bool _isLoading = true;
  String? _error;

  // Getter'lar
  bool get isLoading => _isLoading;
  String? get error => _error;

  FeaturedViewModel() {
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Her kategori için haberleri çek
      final futures = [
        _newsService.getNewsByCategory(NewsCategory.tumu),
        _newsService.getNewsByCategory(NewsCategory.bilim),
        _newsService.getNewsByCategory(NewsCategory.gundem),
      ];

      final results = await Future.wait(futures);

      _categoryArticles = {
        NewsCategory.tumu: results[0],
        NewsCategory.bilim: results[1],
        NewsCategory.gundem: results[2],
      };

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
    return _categoryArticles[NewsCategory.gundem]?.take(5).toList() ?? [];
  }

  List<Article> getLatestStories() {
    return _categoryArticles[NewsCategory.tumu]?.take(5).toList() ?? [];
  }

  List<Article> getScienceStories() {
    return _categoryArticles[NewsCategory.bilim]?.take(5).toList() ?? [];
  }

  // Tüm haberler için getter
  List<Article> get articles {
    return _categoryArticles[NewsCategory.tumu] ?? [];
  }

  // Story görüntülenme durumunu işaretleme
  void markCategoryAsViewed(String categoryId) {
    // İleride kullanılabilir
    notifyListeners();
  }
}
