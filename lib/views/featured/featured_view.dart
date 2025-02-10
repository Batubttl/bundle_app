import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class FeaturedView extends StatelessWidget {
  const FeaturedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            _buildBundleSpecial(),
            _buildNewsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.black,
      toolbarHeight: 56.h,
      title: Text(
        'ÖNE ÇIKANLAR',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.menu, size: 24.sp),
        onPressed: () {},
      ),
      actions: [
        TextButton(
          onPressed: () {},
          child: Text(
            'TR ▼',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBundleSpecial() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              'BUNDLE ÖZEL',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 100.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              children: [
                _buildStoryItem('Hot Bundle', Colors.red),
                _buildStoryItem('Dün Ne Oldu?', Colors.red),
                _buildStoryItem('Bilim', Colors.blue),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryItem(String title, Color borderColor) {
    return Padding(
      padding: EdgeInsets.only(right: 16.w),
      child: Column(
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: 2.w),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            height: 200.h,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12.r),
            ),
          );
        },
        childCount: 10,
      ),
    );
  }
}
