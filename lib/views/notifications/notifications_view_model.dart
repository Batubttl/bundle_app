import 'dart:async';

import 'package:bundle_app/core/network/api_client.dart';
import 'package:bundle_app/services/news_service.dart';
import 'package:bundle_app/services/notifications_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/notification_model.dart';

class NotificationsViewModel extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  bool isLoading = true;
  List<NotificationModel> notifications = [];
  String? error;
  StreamSubscription<List<NotificationModel>>? _notificationsSubscription;

  NotificationsViewModel() {
    _initNotifications();
  }

  void _initNotifications() {
    try {
      print('Bildirimler yükleniyor...'); // Debug log

      // Stream'i dinlemeye başla
      _notificationsSubscription?.cancel();

      _notificationsSubscription =
          _notificationService.getNotifications().listen(
        (updatedNotifications) {
          notifications = updatedNotifications;
          isLoading = false;
          print('${notifications.length} bildirim yüklendi'); // Debug log
          notifyListeners();
        },
        onError: (e) {
          error = 'Bildirimler yüklenirken hata oluştu: $e';
          isLoading = false;
          print('Hata: $error'); // Debug log
          notifyListeners();
        },
      );
    } catch (e) {
      error = 'Bildirimler başlatılırken hata oluştu: $e';
      isLoading = false;
      print('Hata: $error'); // Debug log
      notifyListeners();
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _notificationService.markAsRead(notificationId);
      print('Bildirim okundu olarak işaretlendi: $notificationId'); // Debug log
    } catch (e) {
      print('Bildirim işaretlenirken hata: $e'); // Debug log
    }
  }

  Future<void> refreshNotifications() async {
    _initNotifications();
  }

  void clearAll() {
    notifications.clear();
    notifyListeners();
  }

  Future<void> addTestNotifications() async {
    try {
      await _notificationService.createNotificationsFromNews();
      print('Test bildirimleri eklendi'); // Debug log
    } catch (e) {
      print('Test bildirimleri eklenirken hata: $e'); // Debug log
    }
  }

  @override
  void dispose() {
    _notificationsSubscription?.cancel();
    super.dispose();
  }
}
