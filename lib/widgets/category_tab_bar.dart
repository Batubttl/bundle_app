import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/constants/app_constants.dart';
import '../core/extensions/news_category_extension.dart';

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
      color: Colors.black,
      child: Row(
        children: [
          // Sabit Menu Icon
          GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Container(
              width: 48.w,
              alignment: Alignment.center,
              color: Colors.black,
              child: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
            ),
          ),

          // Scrollable Categories
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCategoryTab(NewsCategory.tumu),
                _buildCategoryTab(NewsCategory.bilim),
                _buildCategoryTab(NewsCategory.teknoloji),
                _buildCategoryTab(NewsCategory.eglence),
                _buildCategoryTab(NewsCategory.gundem),
                _buildCategoryTab(NewsCategory.spor),
                _buildCategoryTab(NewsCategory.ekonomi),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTab(NewsCategory category) {
    final bool isSelected = category == selectedCategory;

    return GestureDetector(
      onTap: () => onCategorySelected(category),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            Text(
              category.toDisplayString(),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
