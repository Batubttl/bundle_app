import 'package:bundle_app/model/article_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/extensions/theme_extension.dart';
import '../../../core/theme/app_texts.dart';

class NewsCard extends StatelessWidget {
  final Article article;

  const NewsCard({super.key, required this.article, required Size size});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (article.source.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(left: 16.w, bottom: 8.h),
              child: Text(
                article.source.toUpperCase(),
                style: AppTextStyles.caption.copyWith(
                  color: context.secondaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          if (article.urlToImage != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: CachedNetworkImage(
                  imageUrl: article.urlToImage!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: context.cardColor,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(context.primaryColor),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: context.cardColor,
                    child: Icon(Icons.error, color: context.secondaryColor),
                  ),
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
            child: Text(
              article.title,
              style: AppTextStyles.h2.copyWith(
                color: context.textColor,
                height: 1.3,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              _getTimeAgo(article.publishedAt),
              style: AppTextStyles.caption.copyWith(
                color: context.secondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(String publishedAt) {
    final now = DateTime.now();
    final published = DateTime.parse(publishedAt);
    final difference = now.difference(published);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} dakika';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} saat';
    } else {
      return '${difference.inDays} gün';
    }
  }
}
