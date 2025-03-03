import 'package:bundle_app/core/constants/app_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      if (kIsWeb) {
        await _auth.setPersistence(Persistence.LOCAL);
      }

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        if (!userCredential.user!.emailVerified) {}
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw AppStrings.userNotFound;
        case 'wrong-password':
          throw AppStrings.wrongPassword;
        case 'invalid-email':
          throw AppStrings.invalidEmail;
        case 'user-disabled':
          throw AppStrings.userDisabled;
        case 'too-many-requests':
          throw AppStrings.tooManyRequests;
        default:
          throw '${AppStrings.unexpectedError}: ${e.message}';
      }
    } catch (e) {
      throw AppStrings.unexpectedError;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            throw AppStrings.resetPasswordUserNotFound;
          case 'invalid-email':
            throw AppStrings.invalidEmail;
          default:
            throw '${AppStrings.unexpectedError}: ${e.message}';
        }
      }
      throw AppStrings.unexpectedError;
    }
  }

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String surname,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName('$name $surname');

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw AppStrings.signOutError;
    }
  }

  bool get isLoggedIn => currentUser != null;

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return AppStrings.invalidEmail;
      case 'user-disabled':
        return AppStrings.userDisabled;
      case 'user-not-found':
        return AppStrings.userNotFound;
      case 'wrong-password':
        return AppStrings.wrongPassword;
      case 'email-already-in-use':
        return AppStrings.emailAlreadyInUse;
      case 'weak-password':
        return AppStrings.weakPassword;
      default:
        return '${AppStrings.unexpectedError} ${e.message}';
    }
  }
}
