import 'package:bundle_app/core/dio/locator.dart';
import 'package:bundle_app/views/home/home_view_model.dart';
import 'package:bundle_app/widgets/news_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/category_tab_bar.dart';
import '../../widgets/news_grid_item.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  Future<void> _launchWordle() async {
    final Uri url = Uri.parse('https://wordleturkce.bundle.app/');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('URL açılamadı: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<HomeViewModel>(),
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) => Column(
          children: [
            // App Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(Icons.menu, color: Colors.white, size: 24.sp),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Category TabBar
            CategoryTabBar(
              selectedCategory: viewModel.selectedCategory,
              onCategorySelected: viewModel.changeCategory,
            ),

            // Wordle Banner
            InkWell(
              onTap: _launchWordle,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  children: [
                    Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Center(
                        child: Text(
                          'W',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Wordle oyna kafanı dağıt.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.grey[400],
                      size: 24.sp,
                    ),
                  ],
                ),
              ),
            ),

            // News Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: viewModel.refreshNews,
                child: CustomScrollView(
                  cacheExtent: 1000,
                  slivers: [
                    SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            MediaQuery.of(context).size.width > 600 ? 3 : 2,
                        mainAxisSpacing: 8.h,
                        crossAxisSpacing: 8.w,
                        childAspectRatio:
                            MediaQuery.of(context).size.width > 600
                                ? 0.8
                                : 0.75,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index >= viewModel.articles.length - 4) {
                            viewModel.loadMoreNews();
                          }
                          if (index < viewModel.articles.length) {
                            return NewsGridItem(
                              article: viewModel.articles[index],
                            );
                          }
                          return null;
                        },
                        childCount: viewModel.articles.length,
                      ),
                    ),
                    if (viewModel.isLoading)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(16.h),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
