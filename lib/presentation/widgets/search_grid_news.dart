import 'package:bundle_app/presentation/widgets/news_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../core/constants/app_constants.dart';
import '../../../model/article_model.dart';

class SearchNewsGridWidget extends StatelessWidget {
  final List<Article> articles;
  final bool isLoading;
  final String searchText;

  const SearchNewsGridWidget({
    super.key,
    required this.articles,
    required this.isLoading,
    required this.searchText,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (searchText.isEmpty) {
      return Center(
        child: Text(
          AppStrings.writeSomethingText,
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    if (articles.isEmpty) {
      return Center(
        child: Text(
          AppStrings.errorSearch,
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 16.h,
        crossAxisSpacing: 16.w,
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return NewsGridItem(
            article: articles[index],
            isFeatured: index == 0,
          );
        },
      ),
    );
  }
}
