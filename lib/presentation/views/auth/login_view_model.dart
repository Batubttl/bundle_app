import 'package:bundle_app/core/constants/app_constants.dart';
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

  LoginViewModel(this._authService);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.needMail;
    }
    if (!value.contains('@')) {
      return AppStrings.invalidEmail;
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.needPassword;
    }
    if (value.length < 6) {
      return AppStrings.atLeastSix;
    }
    return null;
  }

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

  TextSpan get signUpTextSpan => TextSpan(
        text: AppStrings.noAccountText,
        style: AppTextStyles.body,
        children: [
          TextSpan(
            text: AppStrings.signUpText,
            style: AppTextStyles.body.copyWith(
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      );
}
