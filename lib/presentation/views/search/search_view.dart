import 'package:bundle_app/core/constants/app_constants.dart';
import 'package:bundle_app/presentation/widgets/search_bar_widget.dart';
import 'package:bundle_app/presentation/widgets/search_grid_news.dart';
import 'package:bundle_app/presentation/widgets/search_initial_content.dart';
import 'package:bundle_app/presentation/widgets/search_results_widget.dart';
import 'package:bundle_app/presentation/widgets/search_tabbar_widget.dart';
import 'package:bundle_app/services/news_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'search_view_model.dart';
import 'package:get_it/get_it.dart';
import 'package:bundle_app/presentation/widgets/custom_app_bar.dart';
import 'package:bundle_app/presentation/widgets/drawer_widget.dart';
import '../../../core/extensions/theme_extension.dart';

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
  const _SearchViewContent();

  @override
  State<_SearchViewContent> createState() => _SearchViewContentState();
}

class _SearchViewContentState extends State<_SearchViewContent>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SearchViewModel>(context, listen: false)
          .initTabController(this);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchViewModel>(
      builder: (context, viewModel, child) => Scaffold(
        drawer: const DrawerWidget(),
        backgroundColor: context.backgroundColor,
        appBar: CustomAppBar(
          title: AppStrings.searchTitle,
          centerTitle: true,
          showBackButton: false,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, size: 24.sp, color: context.textColor),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchBarWidget(viewModel: viewModel),
            if (viewModel.searchController.text.isNotEmpty)
              SearchTabBar(
                controller: viewModel.tabController,
                viewModel: viewModel,
              ),
            Expanded(
              child: viewModel.searchController.text.isNotEmpty
                  ? TabBarView(
                      controller: viewModel.tabController,
                      children: [
                        SearchResultsWidget(viewModel: viewModel),
                        const Center(child: Text(AppStrings.sourcesText)),
                        SearchNewsGridWidget(
                          articles: viewModel.articles,
                          isLoading: viewModel.isLoading,
                          searchText: viewModel.searchController.text,
                        ),
                        const Center(child: Text(AppStrings.subjectText)),
                      ],
                    )
                  : SearchInitialContent(viewModel: viewModel),
            ),
          ],
        ),
      ),
    );
  }
}
