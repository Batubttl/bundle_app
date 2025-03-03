import 'package:bundle_app/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../model/article_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/extensions/theme_extension.dart';
import '../../../core/theme/app_texts.dart';

class NewsDetailView extends StatelessWidget {
  final Article article;

  const NewsDetailView({
    super.key,
    required this.article,
  });

  Future<void> _launchURL() async {
    final Uri url = Uri.parse(article.url);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('${AppStrings.errorUrl}ı: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.cardColor,
        leading: IconButton(
          icon: Icon(Icons.close, color: context.textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          article.source.toUpperCase(),
          style: AppTextStyles.h2.copyWith(color: context.textColor),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.open_in_browser, color: context.textColor),
            onPressed: _launchURL,
          ),
          IconButton(
            icon: Icon(Icons.more_horiz, color: context.textColor),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage != null)
              CachedNetworkImage(
                imageUrl: article.urlToImage!,
                width: double.infinity,
                height: 250.h,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: context.backgroundColor,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: context.primaryColor,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: context.cardColor,
                  child: Icon(
                    Icons.error_outline,
                    color: context.primaryColor,
                    size: 32.sp,
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: AppTextStyles.h1.copyWith(
                      color: context.textColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Text(
                        article.source,
                        style: AppTextStyles.caption.copyWith(
                          color: context.secondaryColor,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '• ${article.publishedAt}',
                        style: AppTextStyles.caption.copyWith(
                          color: context.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    article.content ?? article.description ?? '',
                    style: AppTextStyles.body.copyWith(
                      color: context.textColor,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  InkWell(
                    onTap: _launchURL,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: context.textColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppStrings.moveWebButton,
                            style: AppTextStyles.button.copyWith(
                              color: context.textColor,
                              letterSpacing: 1,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: context.textColor,
                            size: 24.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.w),
        color: context.cardColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.format_size, color: context.textColor),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.favorite_border, color: context.textColor),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.share, color: context.textColor),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.bookmark_border, color: context.textColor),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
