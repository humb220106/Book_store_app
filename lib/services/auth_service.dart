import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign Up
  static Future<bool> signup({required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print('Signup error: $e');
      return false;
    }
  }

  // Login
  static Future<bool> login({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  // Reset Password
  static Future<bool> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print('Reset password error: $e');
      return false;
    }
  }

  // Google Login
  static Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return false;
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      await _auth.signInWithCredential(credential);
      return true;
    } catch (e) {
      print('Google sign in error: $e');
      return false;
    }
  }

  // Facebook Login
  static Future<bool> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status != LoginStatus.success) return false;
      final OAuthCredential credential =
          FacebookAuthProvider.credential(result.accessToken!.token);
      await _auth.signInWithCredential(credential);
      return true;
    } catch (e) {
      print('Facebook sign in error: $e');
      return false;
    }
  }
}
