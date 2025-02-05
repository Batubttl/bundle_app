import 'package:bundle_app/core/dio/locator.dart';
import 'package:bundle_app/views/home/home_view_model.dart';
import 'package:bundle_app/widgets/news_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/category_tab_bar.dart';
import '../../widgets/news_grid_item.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/drawer_widget.dart';

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
    return Scaffold(
      drawer: const DrawerWidget(),
      body: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) => Column(
          children: [
            // App Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                  Text(
                    'İÇERİK MAĞAZASI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'TR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
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
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo is ScrollEndNotification &&
                        scrollInfo.metrics.pixels >=
                            scrollInfo.metrics.maxScrollExtent * 0.8) {
                      viewModel.loadMoreNews();
                    }
                    return true;
                  },
                  child: viewModel.isLoading && viewModel.articles.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : viewModel.error != null && viewModel.articles.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.error_outline,
                                      size: 48.sp, color: Colors.grey),
                                  SizedBox(height: 16.h),
                                  Text(
                                    viewModel.error!,
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14.sp),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 16.h),
                                  ElevatedButton(
                                    onPressed: viewModel.refreshNews,
                                    child: const Text('Tekrar Dene'),
                                  ),
                                ],
                              ),
                            )
                          : CustomScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              slivers: [
                                SliverPadding(
                                  padding: EdgeInsets.all(8.w),
                                  sliver: SliverGrid(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          MediaQuery.of(context).size.width >
                                                  600
                                              ? 3
                                              : 2,
                                      mainAxisSpacing: 8.h,
                                      crossAxisSpacing: 8.w,
                                      childAspectRatio:
                                          MediaQuery.of(context).size.width >
                                                  600
                                              ? 0.8
                                              : 0.75,
                                    ),
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) => NewsGridItem(
                                        article: viewModel.articles[index],
                                      ),
                                      childCount: viewModel.articles.length,
                                    ),
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
            ),
          ],
        ),
      ),
    );
  }
}
