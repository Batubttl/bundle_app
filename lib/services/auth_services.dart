import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Giriş yap
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Web platformu için reCAPTCHA yapılandırması
      if (kIsWeb) {
        await _auth.setPersistence(Persistence.LOCAL);
        // Web için reCAPTCHA yapılandırması eklenebilir
      }

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Giriş başarılı olduğunda kullanıcı bilgilerini kontrol et
      if (userCredential.user != null) {
        // E-posta doğrulaması kontrolü (isteğe bağlı)
        if (!userCredential.user!.emailVerified) {
          // await userCredential.user!.sendEmailVerification();
          // throw 'Lütfen e-posta adresinizi doğrulayın';
        }
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw 'Bu e-posta adresi ile kayıtlı kullanıcı bulunamadı';
        case 'wrong-password':
          throw 'Hatalı parola';
        case 'invalid-email':
          throw 'Geçersiz e-posta adresi';
        case 'user-disabled':
          throw 'Bu hesap devre dışı bırakılmış';
        case 'too-many-requests':
          throw 'Çok fazla başarısız giriş denemesi. Lütfen daha sonra tekrar deneyin';
        default:
          throw 'Bir hata oluştu: ${e.message}';
      }
    } catch (e) {
      throw 'Beklenmeyen bir hata oluştu: $e';
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            throw 'Bu e-posta adresi ile kayıtlı bir kullanıcı bulunamadı.';
          case 'invalid-email':
            throw 'Geçersiz e-posta adresi.';
          default:
            throw 'Bir hata oluştu: ${e.message}';
        }
      }
      throw 'Beklenmeyen bir hata oluştu.';
    }
  }

  // Mevcut kullanıcıyı al
  User? get currentUser => _auth.currentUser;

  // Kullanıcı durumu değişikliklerini dinle
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Kayıt ol
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

      // Kullanıcı profil bilgilerini güncelle
      await userCredential.user?.updateDisplayName('$name $surname');

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Çıkış yap
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw 'Çıkış yapılırken bir hata oluştu: $e';
    }
  }

  // Oturum durumunu kontrol et
  bool get isLoggedIn => currentUser != null;

  // Firebase hata mesajlarını Türkçeleştir
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Geçersiz e-posta adresi';
      case 'user-disabled':
        return 'Kullanıcı hesabı devre dışı bırakılmış';
      case 'user-not-found':
        return 'Kullanıcı bulunamadı';
      case 'wrong-password':
        return 'Hatalı parola';
      case 'email-already-in-use':
        return 'Bu e-posta adresi zaten kullanımda';
      case 'weak-password':
        return 'Parola çok zayıf';
      default:
        return 'Bir hata oluştu: ${e.message}';
    }
  }
}
