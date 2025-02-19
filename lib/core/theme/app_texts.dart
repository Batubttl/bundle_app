import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  static const String _fontFamily = 'Inter';

  static TextStyle get h1 => TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        fontFamily: _fontFamily,
        letterSpacing: -0.5,
      );

  static TextStyle get h2 => TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        fontFamily: _fontFamily,
        letterSpacing: -0.5,
      );

  static TextStyle get appBar => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        fontFamily: _fontFamily,
        letterSpacing: -0.3,
      );

  static TextStyle get body => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
        fontFamily: _fontFamily,
        letterSpacing: -0.2,
      );

  static TextStyle get caption => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.normal,
        fontFamily: _fontFamily,
        letterSpacing: -0.2,
      );

  static TextStyle get button => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        fontFamily: _fontFamily,
        letterSpacing: -0.2,
      );
}
