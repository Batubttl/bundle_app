import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:bundle_app/providers/theme_provider.dart';
import '../../core/extensions/theme_extension.dart';
import '../../core/theme/app_texts.dart';

class ThemeSelectionView extends StatelessWidget {
  const ThemeSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: context.backgroundColor,
        title: Text(
          'GECE MODU',
          style: AppTextStyles.h2.copyWith(
            color: context.textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: context.textColor,
            size: 24.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    context.read<ThemeProvider>().setThemeMode(ThemeMode.dark);
                  },
                  child: _buildThemeOption(
                    context,
                    'Karanlık Tema',
                    themeProvider.themeMode == ThemeMode.dark,
                  ),
                ),
                InkWell(
                  onTap: () {
                    context.read<ThemeProvider>().setThemeMode(ThemeMode.light);
                  },
                  child: _buildThemeOption(
                    context,
                    'Aydınlık Tema',
                    themeProvider.themeMode == ThemeMode.light,
                  ),
                ),
                InkWell(
                  onTap: () {
                    context
                        .read<ThemeProvider>()
                        .setThemeMode(ThemeMode.system);
                  },
                  child: _buildThemeOption(
                    context,
                    'Otomatik',
                    themeProvider.themeMode == ThemeMode.system,
                    isSystem: true,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String title,
    bool isSelected, {
    bool isSystem = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.body.copyWith(
              color: isSystem ? context.primaryColor : context.textColor,
              fontSize: 16.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          if (isSelected)
            Icon(
              Icons.check,
              color: isSystem ? context.primaryColor : context.primaryColor,
              size: 24.sp,
            ),
        ],
      ),
    );
  }
}
