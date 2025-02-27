import 'package:bundle_app/core/constants/app_constants.dart';
import 'package:bundle_app/core/extensions/theme_extension.dart';
import 'package:bundle_app/core/theme/app_texts.dart';
import 'package:bundle_app/model/article_model.dart';
import 'package:bundle_app/presentation/views/news/news_details_view.dart';
import 'package:bundle_app/presentation/views/search/search_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchResultsWidget extends StatelessWidget {
  final SearchViewModel viewModel;

  const SearchResultsWidget({required this.viewModel, super.key});

  @override
  Widget build(BuildContext context) {
    if (viewModel.isLoading) {
      return Center(
          child: CircularProgressIndicator(color: context.primaryColor));
    }

    if (viewModel.error != null) {
      return Center(
        child: Text(
          viewModel.error!,
          style: AppTextStyles.body.copyWith(color: context.textColor),
        ),
      );
    }

    if (viewModel.searchController.text.isEmpty) {
      return Center(
        child: Text(
          AppStrings.writeSomethingText,
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    return ListView.builder(
      itemCount: viewModel.articles.length,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemBuilder: (context, index) =>
          _buildArticleItem(context, viewModel.articles[index]),
    );
  }

  Widget _buildArticleItem(BuildContext context, Article article) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewsDetailView(article: article),
        ),
      ),
      child: Card(
        color: context.cardColor,
        margin: EdgeInsets.only(bottom: 8.h),
        child: ListTile(
          title: Text(
            article.title,
            style: AppTextStyles.body.copyWith(
              color: context.textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            article.source,
            style: AppTextStyles.caption.copyWith(
              color: context.secondaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
