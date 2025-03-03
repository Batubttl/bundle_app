class DateFormatter {
  static String formatSource(String? source) {
    if (source == null) return '';

    source = source.replaceAll(RegExp(r'\.com.*$'), '');
    source = source.replaceAll(RegExp(r'www\.'), '');

    return source.split('.').first.capitalize();
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
