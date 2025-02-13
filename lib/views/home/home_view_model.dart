import 'package:bundle_app/core/constants/app_constants.dart';
import 'package:bundle_app/model/article_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../../services/news_service.dart';

class HomeViewModel extends ChangeNotifier {
  final NewsService _newsService;

  // State variables
  List<Article> _articles = [];
  bool _isLoading = false;
  final bool _isLoadingMore = false;
  String? _error;
  NewsCategory _selectedCategory = NewsCategory.tumu;
  int _currentPage = 1;
  bool _hasMore = true;
  int currentIndex = 0; // Bottom Navigation için eklendi

  // Debounce için
  Timer? _debounceTimer;

  // Getters
  List<Article> get articles => _articles;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;
  NewsCategory get selectedCategory => _selectedCategory;
  List<NewsCategory> get categories => NewsCategory.values;
  bool get hasMore => _hasMore;

  HomeViewModel(this._newsService) {
    _loadInitialNews();
  }

  Future<void> _loadInitialNews() async {
    _currentPage = 1;
    await _fetchNews(refresh: true);
  }

  Future<void> refreshNews() async {
    _currentPage = 1;
    _hasMore = true;
    await _fetchNews(refresh: true);
  }

  Future<void> loadMoreNews() async {
    if (!_isLoading && _hasMore) {
      _currentPage++;
      await _fetchNews();
    }
  }

  Future<void> _fetchNews({bool refresh = false}) async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      if (refresh) {
        _articles = [];
      }
      notifyListeners();

      final newArticles = await _newsService.getNewsByCategory(
        _selectedCategory,
        page: _currentPage,
      );

      if (refresh) {
        _articles = newArticles;
      } else {
        _articles.addAll(newArticles);
      }

      _hasMore = newArticles.length == 20;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void changeCategory(NewsCategory category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      refreshNews();
    }
  }

  // Arama yapma
  Future<void> search(String query) async {
    // This method will be updated based on actual implementation
    throw UnimplementedError();
  }

  // Yenileme
  Future<void> refreshArticles() async {
    print('Refreshing articles'); // Debug log
    return refreshNews();
  }

  // Daha fazla haber yükleme
  Future<void> loadMore() async {
    print('Loading more articles'); // Debug log
    if (!_isLoading && !_isLoadingMore && _hasMore) {
      await loadMoreNews();
    }
  }

  void onTabTapped(int index) {
    // Bottom Navigation için eklendi
    currentIndex = index;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
