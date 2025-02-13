import 'dart:async';

import 'package:bundle_app/services/news_service.dart';
import 'package:bundle_app/views/news/news_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'search_view_model.dart';
import 'package:get_it/get_it.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SearchViewModel(GetIt.I<NewsService>()),
      child: const _SearchViewContent(),
    );
  }
}

class _SearchViewContent extends StatefulWidget {
  const _SearchViewContent({Key? key}) : super(key: key);

  @override
  State<_SearchViewContent> createState() => _SearchViewContentState();
}

class _SearchViewContentState extends State<_SearchViewContent>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  Timer? _debounceTimer;
  late TabController _tabController;

  final List<String> _tabs = ['Tümü', 'Kaynaklar', 'Haberler', 'Konular'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query, SearchViewModel viewModel) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      viewModel.searchNews(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchViewModel>(
      builder: (context, viewModel, child) => Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            // App Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[900]!,
                    width: 0.5,
                  ),
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Title and Language
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.menu,
                              color: Colors.white, size: 24.sp),
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
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
                    SizedBox(height: 16.h),
                    // Search Bar
                    TextField(
                      controller: _searchController,
                      onChanged: (query) => _onSearchChanged(query, viewModel),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Haber, Mecra, Konu ara',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.close, color: Colors.grey[600]),
                          onPressed: () {
                            _searchController.clear();
                            viewModel.clearSearch();
                          },
                        ),
                        filled: true,
                        fillColor: Colors.grey[900],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // TabBar
                    TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      indicatorColor: Colors.red,
                      indicatorWeight: 2,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.grey,
                      padding: EdgeInsets.zero,
                      indicatorPadding: EdgeInsets.zero,
                      tabAlignment: TabAlignment.start,
                      tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
                      dividerColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.label,
                    ),
                  ],
                ),
              ),
            ),

            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildSearchResults(viewModel),
                  _buildSourcesTab(viewModel),
                  _buildNewsTab(viewModel),
                  _buildTopicsTab(viewModel),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(SearchViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.error != null) {
      return Center(
        child: Text(
          viewModel.error!,
          style: const TextStyle(color: Colors.white),
        ),
      );
    }

    if (_searchController.text.isEmpty) {
      return Center(
        child: Text(
          'Arama yapmak için bir şeyler yazın',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    if (viewModel.articles.isEmpty) {
      return Center(
        child: Text(
          'Sonuç bulunamadı',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    return ListView.builder(
      itemCount: viewModel.articles.length,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemBuilder: (context, index) {
        final article = viewModel.articles[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsDetailView(article: article),
              ),
            );
          },
          child: Card(
            color: Colors.grey[900],
            margin: EdgeInsets.only(bottom: 8.h),
            child: ListTile(
              title: Text(
                article.title ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                article.source ?? '',
                style: TextStyle(color: Colors.grey[400]),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSourcesTab(SearchViewModel viewModel) {
    return Center(
      child: Text(
        'Kaynaklar',
        style: TextStyle(color: Colors.grey[600]),
      ),
    );
  }

  Widget _buildNewsTab(SearchViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_searchController.text.isEmpty) {
      return Center(
        child: Text(
          'Arama yapmak için bir şeyler yazın',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    if (viewModel.articles.isEmpty) {
      return Center(
        child: Text(
          'Sonuç bulunamadı',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 16.h,
        crossAxisSpacing: 16.w,
        itemCount: viewModel.articles.length,
        itemBuilder: (context, index) {
          final article = viewModel.articles[index];
          return GestureDetector(
            onTap: () {
              // Haber detayına git
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (article.urlToImage != null)
                    ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(8.r)),
                      child: Image.network(
                        article.urlToImage!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.source ?? '',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          article.title ?? '',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopicsTab(SearchViewModel viewModel) {
    return Center(
      child: Text(
        'Konular',
        style: TextStyle(color: Colors.grey[600]),
      ),
    );
  }
}
