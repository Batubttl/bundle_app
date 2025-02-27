import 'package:bundle_app/core/extensions/theme_extension.dart';
import 'package:bundle_app/presentation/views/search/search_view_model.dart';
import 'package:flutter/material.dart';

class SearchTabBar extends StatelessWidget {
  final TabController controller;
  final SearchViewModel viewModel;

  const SearchTabBar({
    super.key,
    required this.controller,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide.none),
      ),
      child: TabBar(
        padding: EdgeInsets.zero,
        tabAlignment: TabAlignment.center,
        controller: controller,
        isScrollable: true,
        indicatorColor: context.primaryColor,
        labelColor: context.textColor,
        unselectedLabelColor: context.secondaryColor,
        dividerColor: Colors.transparent,
        tabs: viewModel.tabs.map((tab) => Tab(text: tab)).toList(),
      ),
    );
  }
}
