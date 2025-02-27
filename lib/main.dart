import 'package:bundle_app/core/di/locator.dart';
import 'package:bundle_app/firebase_options.dart';
import 'package:bundle_app/presentation/views/splash/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bundle_app/providers/theme_provider.dart';
import 'package:bundle_app/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setupLocator();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const BundleApp(),
    ),
  );
}

class BundleApp extends StatelessWidget {
  const BundleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_, child) => MaterialApp(
            debugShowCheckedModeBanner: false,

            theme: AppTheme.lightTheme, // Aydınlık tema
            darkTheme: AppTheme.darkTheme, // Karanlık tema
            themeMode:
                themeProvider.themeMode, // Tema modu (system, light, dark)
            home: const SplashView(),
          ),
        );
      },
    );
  }
}
