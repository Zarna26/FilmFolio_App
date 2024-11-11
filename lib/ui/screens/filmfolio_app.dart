import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'home_screen.dart';
import 'category_screen.dart';
import 'watchlist_screen.dart';
import 'user_account_screen.dart';

class FilmfolioApp extends StatefulWidget {
  const FilmfolioApp({super.key});

  @override
  _FilmfolioAppState createState() => _FilmfolioAppState();
}

class _FilmfolioAppState extends State<FilmfolioApp> {
  final LocalAuthentication _auth = LocalAuthentication();
  bool _isAuthenticated = false;
  bool _isLoading = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    await _authenticateUser();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _authenticateUser() async {
    try {
      bool isBiometricAvailable = await _auth.canCheckBiometrics;
      bool didAuthenticate = false;

      if (isBiometricAvailable) {
        didAuthenticate = await _auth.authenticate(
          localizedReason: 'Please authenticate to access the app',
          options: const AuthenticationOptions(biometricOnly: true),
        );
      } else {
        didAuthenticate = true;
      }

      setState(() {
        _isAuthenticated = didAuthenticate;
      });
    } catch (e) {
      print("Authentication error: $e");
    }
  }

  void _navigateBottomBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _pages = [
    const HomeScreen(),
    const WatchlistScreen(),
    const CategoryScreen(),
    const AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_isAuthenticated) {
      return Scaffold(
        body: Center(
          child: AlertDialog(
            title: const Text('Authentication Required'),
            content: const Text('Please authenticate to proceed.'),
            actions: [
              TextButton(
                onPressed: () {
                  _authenticateUser();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _navigateBottomBar,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.watch_later),
            label: "Watchlist",
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: "Category",
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Account",
            backgroundColor: Colors.black,
          ),
        ],
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey[600],
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(color: Colors.grey),
        showUnselectedLabels: true,
        backgroundColor: Colors.black,
      ),
    );
  }
}
