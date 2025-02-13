import 'package:bundle_app/services/auth_services.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService;
  bool isLoading = false;
  String? errorMessage;

  AuthViewModel(this._authService);

  Future<void> forgotPassword(String email) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      await _authService.sendPasswordResetEmail(email);

      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'E-posta adresi gerekli';
    }
    if (!value.contains('@')) {
      return 'Geçerli bir e-posta adresi girin';
    }
    return null;
  }
}
