import 'package:filmfolio/services/auth_gate.dart';
import 'package:filmfolio/services/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const FilmFolio());
}

class FilmFolio extends StatelessWidget {
  const FilmFolio({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FilmFolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.amber,
        scaffoldBackgroundColor: Colors.black87,
        iconTheme: const IconThemeData(color: Colors.amber),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      home: const AuthGate(),
    );
  }
}
