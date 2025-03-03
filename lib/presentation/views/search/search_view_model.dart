import 'dart:async';

import 'package:bundle_app/core/constants/app_constants.dart';
import 'package:bundle_app/model/article_model.dart';
import 'package:bundle_app/model/topic_models.dart';
import 'package:flutter/material.dart';
import '../../../services/news_service.dart';

class SearchViewModel extends ChangeNotifier {
  final NewsService _newsService;
  TabController? _tabController;

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
      imageUrl: AppAsset.gptImage,
    ),
    TopicItem(
      title: AppStrings.discountText,
      imageUrl: AppAsset.discountImage,
      isAddable: true,
    ),
    TopicItem(
      title: AppStrings.cryptoText,
      imageUrl: AppAsset.cryptoImage,
      isAddable: true,
    ),
  ];

  final List<InterestArea> interestAreas = [
    InterestArea(
        title: AppStrings.firstInterestTitle,
        imageUrl: AppAsset.firstInterestTitle),
    InterestArea(
        title: AppStrings.secondInterestTitle,
        imageUrl: AppAsset.secondInterestTitle),
    InterestArea(
      title: AppStrings.thirdInterestTitle,
      imageUrl: AppAsset.thirdInterestTitle,
    ),
    InterestArea(
      title: AppStrings.fourthInterestTitle,
      imageUrl: AppAsset.fifthInterestTitle,
    ),
    InterestArea(
      title: AppStrings.fifthInterestTitle,
      imageUrl: AppAsset.fifthInterestTitle,
    ),
  ];

  SearchViewModel(this._newsService) {
    _init();
  }

  TabController get tabController => _tabController!;

  void _init() {}

  void initTabController(TickerProvider vsync) {
    _tabController = TabController(
      length: tabs.length,
      vsync: vsync,
    );
    notifyListeners();
  }

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
