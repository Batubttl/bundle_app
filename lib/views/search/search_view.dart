import 'dart:async';

import 'package:bundle_app/services/news_service.dart';
import 'package:bundle_app/views/news/news_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'search_view_model.dart';
import 'package:get_it/get_it.dart';
import 'package:bundle_app/widgets/custom_app_bar.dart';
import 'package:bundle_app/widgets/drawer_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../core/extensions/theme_extension.dart';
import '../../core/theme/app_texts.dart';

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
  const _SearchViewContent({super.key});

  @override
  State<_SearchViewContent> createState() => _SearchViewContentState();
}

class _SearchViewContentState extends State<_SearchViewContent>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  Timer? _debounceTimer;
  late TabController _tabController;

  final List<String> _tabs = ['Tümü', 'Kaynaklar', 'Haberler', 'Konular'];

  // Konular listesi
  final List<TopicItem> _topics = [
    TopicItem(
      title: 'ChatGPT',
      imageUrl: 'assets/images/gpt.png',
      isAddable: true,
    ),
    TopicItem(
      title: 'İndirim',
      imageUrl: 'assets/images/superlig.jpeg',
      isAddable: true,
    ),
    TopicItem(
      title: 'Kripto Para',
      imageUrl: 'assets/images/bitcoin.png',
      isAddable: true,
    ),
  ];

  // İlgi Alanları listesi genişletildi
  final List<InterestArea> _interestAreas = [
    InterestArea(
      title: 'Spor, sadece futbol değil',
      imageUrl: 'assets/images/tenis.jpg',
    ),
    InterestArea(
      title: 'Bilim & Teknoloji',
      imageUrl: 'assets/images/dunya.jpg',
    ),
    InterestArea(
      title: 'Ekonomi & Finans',
      imageUrl: 'assets/images/coin.png',
    ),
    InterestArea(
      title: 'Okumaya Değer',
      imageUrl: 'assets/images/kitap.jpg',
    ),
    InterestArea(
      title: 'Sağlık & Yaşam',
      imageUrl: 'assets/images/zihin.jpg',
    ),
  ];

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
        drawer: const DrawerWidget(),
        backgroundColor: context.backgroundColor,
        appBar: CustomAppBar(
          title: 'İÇERİK MAĞAZASI',
          centerTitle: true,
          showBackButton: false,
          leading: Builder(
            builder: (BuildContext context) => IconButton(
              icon: Icon(
                Icons.menu,
                size: 24.sp,
                color: context.textColor,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: TextField(
                controller: _searchController,
                onChanged: (query) => _onSearchChanged(query, viewModel),
                style: AppTextStyles.body.copyWith(color: context.textColor),
                decoration: InputDecoration(
                  hintText: 'Haber, Mecra, Konu ara',
                  hintStyle: AppTextStyles.body
                      .copyWith(color: context.secondaryColor),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.close, color: context.secondaryColor),
                    onPressed: () {
                      _searchController.clear();
                      viewModel.clearSearch();
                    },
                  ),
                  filled: true,
                  fillColor: context.cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // TabBar
            TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: context.primaryColor,
              indicatorWeight: 2,
              labelColor: context.textColor,
              unselectedLabelColor: context.secondaryColor,
              padding: EdgeInsets.zero,
              indicatorPadding: EdgeInsets.zero,
              tabAlignment: TabAlignment.center,
              tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.label,
            ),

            // Content
            Expanded(
              child: !_searchController.text.isEmpty
                  ? TabBarView(
                      controller: _tabController,
                      children: [
                        _buildSearchResults(viewModel),
                        _buildSourcesTab(viewModel),
                        _buildNewsTab(viewModel),
                        _buildTopicsTab(viewModel),
                      ],
                    )
                  : _buildInitialContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Konular başlığı
            Text(
              'Konular',
              style: AppTextStyles.h1.copyWith(
                color: context.textColor,
              ),
            ),
            SizedBox(height: 16.h),

            // Konular grid
            SizedBox(
              height: 120.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _topics.length,
                separatorBuilder: (_, __) => SizedBox(width: 12.w),
                itemBuilder: (context, index) {
                  final topic = _topics[index];
                  return _buildTopicCard(topic);
                },
              ),
            ),
            SizedBox(height: 32.h),

            // İlgi Alanları başlığı
            Text(
              'İlgi Alanları',
              style: AppTextStyles.h1.copyWith(
                color: context.textColor,
              ),
            ),
            SizedBox(height: 16.h),

            // İlgi Alanları Carousel
            CarouselSlider.builder(
              itemCount: _interestAreas.length,
              options: CarouselOptions(
                height: 240.h,
                viewportFraction: 0.85,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: false,
                enlargeCenterPage: true,
                enlargeFactor: 0.25,
                scrollDirection: Axis.horizontal,
              ),
              itemBuilder: (context, index, realIndex) {
                final area = _interestAreas[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    image: DecorationImage(
                      image: AssetImage(area.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Karartma efekti
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: Colors.black.withOpacity(0.4),
                        ),
                      ),
                      // İçerik
                      Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              area.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicCard(TopicItem topic) {
    return Container(
      width: 120.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        image: DecorationImage(
          image: AssetImage(topic.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  topic.title,
                  style: AppTextStyles.h2.copyWith(
                    color: Colors.white,
                  ),
                ),
                if (topic.isAddable)
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.black,
                      size: 20.sp,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(SearchViewModel viewModel) {
    if (viewModel.isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: context.primaryColor,
        ),
      );
    }

    if (viewModel.error != null) {
      return Center(
        child: Text(
          viewModel.error!,
          style: AppTextStyles.body.copyWith(color: context.textColor),
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
            color: context.cardColor,
            margin: EdgeInsets.only(bottom: 8.h),
            child: ListTile(
              title: Text(
                article.title ?? '',
                style: AppTextStyles.body.copyWith(
                  color: context.textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                article.source ?? '',
                style: AppTextStyles.caption.copyWith(
                  color: context.secondaryColor,
                ),
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

// Model sınıfları
class TopicItem {
  final String title;
  final String imageUrl;
  final bool isAddable;

  TopicItem({
    required this.title,
    required this.imageUrl,
    this.isAddable = false,
  });
}

class InterestArea {
  final String title;
  final String imageUrl;

  InterestArea({
    required this.title,
    required this.imageUrl,
  });
}
