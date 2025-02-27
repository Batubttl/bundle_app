import 'package:bundle_app/core/enum/news_category_enum.dart';
import 'package:bundle_app/core/extensions/theme_extension.dart';
import 'package:bundle_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/extensions/news_category_extension.dart';
import '../../core/theme/app_texts.dart';

class CategoryTabBar extends StatelessWidget {
  final NewsCategory selectedCategory;
  final Function(NewsCategory) onCategorySelected;

  const CategoryTabBar({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      color: context.backgroundColor,
      child: Row(
        children: [
          // Menü İkonu
          GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Container(
              width: 48.w,
              alignment: Alignment.center,
              color: context.backgroundColor, // Menü arka plan rengi
              child: Icon(
                Icons.menu,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.white
                    : AppColors.black, // Menü ikonu her zaman beyaz
                size: 24.sp,
              ),
            ),
          ),

          // Kaydırılabilir Kategoriler
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: NewsCategory.values
                  .map((category) => _buildCategoryTab(category))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTab(NewsCategory category) {
    return Builder(builder: (context) {
      final bool isSelected = category == selectedCategory;

      return GestureDetector(
        onTap: () => onCategorySelected(category),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          alignment: Alignment.center,
          child: Text(
            category.toDisplayString(),
            style: AppTextStyles.button.copyWith(
              color: isSelected ? context.textColor : context.secondaryColor,
              fontSize: 14.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              letterSpacing: -0.3,
            ),
          ),
        ),
      );
    });
  }
}
