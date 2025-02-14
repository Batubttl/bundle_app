import 'package:bundle_app/core/constants/app_constants.dart';
import 'package:bundle_app/core/network/api_client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/notification_model.dart';
import '../services/news_service.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NewsService _newsService = NewsService(ApiClient());

  // Haber kaynakları için logo URL'leri
  final Map<String, String> sourceLogos = {
    'Hürriyet': 'https://i.imgur.com/YhiAqiY.png',
    'Milliyet': 'https://i.imgur.com/p6vE7hf.png',
    'Sabah': 'https://i.imgur.com/RZ5vTjH.png',
    'NTV': 'https://i.imgur.com/8TzKBAs.png',
    'Habertürk': 'https://i.imgur.com/XrZ6oqJ.png',
    'CNN Türk': 'https://i.imgur.com/ZgDb8DR.png',
    'Bundle': 'https://i.imgur.com/default.png', // Default logo
  };

  // Haber kaynağı için logo URL'i getir
  String getSourceLogo(String source) {
    return sourceLogos[source] ?? sourceLogos['Bundle']!;
  }

  // Bildirimleri getir
  Stream<List<NotificationModel>> getNotifications() {
    return _firestore
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => NotificationModel.fromJson(doc.data()))
          .toList();
    });
  }

  // API'den gelen haberleri bildirime çevir
  Future<void> createNotificationsFromNews() async {
    try {
      print('Gündemdeki haberlerden bildirimler oluşturuluyor...');

      // NewsService'den gündemdeki haberleri al
      final articles =
          await _newsService.getNewsByCategory(NewsCategory.gundem);
      print('${articles.length} haber alındı'); // Kaç haber geldiğini görelim

      if (articles.isEmpty) {
        throw 'Gündemden haber alınamadı';
      }

      // Her haberi bildirime çevir (ilk 5 haber)
      for (var article in articles.take(5)) {
        // Aynı başlıklı bildirim var mı kontrol et
        final existingNotifications = await _firestore
            .collection('notifications')
            .where('title', isEqualTo: article.title)
            .get();

        // Eğer bu haber daha önce bildirim olarak eklenmemişse
        if (existingNotifications.docs.isEmpty) {
          // String'i DateTime'a çeviriyoruz
          DateTime timestamp;
          try {
            timestamp = article.publishedAt != null
                ? DateTime.parse(article.publishedAt as String)
                : DateTime.now();
          } catch (e) {
            print('Tarih dönüştürme hatası: $e');
            timestamp = DateTime.now();
          }

          // Haber kaynağı için logo URL'i al
          final sourceName = article.source ?? 'Bundle';
          final sourceLogoUrl = getSourceLogo(sourceName);

          final notification = {
            'id': DateTime.now().millisecondsSinceEpoch.toString(),
            'title': article.title,
            'message': article.description ?? '',
            'category': article.category?.toString().toUpperCase() ?? 'GÜNDEM',
            'timestamp': Timestamp.fromDate(timestamp),
            'isRead': false,
            'source': sourceName,
            'sourceImageUrl': sourceLogoUrl,
          };

          // Firestore'a kaydet
          await _firestore
              .collection('notifications')
              .doc(notification['id'].toString())
              .set(notification);

          print(
              'Yeni bildirim oluşturuldu: ${notification['title']} - Logo: $sourceLogoUrl');
        } else {
          print('Bu haber zaten bildirim olarak eklenmiş: ${article.title}');
        }
      }

      print('Bildirimler başarıyla güncellendi');
    } catch (e) {
      print('Bildirim oluşturulurken hata: $e');
      throw 'Bildirimler oluşturulamadı: $e';
    }
  }

  // Bildirimi okundu olarak işaretle
  Future<void> markAsRead(String notificationId) async {
    try {
      await _firestore
          .collection('notifications')
          .doc(notificationId)
          .update({'isRead': true});
    } catch (e) {
      print('Bildirim durumu güncellenirken hata: $e'); // Debug log
      throw 'Bildirim durumu güncellenirken bir hata oluştu: $e';
    }
  }
}
