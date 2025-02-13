import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WordleWidget extends StatelessWidget {
  const WordleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: ListTile(
          leading: Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Text(
                'W',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          title: Text(
            'Wordle oyna kafanı dağıt.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: Colors.white,
            size: 24.sp,
          ),
          onTap: () {
            // Wordle tıklama işlemi
          },
        ),
      ),
    );
  }
}
