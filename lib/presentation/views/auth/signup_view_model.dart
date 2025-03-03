import 'package:bundle_app/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import '../../../services/auth_services.dart';
import 'login_view.dart';

class SignUpViewModel extends ChangeNotifier {
  final AuthService _authService;

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  SignUpViewModel(this._authService);

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ad gerekli';
    }
    return null;
  }

  String? validateSurname(String? value) {
    if (value == null || value.isEmpty) {
      return 'Soyad gerekli';
    }
    return null;
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
      return AppStrings.needMail;
    }
    if (value.length < 6) {
      return AppStrings.atLeastSix;
    }
    return null;
  }

  Future<void> handleSignUp(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      try {
        await _authService.signUpWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
          name: nameController.text.trim(),
          surname: surnameController.text.trim(),
        );

        if (context.mounted) {
          navigateToLogin(context);
        }
      } catch (e) {
        _errorMessage = e.toString();
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  void navigateToLogin(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginView()),
      (route) => false,
    );
  }
}
