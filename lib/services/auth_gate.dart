import 'package:filmfolio/ui/screens/filmfolio_app.dart';
import 'package:filmfolio/ui/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            // User is authenticated
            return const FilmfolioApp();
          } else {
            // User is not authenticated
            return const LoginScreen();
          }
        } else {
          // Loading state
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}