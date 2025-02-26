import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/extensions/theme_extension.dart';
import 'splash_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/navigation_controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SplashViewModel(),
      child: const _SplashViewContent(),
    );
  }
}

class _SplashViewContent extends StatelessWidget {
  const _SplashViewContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashViewModel>(
      builder: (context, viewModel, child) {
        viewModel.init().then((_) {
          Navigator.of(context).pushAndRemoveUntil(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => 
                const NavigationController(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
            (route) => false,
          );
        });

        return Scaffold(
          backgroundColor: context.backgroundColor,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/bundle-removebg-preview.png',
                  width: 200.w,
                  height: 200.w,
                ),
                SizedBox(height: 24.h),
                
                
              ],
            ),
          ),
        );
      },
    );
  }
}
