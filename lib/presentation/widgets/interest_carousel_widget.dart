import 'package:bundle_app/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../model/topic_models.dart';

class InterestAreasCarousel extends StatelessWidget {
  final List<InterestArea> areas;

  static final List<InterestArea> defaultAreas = [
    InterestArea(
      title: AppStrings.firstInterestTitle,
      imageUrl: 'assets/images/tenis.jpg',
    ),
    InterestArea(
      title: AppStrings.secondInterestTitle,
      imageUrl: 'assets/images/interests/technology.jpg',
    ),
    InterestArea(
      title: AppStrings.thirdInterestTitle,
      imageUrl: 'assets/images/interests/science.jpg',
    ),
    InterestArea(
      title: AppStrings.fourthInterestTitle,
      imageUrl: 'assets/images/interests/economy.jpg',
    ),
    InterestArea(
      title: AppStrings.fifthInterestTitle,
      imageUrl: 'assets/images/interests/entertainment.jpg',
    ),
  ];

  const InterestAreasCarousel({
    super.key,
    required this.areas,
  });

  @override
  Widget build(BuildContext context) {
    final displayAreas = areas.isEmpty ? defaultAreas : areas;

    return CarouselSlider.builder(
      itemCount: displayAreas.length,
      options: CarouselOptions(
        height: 180.h,
        viewportFraction: 0.8,
        enableInfiniteScroll: true,
        enlargeCenterPage: true,
      ),
      itemBuilder: (context, index, realIndex) {
        final area = displayAreas[index];
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            image: DecorationImage(
              image: AssetImage(area.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black],
              ),
            ),
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.all(16.w),
            child: Text(
              area.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
