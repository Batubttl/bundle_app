import 'package:bundle_app/core/dio/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'core/navigation/navigation_controller.dart';
import 'core/theme/app_theme.dart';
import 'views/home/home_view_model.dart';
import 'views/search/search_view_model.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => locator<HomeViewModel>()),
            ChangeNotifierProvider(create: (_) => locator<SearchViewModel>()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Bundle App',
            theme: AppTheme.darkTheme,
            home: const NavigationController(),
          ),
        );
      },
    );
  }
}
