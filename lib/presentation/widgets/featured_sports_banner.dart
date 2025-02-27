import 'package:bundle_app/model/article_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/extensions/theme_extension.dart';
import '../../../core/theme/app_texts.dart';

class FeaturedSportsBanner extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;

  const FeaturedSportsBanner({
    super.key,
    required this.article,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16.h),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Haber görseli
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: CachedNetworkImage(
                imageUrl: article.urlToImage ?? '',
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: context.cardColor,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: context.primaryColor,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: context.cardColor,
                  child: Icon(Icons.error, color: context.textColor),
                ),
              ),
            ),
            // Karartma gradyanı
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            // Haber başlığı ve kaynağı
            Positioned(
              left: 16.w,
              right: 16.w,
              bottom: 16.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    article.title,
                    style: AppTextStyles.h2.copyWith(
                      color: context.whiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Text(
                        article.source.toUpperCase(),
                        style: AppTextStyles.caption.copyWith(
                          color: context.whiteColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward,
                        color: context.whiteColor,
                        size: 20.sp,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
