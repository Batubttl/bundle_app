import 'package:flutter/material.dart';

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  bool get isDark => theme.brightness == Brightness.dark;

  Color get primaryColor => colorScheme.primary;
  Color get backgroundColor => colorScheme.surface;
  Color get surfaceColor => colorScheme.surface;
  Color get textColor => colorScheme.onSurface;
  Color get cardColor => theme.cardColor;
  Color get secondaryColor => colorScheme.secondary;
  Color get tertiaryColor => colorScheme.tertiary;
  Color get whiteColor => Colors.white;
}
