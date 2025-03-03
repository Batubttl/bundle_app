import 'dart:async';
import 'package:bundle_app/core/constants/app_constants.dart';
import 'package:bundle_app/core/enum/news_category_enum.dart';
import 'package:flutter/material.dart';
import '../../../model/article_model.dart';
import '../../../services/news_service.dart';

class NotificationsViewModel extends ChangeNotifier {
  final NewsService _newsService;
  bool isLoading = true;
  List<Article> notifications = [];
  String? error;
  StreamSubscription<List<Article>>? _notificationsSubscription;

  NotificationsViewModel(this._newsService) {
    _loadTechnologyNews();
  }

  Future<void> _loadTechnologyNews() async {
    try {
      isLoading = true;
      notifyListeners();

      final articles =
          await _newsService.getNewsByCategory(NewsCategory.teknoloji);
      notifications = articles;

      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = '${AppStrings.errorNewsLoading}: $e';
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshNotifications() async {
    await _loadTechnologyNews();
  }

  void markAsRead(String articleUrl) {}

  void clearAll() {
    notifications.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _notificationsSubscription?.cancel();
    super.dispose();
  }
}
