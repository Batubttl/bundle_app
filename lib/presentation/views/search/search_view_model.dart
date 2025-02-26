import 'package:bundle_app/model/article_model.dart';
import 'package:flutter/material.dart';
import '../../../services/news_service.dart';

class SearchViewModel extends ChangeNotifier {
  final NewsService _newsService;
  List<Article> articles = [];
  bool _isLoading = false;
  String? _error;
  final String _searchQuery = '';

  SearchViewModel(this._newsService);

  List<Article> get searchResults => articles;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasResults => articles.isNotEmpty;
  bool get hasSearched => _searchQuery.isNotEmpty;

  Future<void> searchNews(String query) async {
    if (query.isEmpty) {
      articles = [];
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final results = await _newsService.searchNews(query);
      articles = results;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    articles = [];
    _error = null;
    notifyListeners();
  }
}
