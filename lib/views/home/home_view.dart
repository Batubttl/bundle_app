import 'package:bundle_app/core/network/api_client.dart';
import 'package:bundle_app/services/news_service.dart';
import 'package:bundle_app/views/home/home_view_model.dart';
import 'package:bundle_app/widgets/wordle_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/category_tab_bar.dart';
import '../../widgets/news_grid_item.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/drawer_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../news/news_details_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(NewsService(ApiClient())),
      child: const _HomeViewContent(),
    );
  }
}

class _HomeViewContent extends StatelessWidget {
  const _HomeViewContent({super.key});

  Future<void> _launchWordle() async {
    final Uri url = Uri.parse('https://wordleturkce.bundle.app/');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('URL açılamadı: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) => Scaffold(
        backgroundColor: Colors.black,
        drawer: const DrawerWidget(),
        body: SafeArea(
          child: Column(
            children: [
              CategoryTabBar(
                selectedCategory: viewModel.selectedCategory,
                onCategorySelected: viewModel.changeCategory,
              ),
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
                        : SingleChildScrollView(
                            child: Column(
                              children: [
                                const WordleWidget(),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.w),
                                  child: MasonryGridView.count(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 16,
                                    crossAxisSpacing: 16,
                                    itemCount: viewModel.articles.length,
                                    itemBuilder: (context, index) {
                                      final article = viewModel.articles[index];
                                      final isFeatured = index % 5 == 0;
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  NewsDetailView(
                                                article: article,
                                              ),
                                            ),
                                          );
                                        },
                                        child: NewsGridItem(
                                          article: article,
                                          isFeatured: isFeatured,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
