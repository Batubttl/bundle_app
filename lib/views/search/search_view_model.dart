import 'package:bundle_app/model/article_model.dart';
import 'package:flutter/material.dart';
import '../../services/news_service.dart';

class SearchViewModel extends ChangeNotifier {
  final NewsService _newsService;
  List<Article> _searchResults = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  SearchViewModel(this._newsService);

  List<Article> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasResults => _searchResults.isNotEmpty;
  bool get hasSearched => _searchQuery.isNotEmpty;

  Future<void> searchNews(String query) async {
    if (query.isEmpty) {
      clearSearch();
      return;
    }

    try {
      _isLoading = true;
      _error = null;
      _searchQuery = query;
      notifyListeners();

      _searchResults = await _newsService.searchNews(query);

      if (_searchResults.isEmpty) {
        _error = 'Aramanızla eşleşen haber bulunamadı';
      }
    } catch (e) {
      _error = 'Arama sırasında bir hata oluştu';
      _searchResults = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchResults = [];
    _error = null;
    _searchQuery = '';
    notifyListeners();
  }
}
