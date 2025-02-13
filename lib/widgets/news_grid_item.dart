import 'package:bundle_app/model/article_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/extensions/date_time_extension.dart';
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
        color: const Color.fromARGB(255, 20, 20, 21),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Haber Resmi
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
                  color: Colors.grey[900],
                  child: Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 32.sp,
                  ),
                ),
              ),
            ),
          ),

          // İçerik Kısmı
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kaynak
                Text(
                  article.source,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1,
                  ),
                ),
                SizedBox(height: 8),

                // Başlık
                Text(
                  article.title ?? '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isFeatured ? 22.sp : 20.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                    letterSpacing: -1,
                  ),
                  maxLines: isFeatured ? 8 : 4,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12.h),

                // Zaman
                Text(
                  _getTimeAgo(),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13.sp,
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
