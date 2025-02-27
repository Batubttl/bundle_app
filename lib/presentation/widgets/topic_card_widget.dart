import 'package:bundle_app/core/theme/app_texts.dart';
import 'package:bundle_app/model/topic_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopicCardWidget extends StatelessWidget {
  final TopicItem topic;

  const TopicCardWidget({required this.topic, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        image: DecorationImage(
          image: AssetImage(topic.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: Colors.black.withAlpha(102),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  topic.title,
                  style: AppTextStyles.h2.copyWith(color: Colors.white),
                ),
                if (topic.isAddable)
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Icon(Icons.add, color: Colors.black, size: 20.sp),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
