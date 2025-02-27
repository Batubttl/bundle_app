import 'package:bundle_app/model/topic_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'topic_card_widget.dart';

class TopicCardListWidget extends StatelessWidget {
  final List<TopicItem> topics;

  const TopicCardListWidget({
    super.key,
    required this.topics,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: topics.length,
        separatorBuilder: (context, index) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          return TopicCardWidget(topic: topics[index]);
        },
      ),
    );
  }
}
