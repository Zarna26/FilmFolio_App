import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filmfolio/models/review.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:filmfolio/models/movie.dart';

class ContentController {
  List<Movie> movies = [];
  final CollectionReference _movieCollection =
  FirebaseFirestore.instance.collection("contents");

  Future<Movie> addMovie(Movie movie) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User is not authenticated');
    }

    try {
      await _movieCollection.doc(movie.id).set(movie.toJson());
      movies.add(movie);
      return movie;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeMovie(String id) async {
    await _movieCollection.doc(id).delete();
    movies.removeWhere((movie) => movie.id == id);
  }

  Future<Movie?> getMovieById(String id) async {
    try {
      DocumentSnapshot doc = await _movieCollection.doc(id).get();

      if (doc.exists) {
        final data = doc.data();
        if (data != null && data is Map<String, dynamic>) {
          return Movie.fromJson(data);
        } else {
          print("Document data was null or not a Map");
          return null;
        }
      } else {
        print("No document found with id: $id");
        return null;
      }
    } catch (e) {
      print("Error retrieving movie: $e");
      return null;
    }
  }

  Future<void> updateMovie(String id, Map<String, dynamic> updatedMovieJson) async {
    final updatedMovie = Movie.fromJson(updatedMovieJson);
    await _movieCollection.doc(id).update(updatedMovie.toJson());
    int index = movies.indexWhere((movie) => movie.id == id);
    if (index != -1) {
      movies[index] = updatedMovie;
    }
  }

  Future<List<Movie>> getAllMovies() async {
    QuerySnapshot snapshot = await _movieCollection.get();
    movies = snapshot.docs
        .map((doc) => Movie.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    return movies;
  }

  Future<void> addReviewToShow(Review review, double rate) async {
    await getAllMovies();
    Movie? movie = movies.firstWhere(
          (m) => m.id == review.contentId,
    );

    if (movie != null) {
      final existingReviewIndex = movie.reviews?.indexWhere((r) => r.username == review.username);

      if (existingReviewIndex != -1) {
        movie.reviews!.removeAt(existingReviewIndex!);
      }
      print(review.username);
      movie.rating = (movie.rating! + rate)/(movie.reviews!.length + 1);
      movie.addReview(review);
      await updateMovie(movie.id, movie.toJson());

    }
  }
}
