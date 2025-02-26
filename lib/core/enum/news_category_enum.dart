enum NewsCategory {
  tumu,
  gundem,
  bilim,
  teknoloji,
  eglence,
  spor,
  ekonomi;

  String get title {
    switch (this) {
      case NewsCategory.tumu:
        return 'TÜMÜ';
      case NewsCategory.gundem:
        return 'GÜNDEM';
      case NewsCategory.bilim:
        return 'BİLİM';
      case NewsCategory.teknoloji:
        return 'TEKNOLOJİ';
      case NewsCategory.eglence:
        return 'EĞLENCE';
      case NewsCategory.spor:
        return 'SPOR';
      case NewsCategory.ekonomi:
        return 'EKONOMİ';
    }
  }
}

class AppConstants {
  static const String appName = 'Bundle Haber';
  static const int pageSize = 10;
}
