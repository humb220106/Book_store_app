import 'package:flutter/material.dart';
import '../services/auth_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> registerWithEmail({
    required String email,
    required String password,
  }) async {
    setLoading(true);
    try {
      return await AuthService.signup(email: email, password: password);
    } catch (e) {
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> signInWithGoogle() async {
    setLoading(true);
    try {
      return await AuthService.signInWithGoogle();
    } finally {
      setLoading(false);
    }
  }

  Future<bool> signInWithFacebook() async {
    setLoading(true);
    try {
      return await AuthService.signInWithFacebook();
    } finally {
      setLoading(false);
    }
  }
}
