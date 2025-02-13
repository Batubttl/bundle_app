import 'package:bundle_app/widgets/navigation_controller.dart';
import 'package:bundle_app/views/search/search_view.dart';
import 'package:bundle_app/widgets/app_view.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../views/auth/login_view.dart';
import '../views/auth/signup_view.dart';
import '../views/auth/welcome_view.dart';
import '../views/home/home_view.dart';

class AppRoutes {
  AppRoutes._();
  static const String home = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String profile = '/profile';
  static const String saved = '/saved';
  static const String search = '/search';
}

final _routerKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _routerKey,
  initialLocation: AppRoutes.home, // İlk açılışta HomeView
  routes: [
    // Auth routes (Shell dışında)
    GoRoute(
      path: AppRoutes.welcome,
      builder: (context, state) => const WelcomeView(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginView(),
    ),
    GoRoute(
      path: AppRoutes.signup,
      builder: (context, state) => const SignUpView(),
    ),

    // Main app shell (Bottom navigation için)
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppView(navigationShell: navigationShell),
      branches: [
        // Ana Sayfa branch'i
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomeView(),
            ),
          ],
        ),
        // Keşfet branch'i
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.search,
              builder: (context, state) => const SearchView(),
            ),
          ],
        ),
        // Kaydedilenler branch'i
      ],
    ),
  ],
);
