import 'package:bundle_app/core/network/api_client.dart';
import 'package:bundle_app/widgets/featured_sports_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../model/article_model.dart';
import '../../services/news_service.dart';
import '../news/news_details_view.dart';
import '../../core/utils/date_formatter.dart';
import 'featured_view_model.dart';
import '../story/story_view.dart';
import '../story/story_view_model.dart';

class FeaturedView extends StatelessWidget {
  const FeaturedView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FeaturedViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => StoryViewModel(
            stories: context.read<FeaturedViewModel>().getFeaturedStories(),
          ),
        ),
      ],
      child: const _FeaturedViewContent(),
    );
  }
}

class _FeaturedViewContent extends StatelessWidget {
  const _FeaturedViewContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FeaturedViewModel>(
      builder: (context, viewModel, child) => Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Consumer<FeaturedViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return CustomScrollView(
                slivers: [
                  _buildAppBar(),
                  _buildBundleSpecial(context, viewModel),
                  _buildNewsList(viewModel),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBundleSpecial(
      BuildContext context, FeaturedViewModel viewModel) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // BUNDLE ÖZEL Başlığı
          Padding(
            padding: EdgeInsets.only(left: 16.w, top: 16.h, bottom: 12.h),
            child: Text(
              'BUNDLE ÖZEL',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Story Items
          SizedBox(
            height: 90.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              children: [
                _buildStoryButton(
                  context: context,
                  title: 'Hot Bundle',
                  color: Colors.red,
                  stories: viewModel.getFeaturedStories(),
                ),
                _buildStoryButton(
                  context: context,
                  title: 'Dün Ne Oldu?',
                  color: Colors.blue,
                  stories: viewModel.getLatestStories(),
                ),
                _buildStoryButton(
                  context: context,
                  title: 'Bilim',
                  color: Colors.green,
                  stories: viewModel.getScienceStories(),
                ),
              ],
            ),
          ),

          // Spor haberi banner'ı
          if (viewModel.latestSportsArticle != null)
            FeaturedSportsBanner(
              article: viewModel.latestSportsArticle!,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsDetailView(
                      article: viewModel.latestSportsArticle!,
                    ),
                  ),
                );
              },
            ),

          // Popüler Başlığı
          Padding(
            padding: EdgeInsets.only(left: 16.w, top: 8.h, bottom: 8.h),
            child: Text(
              'Popüler',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryButton({
    required BuildContext context,
    required String title,
    required Color color,
    required List<Article> stories,
  }) {
    return GestureDetector(
      onTap: () {
        if (stories.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                create: (context) => StoryViewModel(stories: stories),
                child: StoryView(
                  stories: stories,
                  categoryTitle: title,
                  categoryColor: color,
                ),
              ),
            ),
          );
        }
      },
      child: Container(
        width: 70.w,
        margin: EdgeInsets.only(right: 16.w),
        child: Column(
          children: [
            Container(
              width: 70.w,
              height: 70.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: color,
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: stories.isNotEmpty && stories.first.urlToImage != null
                    ? Image.network(
                        stories.first.urlToImage!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              color: color,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(Icons.image_not_supported,
                                color: Colors.grey[700]),
                          );
                        },
                      )
                    : Center(
                        child: Icon(Icons.image_not_supported,
                            color: Colors.grey[700]),
                      ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsList(FeaturedViewModel viewModel) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormatter.formatSource(article.source)
                              .toUpperCase(),
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12.sp,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          article.title ?? '',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  if (article.urlToImage != null)
                    SizedBox(
                      width: 80.w,
                      height: 80.w,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: CachedNetworkImage(
                          imageUrl: article.urlToImage!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[900],
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[900],
                            child: Icon(Icons.error, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
        childCount: viewModel.articles.length,
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.black,
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
}
