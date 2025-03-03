import 'package:bundle_app/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import '../../../services/auth_services.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final AuthService _authService;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  ForgotPasswordViewModel(this._authService);

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void navigateBack(BuildContext context) {
    Navigator.pop(context);
  }

  Future<void> handleForgotPassword(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      final success = await forgotPassword(emailController.text.trim());

      if (!context.mounted) return;

      if (success) {
        _showSuccessMessage(context);
        navigateBack(context);
      } else {
        _showErrorMessage(context);
      }
    }
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'E-posta adresi boş bırakılamaz';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Geçerli bir e-posta adresi giriniz';
    }
    return null;
  }

  // Şifre sıfırlama işlemi
  Future<bool> forgotPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.sendPasswordResetEmail(email);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void _showSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppStrings.sendPasswordResetEmail),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
      ),
    );
  }

  void _showErrorMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage ?? AppStrings.unexpectedError),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
