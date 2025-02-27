import 'package:bundle_app/core/constants/app_constants.dart';
import 'package:bundle_app/presentation/views/featured/featured_view.dart';
import 'package:bundle_app/presentation/views/notifications/notifications_view.dart';
import 'package:bundle_app/presentation/views/search/search_view.dart';
import 'package:flutter/material.dart';
import '../views/home/home_view.dart';
import '../../core/extensions/theme_extension.dart';

class NavigationController extends StatefulWidget {
  const NavigationController({super.key});

  @override
  State<NavigationController> createState() => _NavigationControllerState();
}

class _NavigationControllerState extends State<NavigationController> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeView(),
    const FeaturedView(),
    const SearchView(),
    const NotificationsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: context.cardColor,
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          backgroundColor: context.backgroundColor,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: context.textColor,
          unselectedItemColor: context.secondaryColor,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: AppStrings.homeText),
            BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined),
              activeIcon: Icon(Icons.article),
              label: AppStrings.appBarFeatured,
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.search_outlined),
                activeIcon: Icon(Icons.search),
                label: AppStrings.canSearch),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications_outlined),
                activeIcon: Icon(Icons.notifications),
                label: AppStrings.notificationsTitle),
          ],
        ),
      ),
    );
  }
}
