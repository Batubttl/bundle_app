import 'package:bundle_app/init/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingViewModel extends ChangeNotifier {
  final _cacheManager = CacheManager.instance;
  bool _isLoading = false;
  List<CategoryItem> _categories = [];

  bool get isLoading => _isLoading;
  List<CategoryItem> get categories => _categories;

  OnboardingViewModel() {
    _initCategories();
  }

  void _initCategories() {
    _categories = [
      CategoryItem(
        title: 'KISACA GÜNDEM',
        imagePath: 'assets/images/news_bg.jpg',
        isSelected: true,
      ),
      CategoryItem(
        title: 'BİLİM & TEKNOLOJİ',
        imagePath: 'assets/images/tech_bg.jpg',
        isSelected: true,
      ),
      CategoryItem(
        title: 'EKONOMİ',
        imagePath: 'assets/images/economy_bg.jpg',
        isSelected: false,
      ),
    ];
    notifyListeners();
  }

  void toggleCategory(int index) {
    _categories[index].isSelected = !_categories[index].isSelected;
    notifyListeners();
  }

  Future<void> savePreferences() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isFirstLaunch', false);

      // Seçili kategorileri kaydet
      final selectedCategories =
          _categories.where((c) => c.isSelected).map((c) => c.title).toList();
      await prefs.setStringList('selectedCategories', selectedCategories);
    } catch (e) {
      debugPrint('Tercihler kaydedilirken hata: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isFirstLaunch') ?? true;
  }
}

class CategoryItem {
  final String title;
  final String imagePath;
  bool isSelected;

  CategoryItem({
    required this.title,
    required this.imagePath,
    this.isSelected = false,
  });
}
