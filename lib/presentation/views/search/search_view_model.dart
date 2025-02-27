import 'dart:async';

import 'package:bundle_app/core/constants/app_constants.dart';
import 'package:bundle_app/model/article_model.dart';
import 'package:bundle_app/model/topic_models.dart';
import 'package:flutter/material.dart';
import '../../../services/news_service.dart';

class SearchViewModel extends ChangeNotifier {
  final NewsService _newsService;
  TabController? _tabController;

  // State variables
  List<Article> articles = [];
  bool _isLoading = false;
  String? _error;
  final TextEditingController searchController = TextEditingController();
  Timer? _debounceTimer;

  final List<String> tabs = [
    'Haber',
    'Kaynak',
    'Tümü',
    'Konu',
  ];

  final List<TopicItem> topics = [
    TopicItem(
      title: AppStrings.gptText,
      imageUrl: 'assets/images/gpt.png',
      isAddable: true,
    ),
    TopicItem(
      title: AppStrings.discountText,
      imageUrl: 'assets/images/superlig.jpeg',
      isAddable: true,
    ),
    TopicItem(
      title: AppStrings.cryptoText,
      imageUrl: 'assets/images/bitcoin.png',
      isAddable: true,
    ),
  ];

  final List<InterestArea> interestAreas = [
    InterestArea(
      title: AppStrings.firstInterestTitle,
      imageUrl: 'assets/images/tenis.jpg',
    ),
    InterestArea(
      title: AppStrings.secondInterestTitle,
      imageUrl: 'assets/images/dunya.jpg',
    ),
    InterestArea(
      title: AppStrings.thirdInterestTitle,
      imageUrl: 'assets/images/coin.png',
    ),
    InterestArea(
      title: AppStrings.fourthInterestTitle,
      imageUrl: 'assets/images/kitap.jpg',
    ),
    InterestArea(
      title: AppStrings.fifthInterestTitle,
      imageUrl: 'assets/images/zihin.jpg',
    ),
  ];

  SearchViewModel(this._newsService) {
    _init();
  }

  TabController get tabController => _tabController!;

  void _init() {
    // Diğer başlangıç işlemleri
  }

  void initTabController(TickerProvider vsync) {
    _tabController = TabController(
      length: tabs.length,
      vsync: vsync,
    );
    notifyListeners();
  }

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasResults => articles.isNotEmpty;

  void onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      searchNews(query);
    });
  }

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

      articles = await _newsService.searchNews(query);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    searchController.clear();
    articles = [];
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }
}
