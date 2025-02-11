import '../constants/app_constants.dart';

extension NewsCategoryExtension on NewsCategory {
  String get apiCategory {
    switch (this) {
      case NewsCategory.tumu:
        return 'general';
      case NewsCategory.gundem:
        return 'general';
      case NewsCategory.spor:
        return 'sports';
      case NewsCategory.teknoloji:
        return 'technology';
      case NewsCategory.bilim:
        return 'science';
      case NewsCategory.eglence:
        return 'entertainment';
      case NewsCategory.ekonomi:
        return 'business';
    }
  }

  String get searchKeywords {
    switch (this) {
      case NewsCategory.tumu:
        return '';
      case NewsCategory.gundem:
        return '(türkiye) AND (gündem OR siyaset OR haber)';
      case NewsCategory.spor:
        return '(spor OR futbol OR basketbol) AND (türkiye)';
      case NewsCategory.teknoloji:
        return '(teknoloji OR yazılım OR bilişim OR yapay zeka)';
      case NewsCategory.bilim:
        return '(bilim OR uzay OR keşif OR nasa OR araştırma)';
      case NewsCategory.eglence:
        return '(magazin OR sinema OR dizi OR müzik OR sanat)';
      case NewsCategory.ekonomi:
        return '(ekonomi OR finans OR borsa OR dolar OR altın)';
    }
  }
}
