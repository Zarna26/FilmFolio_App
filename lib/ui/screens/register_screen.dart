import 'package:filmfolio/controllers/user_controller.dart';
import 'package:filmfolio/services/auth_service.dart';
import 'package:filmfolio/ui/screens/filmfolio_app.dart';
import 'package:filmfolio/ui/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void _register(BuildContext context) async {
    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    try {
      final auth = AuthService();
      UserCredential userCredential = await auth.signUpWithEmailPassword(email, password);

      if (userCredential.user != null) {
        final UserController userController = UserController();
        await userController.createUser(userCredential.user!.uid, name, email);
        await userController.saveUserToLocalStorage(userCredential.user!.uid, name, email,"");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FilmfolioApp()),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: ((context) => AlertDialog(
          title: Text('Error'),
          content: Text(e.toString()),
        )),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Icon(
                  Icons.movie,
                  size: 80,
                  color: Colors.amber,
                ),
                SizedBox(height: 24),
                Text(
                  'Join FilmFolio',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                _buildTextField(_nameController, 'Name', Icons.person),
                SizedBox(height: 20),
                _buildTextField(_emailController, 'Email', Icons.email),
                SizedBox(height: 20),
                _buildTextField(_passwordController, 'Password', Icons.lock, isPassword: true),
                SizedBox(height: 20),
                _buildTextField(_confirmPasswordController, 'Confirm Password', Icons.lock, isPassword: true),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => _register(context),
                  child: Text('Register', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text(
                    'Already have an account? Login here',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amber),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amber, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: Icon(icon, color: Colors.amber),
      ),
    );
  }
}