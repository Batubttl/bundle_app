import 'package:bundle_app/core/theme/app_texts.dart';
import 'package:bundle_app/presentation/views/auth/forget_password_view.dart';
import 'package:bundle_app/presentation/views/auth/signup_view.dart';
import 'package:bundle_app/presentation/views/home/home_view.dart';
import 'package:flutter/material.dart';
import '../../../services/auth_services.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // String sabitleri
  static const String titleText = "Bundle'a Giriş Yap";
  static const String emailHint = 'E-posta';
  static const String passwordHint = 'Parola';
  static const String loginButtonText = 'Giriş Yap';
  static const String loadingText = 'Gönderiliyor...';
  static const String forgotPasswordText = 'Parolanızı mı unuttunuz?';
  static const String noAccountText = 'Hesabınız mı yok? ';
  static const String signUpText = 'Bundle için kaydolun.';

  LoginViewModel(this._authService);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Form validasyonları
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'E-posta adresi gerekli';
    }
    if (!value.contains('@')) {
      return 'Geçerli bir e-posta adresi girin';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Parola gerekli';
    }
    if (value.length < 6) {
      return 'Parola en az 6 karakter olmalı';
    }
    return null;
  }

  // Navigation metodları
  void navigateToForgotPassword(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ForgotPasswordView(),
      ),
    );
  }

  void navigateToSignUp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpView(),
      ),
    );
  }

  void navigateBack(BuildContext context) {
    Navigator.pop(context);
  }

  void navigateToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeView()),
      (route) => false,
    );
  }

  // Login işlemi
  Future<void> handleLogin(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      try {
        await _authService.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
        );

        if (context.mounted) {
          navigateToHome(context);
        }
      } catch (e) {
        _errorMessage = e.toString();
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  // Text.rich için getter
  TextSpan get signUpTextSpan => TextSpan(
        text: noAccountText,
        style: AppTextStyles.body,
        children: [
          TextSpan(
            text: signUpText,
            style: AppTextStyles.body.copyWith(
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      );
}
