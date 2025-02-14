import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../model/story_model.dart';
import '../../model/article_model.dart';
import 'package:provider/provider.dart';
import 'story_view_model.dart';

class StoryView extends StatelessWidget {
  final List<Article> stories;
  final String categoryTitle;
  final Color categoryColor;

  const StoryView({
    Key? key,
    required this.stories,
    required this.categoryTitle,
    required this.categoryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StoryViewModel(stories: stories),
      child: _StoryViewContent(
        categoryTitle: categoryTitle,
        categoryColor: categoryColor,
      ),
    );
  }
}

class _StoryViewContent extends StatelessWidget {
  final String categoryTitle;
  final Color categoryColor;

  const _StoryViewContent({
    Key? key,
    required this.categoryTitle,
    required this.categoryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<StoryViewModel>(
      builder: (context, viewModel, child) {
        return GestureDetector(
          onTapDown: (details) {
            final screenWidth = MediaQuery.of(context).size.width;
            if (details.globalPosition.dx < screenWidth * 0.3) {
              viewModel.previousStory();
            } else if (details.globalPosition.dx > screenWidth * 0.7) {
              viewModel.nextStory();
            }
          },
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                // Progress bar
                Positioned(
                  top: 44.h,
                  left: 0,
                  right: 0,
                  child: Row(
                    children: List.generate(
                      viewModel.stories.length,
                      (index) => Expanded(
                        child: Container(
                          height: 2,
                          margin: EdgeInsets.symmetric(horizontal: 2.w),
                          color: viewModel.currentIndex >= index
                              ? Colors.white
                              : Colors.white.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                ),

                // Story content
                _StoryContent(
                  story: viewModel.currentStory,
                  categoryTitle: categoryTitle,
                  categoryColor: categoryColor,
                ),

                // Close button
                Positioned(
                  top: 32.h,
                  right: 8.w,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.white, size: 24.sp),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                // Loading indicator
                if (viewModel.isLoading)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StoryContent extends StatelessWidget {
  final Article story;
  final String categoryTitle;
  final Color categoryColor;

  const _StoryContent({
    Key? key,
    required this.story,
    required this.categoryTitle,
    required this.categoryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: EdgeInsets.only(top: 60.h, left: 16.w, right: 16.w),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: categoryColor,
                child: Text(categoryTitle[0]),
              ),
              SizedBox(width: 8.w),
              Text(
                categoryTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                '1 GÜN ÖNCE',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),

        // Content
        Expanded(
          child: GestureDetector(
            onVerticalDragEnd: (details) {
              if (details.primaryVelocity! < 0) {
                // Yukarı kaydırıldığında haber detayına git
                context.read<StoryViewModel>().navigateToNewsDetail(context);
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (story.urlToImage != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.network(
                        story.urlToImage!,
                        height: 200.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  SizedBox(height: 24.h),
                  Text(
                    story.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Footer
        Padding(
          padding: EdgeInsets.only(bottom: 32.h),
          child: Column(
            children: [
              Text(
                story.source,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14.sp,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'HABER DETAYI İÇİN KAYDIR',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
