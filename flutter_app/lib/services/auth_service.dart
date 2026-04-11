import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up with email and password
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await setLoggedIn(true);
      return cred.user;
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with email and password
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await setLoggedIn(true);
      return cred.user;
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await setLoggedIn(false);
  }

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Check if logged in
  Future<bool> get isLoggedIn async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('loggedIn') ?? false;
  }

  // Set logged in status
  Future<void> setLoggedIn(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', value);
  }

  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
