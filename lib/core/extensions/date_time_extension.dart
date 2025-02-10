extension DateTimeExtension on DateTime {
  String timeAgo() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inMinutes < 1) {
      return 'Şimdi';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} dakika';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} saat';
    } else {
      return '${difference.inDays} gün';
    }
  }
}
