import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filmfolio/controllers/content_controller.dart';
import 'package:filmfolio/models/movie.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class UserController {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  User? _currentUser;

  User? get currentUser => _currentUser;

  Future<User> createUser(String id, String name, String email) async {
    _currentUser = User(
      id: id,
      name: name,
      email: email,
      profileUrl: "",
    );
    await _usersCollection.doc(_currentUser!.id).set(_currentUser!.toJson());
    await saveUserToLocalStorage(id, name, email, "");
    return _currentUser!;
  }

  Future<User?> getUser(String email) async {
    final querySnapshot =
        await _usersCollection.where('email', isEqualTo: email).limit(1).get();

    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;
      _currentUser = User.fromJson(doc.data() as Map<String, dynamic>);
      await saveUserToLocalStorage(
        _currentUser!.id!,
        _currentUser!.name,
        _currentUser!.email,
        _currentUser!.profileUrl,
      );
      return _currentUser;
    }
    _currentUser = null;
    return null;
  }

  Future<void> updateUser(String name, String email, String profileUrl) async {
    if (_currentUser != null) {
      _currentUser = User(
        id: _currentUser!.id,
        name: name,
        email: email,
        profileUrl: profileUrl,
      );
      await _usersCollection
          .doc(_currentUser!.id)
          .update(_currentUser!.toJson());
      await saveUserToLocalStorage(_currentUser!.id!, name, email, profileUrl);
    }
  }

  Future<void> deleteUser() async {
    if (_currentUser != null) {
      await _usersCollection.doc(_currentUser!.id).delete();
      _currentUser = null;
      await clearUserFromLocalStorage();
    }
  }

  Future<List<User>> getAllUsers() async {
    final querySnapshot = await _usersCollection.get();
    return querySnapshot.docs
        .map((doc) => User.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveUserToLocalStorage(
      String id, String name, String email, String profileUrl) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', id);
    await prefs.setString('user_name', name);
    await prefs.setString('user_email', email);
    await prefs.setString('user_profile', profileUrl);
    _currentUser =
        User(id: id, name: name, email: email, profileUrl: profileUrl);
  }

  Future<User?> loadUserFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('user_id');
    final name = prefs.getString('user_name');
    final email = prefs.getString('user_email');
    final profileUrl = prefs.getString('user_profile');

    if (id != null && name != null && email != null && profileUrl != null) {
      _currentUser =
          User(id: id, name: name, email: email, profileUrl: profileUrl);
      await getUser(email);
    }
    return _currentUser;
  }

  Future<void> clearUserFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  bool isUserLoggedIn() {
    return _currentUser != null;
  }

  Future<void> addToWatchlist(String showId) async {
    if (!isUserLoggedIn()) {
      await loadUserFromLocalStorage();
      if (!isUserLoggedIn()) {
        throw Exception('No user is currently logged in');
      }
    }

    final userId = _currentUser!.id;
    if (userId == null || userId.isEmpty) {
      throw Exception('Current user has no valid ID');
    }

    if (_currentUser!.watchlist.contains(showId)) return;

    try {
      _currentUser!.watchlist.add(showId);
      await _usersCollection.doc(userId).update({
        'watchlist': FieldValue.arrayUnion([showId])
      });
    } catch (e) {
      _currentUser!.watchlist.remove(showId);
      throw Exception('Failed to add show to watchlist: $e');
    }
  }

  Future<void> removeFromWatchlist(String showId) async {
    if (!isUserLoggedIn()) {
      await loadUserFromLocalStorage();
      if (!isUserLoggedIn()) {
        throw Exception('No user is currently logged in');
      }
    }

    final userId = _currentUser!.id;
    if (userId == null || userId.isEmpty) {
      throw Exception('Current user has no valid ID');
    }

    try {
      _currentUser!.watchlist.remove(showId);
      await _usersCollection.doc(userId).update({
        'watchlist': FieldValue.arrayRemove([showId])
      });
    } catch (e) {
      print('Error removing show from watchlist: $e');
    }
  }

  Future<List<Movie>> fetchUserShows() async {
    final firebaseAuth.FirebaseAuth _auth = firebaseAuth.FirebaseAuth.instance;
    final ContentController _contentController = ContentController();
    List<Movie> movies = [];

    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser == null) {
        throw Exception('No user is currently logged in');
      }

      final userDoc = await _usersCollection.doc(firebaseUser.uid).get();

      if (!userDoc.exists) {
        throw Exception('User document not found in Firestore');
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final watchlist = List<String>.from(userData['watchlist'] ?? []);

      print('User watchlist: $watchlist');

      for (final id in watchlist) {
        try {
          final movie = await _contentController.getMovieById(id);
          if (movie != null) {
            movies.add(movie);
          } else {
            print('Movie with id $id not found');
          }
        } catch (e) {
          print('Error fetching movie with id $id: $e');
        }
      }
    } catch (e) {
      print('Error fetching user shows: $e');
      rethrow;
    }

    print('Fetched movies: $movies');
    return movies;
  }

  Future<List<String>> getWatchlist() async {
    final firebaseAuth.FirebaseAuth _auth = firebaseAuth.FirebaseAuth.instance;
    List<String> watchlist = [];
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser == null) {
        throw Exception('No user is currently logged in');
      }

      final userDoc = await _usersCollection.doc(firebaseUser.uid).get();

      if (!userDoc.exists) {
        throw Exception('User document not found in Firestore');
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      watchlist = List<String>.from(userData['watchlist'] ?? []);
    } catch (e) {
      print('Error fetching user shows: $e');
      rethrow;
    }
    return watchlist;
  }
}
