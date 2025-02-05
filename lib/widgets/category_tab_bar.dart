import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/constants/app_constants.dart';

class CategoryTabBar extends StatelessWidget {
  final NewsCategory selectedCategory;
  final Function(NewsCategory) onCategorySelected;

  const CategoryTabBar({
    Key? key,
    required this.selectedCategory,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      color: Colors.black,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(width: 16.w),
            ...NewsCategory.values
                .map((category) => _buildCategoryTab(category)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTab(NewsCategory category) {
    return Padding(
      padding: EdgeInsets.only(right: 24.w),
      child: GestureDetector(
        onTap: () => onCategorySelected(category),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: selectedCategory == category
                ? FontWeight.w600
                : FontWeight.normal,
            color: selectedCategory == category ? Colors.white : Colors.grey,
          ),
          child: Text(category.title),
        ),
      ),
    );
  }
}
