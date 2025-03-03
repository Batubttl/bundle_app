class DateFormatter {
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
