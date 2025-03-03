import 'package:bundle_app/core/constants/app_constants.dart';
import 'package:bundle_app/presentation/views/auth/login_view.dart';
import 'package:bundle_app/presentation/views/auth/signup_view.dart';
import 'package:bundle_app/presentation/widgets/close_icon_widget.dart';
import 'package:bundle_app/presentation/widgets/social_button.dart';
import 'package:flutter/material.dart';
import 'package:bundle_app/presentation/widgets/custom_button.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            CloseWidget(),
            Column(
              children: [
                const SizedBox(height: 100),
                Image.asset(
                  AppAsset.bundleLogo,
                  height: 100,
                  width: 100,
                ),
                SizedBox(
                  height: 200,
                ),
                CustomButton(
                  borderRadius: 4,
                  height: 60,
                  text: AppStrings.titleText,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginView()));
                  },
                  imagePath: AppAsset.bundleButton,
                ),
                const SizedBox(
                  height: 12,
                ),
                const SizedBox(height: 30),
                _socialMediaButton(),
                const SizedBox(height: 30),
                _BuildSignupButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row _socialMediaButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialButton(
          imagePath: AppAsset.facebookLogo,
          onPressed: () {},
        ),
        SizedBox(width: 8),
        SocialButton(
          imagePath: AppAsset.googleLogo,
          onPressed: () {},
        ),
        SocialButton(
          imagePath: AppAsset.twitterLogo,
          onPressed: () {},
        ),
      ],
    );
  }
}

class _BuildSignupButton extends StatelessWidget {
  const _BuildSignupButton();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SignUpView(),
            ),
          ),
          child: const Text.rich(
            TextSpan(
              text: AppStrings.noAccountText,
              children: [
                TextSpan(
                  text: AppStrings.signUpText,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
