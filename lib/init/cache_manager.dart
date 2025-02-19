import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  static final CacheManager _instance = CacheManager._init();
  static CacheManager get instance => _instance;

  SharedPreferences? _preferences;

  CacheManager._init();

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // İlk yükleme kontrolü
  Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    bool isFirst = prefs.getBool('isFirstLaunch') ?? true;
    return isFirst;
  }

  // Onboarding'i tamamla
  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false);
  }

  // Seçili kategorileri kaydet
  Future<void> saveSelectedCategories(List<String> categories) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('selectedCategories', categories);
  }

  // Seçili kategorileri getir
  Future<List<String>> getSelectedCategories() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('selectedCategories') ?? [];
  }
}
