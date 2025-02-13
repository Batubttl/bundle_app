import 'package:flutter/material.dart';

class NotificationsViewModel extends ChangeNotifier {
  bool isLoading = false;
  List<Notification> notifications = [];
  String? error;

  NotificationsViewModel() {
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading = true;
      notifyListeners();

      // TODO: Burada bildirimler API'den çekilecek
      await Future.delayed(const Duration(seconds: 1)); // Simülasyon için
      notifications = []; // Şimdilik boş liste

      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshNotifications() async {
    notifications.clear();
    await fetchNotifications();
  }

  void markAsRead(String notificationId) {
    // TODO: Bildirimi okundu olarak işaretle
    notifyListeners();
  }

  void clearAll() {
    notifications.clear();
    notifyListeners();
  }
}
