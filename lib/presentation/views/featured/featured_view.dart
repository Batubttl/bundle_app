import 'package:bundle_app/core/constants/app_constants.dart';
import 'package:bundle_app/presentation/widgets/drawer_widget.dart';
import 'package:bundle_app/presentation/widgets/featured_sports_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../../model/article_model.dart';
import '../news/news_details_view.dart';
import '../../../core/utils/date_formatter.dart';
import 'featured_view_model.dart';
import '../story/story_view.dart';
import '../story/story_view_model.dart';
import '../../../core/extensions/theme_extension.dart';
import '../../../core/theme/app_texts.dart';
import '../../widgets/custom_app_bar.dart';
import 'package:get_it/get_it.dart';
import '../../../services/news_service.dart';

class FeaturedView extends StatelessWidget {
  const FeaturedView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              FeaturedViewModel(newsService: GetIt.I<NewsService>()),
        ),
        ChangeNotifierProxyProvider<FeaturedViewModel, StoryViewModel>(
          create: (context) => StoryViewModel(stories: []),
          update: (context, featuredViewModel, previous) =>
              StoryViewModel(stories: featuredViewModel.getFeaturedStories()),
        ),
      ],
      child: const _FeaturedViewContent(),
    );
  }
}

class _FeaturedViewContent extends StatelessWidget {
  const _FeaturedViewContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<FeaturedViewModel>(
      builder: (context, viewModel, child) => Scaffold(
        drawer: const DrawerWidget(),
        backgroundColor: context.backgroundColor,
        body: SafeArea(
          child: Consumer<FeaturedViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: context.primaryColor,
                  ),
                );
              }

              return CustomScrollView(
                slivers: [
                  _buildAppBar(context),
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
              AppStrings.specialTitle,
              style: AppTextStyles.h2.copyWith(
                color: context.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Story Items
          SizedBox(
            height: 100.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              children: [
                _buildStoryButton(
                  context: context,
                  title: AppStrings.storyFirstTitle,
                  color: Colors.red,
                  stories: viewModel.getFeaturedStories(),
                ),
                _buildStoryButton(
                  context: context,
                  title: AppStrings.storySecondTitle,
                  color: Colors.blue,
                  stories: viewModel.getLatestStories(),
                ),
                _buildStoryButton(
                  context: context,
                  title: AppStrings.storyThirdTitle,
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
              AppStrings.featuredTitle,
              style: AppTextStyles.h1.copyWith(
                color: context.textColor,
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
                            child: Icon(
                              Icons.image_not_supported,
                              color: context.secondaryColor,
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: context.secondaryColor,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              title,
              style: AppTextStyles.caption.copyWith(
                color: context.secondaryColor,
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
                          style: AppTextStyles.caption.copyWith(
                            color: context.secondaryColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          article.title,
                          style: AppTextStyles.body.copyWith(
                            color: context.textColor,
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
                            color: context.cardColor,
                          ),
                          errorWidget: (context, error, stackTrace) =>
                              Container(
                            color: context.cardColor,
                            child: Icon(Icons.error, color: context.textColor),
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

  Widget _buildAppBar(BuildContext context) {
    return SliverToBoxAdapter(
      child: CustomAppBar(
        title: AppStrings.appBarFeatured,
        centerTitle: true,
        showBackButton: false,
        leading: const DrawerWidget(isDrawerButton: true),
      ),
    );
  }
}
