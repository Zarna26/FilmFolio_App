import 'package:filmfolio/controllers/user_controller.dart';
import 'package:filmfolio/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final UserController _userController = UserController();

  Future<firebase_auth.UserCredential> signInWithEmailPassword(String email, String password) async {
    try {
      User? user = await _userController.getUser(email);
      if (user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', user.id);
        await prefs.setString('user_name', user.name);
        await prefs.setString('user_email', user.email);
        await prefs.setString('user_profile', user.profileUrl);
      }

      firebase_auth.UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on firebase_auth.FirebaseAuthException catch (error) {
      throw Exception(error.code);
    }
  }

  Future<firebase_auth.UserCredential> signUpWithEmailPassword(String email, String password) async {
    try {
      firebase_auth.UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
