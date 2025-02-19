// TODO: Move to widgets folder
import 'package:bundle_app/views/featured/featured_view.dart';
import 'package:bundle_app/views/notifications/notifications_view.dart';
import 'package:bundle_app/views/search/search_view.dart';
import 'package:flutter/material.dart';
import '../views/home/home_view.dart';
import '../core/extensions/theme_extension.dart';
import '../core/theme/app_colors.dart';

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
              label: 'Ana Sayfa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined),
              activeIcon: Icon(Icons.article),
              label: 'Öne Çıkanlar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search),
              label: 'Arama',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_outlined),
              activeIcon: Icon(Icons.notifications),
              label: 'Bildirimler',
            ),
          ],
        ),
      ),
    );
  }
}
