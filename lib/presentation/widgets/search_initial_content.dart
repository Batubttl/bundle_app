import 'package:bundle_app/presentation/views/search/search_view_model.dart';
import 'package:bundle_app/presentation/widgets/interest_carousel_widget.dart';
import 'package:bundle_app/presentation/widgets/topic_card_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/theme_extension.dart';
import '../../../core/theme/app_texts.dart';

class SearchInitialContent extends StatelessWidget {
  final SearchViewModel viewModel;

  const SearchInitialContent({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.subjectText,
              style: AppTextStyles.h1.copyWith(color: context.textColor),
            ),
            SizedBox(height: 16.h),
            TopicCardListWidget(topics: viewModel.topics),
            SizedBox(height: 32.h),
            Text(
              AppStrings.titleInterest,
              style: AppTextStyles.h1.copyWith(color: context.textColor),
            ),
            SizedBox(height: 16.h),
            InterestAreasCarousel(areas: viewModel.interestAreas),
          ],
        ),
      ),
    );
  }
}
