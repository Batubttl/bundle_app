import 'package:bundle_app/views/auth/login_view.dart';
import 'package:bundle_app/widgets/social_button.dart';
import 'package:flutter/material.dart';
import 'package:bundle_app/widgets/custom_button.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Çarpı ikonu
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 24,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
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
                const SizedBox(height: 32),
                Row(
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
                    SizedBox(width: 8),
                    SocialButton(
                      imagePath: 'assets/images/twitter.png',
                      onPressed: () {
                        // Twitter giriş işlemi
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 48), // Alt boşluk
              ],
            ),
          ],
        ),
      ),
    );
  }
}
