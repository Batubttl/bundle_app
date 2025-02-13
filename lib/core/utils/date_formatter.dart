import 'package:intl/intl.dart';

class DateFormatter {
  static String getTimeAgo(String? dateString) {
    if (dateString == null) return '';

    try {
      final DateTime date = DateTime.parse(dateString);
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(date);

      if (difference.inDays > 365) {
        return '${(difference.inDays / 365).floor()} yıl önce';
      } else if (difference.inDays > 30) {
        return '${(difference.inDays / 30).floor()} ay önce';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} gün önce';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} saat önce';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} dakika önce';
      } else {
        return 'Az önce';
      }
    } catch (e) {
      return dateString;
    }
  }

  static String formatSource(String? source) {
    if (source == null) return '';

    // URL formatındaki kaynakları temizle
    source = source.replaceAll(RegExp(r'\.com.*$'), '');
    source = source.replaceAll(RegExp(r'www\.'), '');

    // İlk harfi büyük yap
    return source.split('.').first.capitalize();
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
