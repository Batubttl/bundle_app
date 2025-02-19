import 'package:flutter/material.dart';
import 'package:bundle_app/core/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _key = 'theme_mode';
  late ThemeMode _themeMode;

  ThemeProvider() {
    _themeMode = ThemeMode.system; // Varsayılan değer
    _loadThemeMode();
  }

  ThemeMode get themeMode => _themeMode;

  // Tema modunu yükle
  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? themeModeString = prefs.getString(_key);
      if (themeModeString != null) {
        _themeMode = ThemeMode.values.firstWhere(
          (mode) => mode.toString() == themeModeString,
          orElse: () => ThemeMode.system,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Tema yüklenirken hata: $e');
    }
  }

  // Tema modunu değiştir ve kaydet
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_key, mode.toString());
      } catch (e) {
        debugPrint('Tema kaydedilirken hata: $e');
      }
    }
  }

  // Mevcut temayı al
  ThemeData getTheme() {
    switch (_themeMode) {
      case ThemeMode.light:
        return AppTheme.lightTheme;
      case ThemeMode.dark:
        return AppTheme.darkTheme;
      case ThemeMode.system:
        final brightness = WidgetsBinding.instance.window.platformBrightness;
        return brightness == Brightness.dark ? AppTheme.darkTheme : AppTheme.lightTheme;
    }
  }
}
