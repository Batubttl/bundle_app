import 'package:bundle_app/core/enum/news_category_enum.dart';
import 'package:bundle_app/presentation/widgets/navigation_controller.dart';
import 'package:flutter/material.dart';
import '../../../services/news_service.dart';
import 'package:get_it/get_it.dart';

class SplashViewModel extends ChangeNotifier {
  final NewsService _newsService = GetIt.I<NewsService>();
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      await Future.wait([
        _newsService.getNewsByCategory(NewsCategory.tumu),
        _newsService.getFeaturedNews(),
      ]);

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Splash init error: $e');
    }
  }

  Future<void> handleNavigation(BuildContext context) async {
    await init();
    if (!context.mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const NavigationController(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
      (route) => false,
    );
  }
}
