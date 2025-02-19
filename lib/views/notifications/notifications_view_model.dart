import 'dart:async';

import 'package:flutter/material.dart';
import '../../model/article_model.dart';
import '../../services/news_service.dart';
import '../../core/constants/app_constants.dart';

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

      // Teknoloji haberlerini al
      final articles =
          await _newsService.getNewsByCategory(NewsCategory.teknoloji);
      notifications = articles;

      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = 'Haberler yüklenirken hata oluştu: $e';
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshNotifications() async {
    await _loadTechnologyNews();
  }

  void markAsRead(String articleUrl) {
    // İleride okundu işaretleme özelliği eklenebilir
  }

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
