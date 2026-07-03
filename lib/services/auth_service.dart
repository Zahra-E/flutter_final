// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 1. SIGN UP with Email & Password
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } catch (e) {
      rethrow;
    }
  }

  // 2. SIGN IN with Email & Password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } catch (e) {
      rethrow;
    }
  }

  // 3. SIGN OUT
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // 4. LISTEN to Auth State Changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // 5. GET Current User
  User? get currentUser => _auth.currentUser;
}
