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

  String get queryString {
    switch (this) {
      case NewsCategory.tumu:
        return '(türkiye OR türk OR ankara OR istanbul)';
      case NewsCategory.gundem:
        return '(gündem OR siyaset OR politika)';
      case NewsCategory.spor:
        return '(spor OR futbol OR basketbol OR fenerbahçe OR galatasaray OR beşiktaş)';
      case NewsCategory.teknoloji:
        return '(teknoloji OR yazılım OR bilişim OR yapay zeka)';
      case NewsCategory.bilim:
        return '(bilim OR uzay OR araştırma OR keşif)';
      case NewsCategory.ekonomi:
        return '(ekonomi OR finans OR borsa OR dolar OR altın)';
      case NewsCategory.eglence:
        return '(magazin OR sinema OR dizi OR müzik)';
    }
  }
}

class AppConstants {
  static const String appName = 'Bundle Haber';
  static const int pageSize = 10;
}
