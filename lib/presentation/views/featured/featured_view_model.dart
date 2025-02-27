import 'package:bundle_app/core/enum/news_category_enum.dart';
import 'package:flutter/material.dart';
import '../../../model/article_model.dart';
import '../../../services/news_service.dart';

class FeaturedViewModel extends ChangeNotifier {
  final NewsService _newsService;

  Map<NewsCategory, List<Article>> _categoryArticles = {};
  Article? _latestSportsArticle;
  bool _isLoading = true;
  String? _error;

  // Getter'lar
  bool get isLoading => _isLoading;
  String? get error => _error;
  Article? get latestSportsArticle => _latestSportsArticle;
  List<Article> get articles => _categoryArticles[NewsCategory.tumu] ?? [];

  FeaturedViewModel({required NewsService newsService})
      : _newsService = newsService {
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
        _newsService.getNewsByCategory(NewsCategory.spor),
      ];

      final results = await Future.wait(futures);

      _categoryArticles = {
        NewsCategory.tumu: results[0],
        NewsCategory.bilim: results[1],
        NewsCategory.gundem: results[2],
      };

      // Spor haberlerinden en sonuncusunu al
      final sportsNews = results[3];
      if (sportsNews.isNotEmpty) {
        _latestSportsArticle = sportsNews.first;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error in _initializeData: $e');
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

  // Story görüntülenme durumunu işaretleme
  void markCategoryAsViewed(String categoryId) {
    // İleride kullanılabilir
    notifyListeners();
  }
}
