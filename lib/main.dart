import 'package:bundle_app/core/dio/locator.dart';
import 'package:bundle_app/firebase_options.dart';
import 'package:bundle_app/views/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'widgets/navigation_controller.dart';
import 'core/theme/app_theme.dart';
import 'views/home/home_view_model.dart';
import 'views/search/search_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'views/featured/featured_view.dart';
import 'services/news_service.dart';
import 'core/network/api_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(NewsService(ApiClient())),
      child: ScreenUtilInit(
        builder: (context, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Bundle App',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.black,
            inputDecorationTheme: const InputDecorationTheme(
              labelStyle: TextStyle(color: Colors.grey),
              hintStyle: TextStyle(color: Colors.grey),
            ),
            textTheme: const TextTheme(
              bodyMedium: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
          home: const NavigationController(),
        ),
      ),
    );
  }
}
