import 'package:bundle_app/core/theme/app_texts.dart';
import 'package:bundle_app/presentation/views/auth/login_view.dart';
import 'package:bundle_app/presentation/views/auth/login_view_model.dart';
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

            // Ana içerik

            Column(
              children: [
                // Logo
                const SizedBox(height: 100), // Üstten boşluk
                Image.asset(
                  'assets/images/bundle.png',
                  height: 100, // Logo boyutu
                  width: 100,
                ),
                SizedBox(
                  height: 200,
                ), // Logo ile butonlar arası esnek boşluk
                // Butonlar
                CustomButton(
                  borderRadius: 4,
                  height: 60,
                  text: 'Bundle ile giriş yap',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginView()));
                    // Giriş işlemi
                  },
                  imagePath: 'assets/images/bundle-removebg-preview.png',
                ),
                const SizedBox(
                  height: 12,
                ),

                // Sosyal medya butonları
                const SizedBox(height: 30),

                _socialMediaButton(),

                const SizedBox(height: 30), // Alt boşluk

                _buildSignupButton(),
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
          imagePath: 'assets/images/facebook-removebg-preview.png',
          onPressed: () {
            // Facebook giriş işlemi
          },
        ),
        SizedBox(width: 8),
        SocialButton(
          imagePath: 'assets/images/google-removebg-preview.png',
          onPressed: () {
            // Google giriş işlemi
          },
        ),
        SocialButton(
          imagePath: 'assets/images/twitter.png',
          onPressed: () {
            // Twitter giriş işlemi
          },
        ),
      ],
    );
  }
}

class _buildSignupButton extends StatelessWidget {
  const _buildSignupButton();

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
              text: 'Hesabınız mı yok? ',
              children: [
                TextSpan(
                  text: 'Bundle için kaydolun.',
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

Widget _buildSignUpButton(BuildContext context, LoginViewModel viewModel) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 100),
    child: TextButton(
      onPressed: () => viewModel.navigateToSignUp(context),
      child: Text.rich(
        viewModel.signUpTextSpan,
        style: AppTextStyles.body.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    ),
  );
}
