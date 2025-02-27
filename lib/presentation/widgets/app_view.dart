import 'package:bundle_app/core/constants/app_constants.dart';
import 'package:bundle_app/presentation/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppView extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppView({
    required this.navigationShell,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: const DrawerWidget(),
        body: navigationShell,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          onTap: (index) => navigationShell.goBranch(index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: AppStrings.homeText,
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.search), label: AppStrings.navgiatonSearch),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: AppStrings.saveText,
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: AppStrings.profileText),
          ],
        ),
      ),
    );
  }
}
