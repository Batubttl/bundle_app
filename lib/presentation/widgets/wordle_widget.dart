import 'package:bundle_app/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/extensions/theme_extension.dart';
import '../../core/theme/app_texts.dart';

class WordleWidget extends StatelessWidget {
  const WordleWidget({super.key});
  Future<void> _launchWordle() async {
    final Uri url = Uri.parse('https://wordleturkce.bundle.app/');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('${AppStrings.errorUrl}: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Container(
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: ListTile(
          leading: Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: context.tertiaryColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Text(
                AppStrings.wordleLetterText,
                style: AppTextStyles.h2.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          title: Text(
            AppStrings.wordleText,
            style: AppTextStyles.body.copyWith(
              color: context.textColor,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: context.textColor,
            size: 24.sp,
          ),
          onTap: () {
            _launchWordle();
          },
        ),
      ),
    );
  }
}
