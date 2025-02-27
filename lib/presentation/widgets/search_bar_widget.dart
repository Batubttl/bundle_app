import 'package:bundle_app/core/constants/app_constants.dart';
import 'package:bundle_app/core/extensions/theme_extension.dart';
import 'package:bundle_app/presentation/views/search/search_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchBarWidget extends StatelessWidget {
  final SearchViewModel viewModel;

  const SearchBarWidget({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: context.backgroundColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: TextField(
          controller: viewModel.searchController,
          style: TextStyle(
            color: context.textColor,
            fontSize: 16.sp,
          ),
          decoration: InputDecoration(
            hintText: AppStrings.searchHintText,
            hintStyle: TextStyle(
              color: context.secondaryColor,
              fontSize: 16.sp,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: context.secondaryColor,
              size: 20.sp,
            ),
            suffixIcon: viewModel.searchController.text.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      viewModel.searchController.clear();
                      viewModel.clearSearch();
                    },
                    child: Icon(
                      Icons.close,
                      color: context.secondaryColor,
                      size: 20.sp,
                    ),
                  )
                : null,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
          ),
          onChanged: viewModel.onSearchChanged,
        ),
      ),
    );
  }
}
