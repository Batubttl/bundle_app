import 'package:bundle_app/model/article_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/extensions/date_time_extension.dart';
import '../core/extensions/theme_extension.dart';
import '../core/theme/app_texts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NewsGridItem extends StatelessWidget {
  final Article article;
  final bool isFeatured;

  const NewsGridItem({
    super.key,
    required this.article,
    this.isFeatured = false,
  });

  String _getTimeAgo() {
    try {
      final publishDate = DateTime.parse(article.publishedAt);
      return publishDate.timeAgo();
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
            child: AspectRatio(
              aspectRatio: isFeatured ? 16 / 9 : 16 / 12,
              child: CachedNetworkImage(
                imageUrl: article.urlToImage ?? '',
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(
                  color: context.cardColor,
                  child: Icon(
                    Icons.error_outline,
                    color: context.primaryColor,
                    size: 32.sp,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.source,
                  style: AppTextStyles.caption.copyWith(
                    color: context.textColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  article.title ?? '',
                  style: (isFeatured ? AppTextStyles.h1 : AppTextStyles.h2)
                      .copyWith(
                    color: context.textColor,
                    height: 1.2,
                    letterSpacing: -1,
                  ),
                  maxLines: isFeatured ? 16 : 8,
                ),
                SizedBox(height: 12.h),
                Text(
                  _getTimeAgo(),
                  style: AppTextStyles.caption.copyWith(
                    color: context.secondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
