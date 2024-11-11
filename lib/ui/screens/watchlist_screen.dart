import 'package:filmfolio/controllers/user_controller.dart';
import 'package:filmfolio/models/movie.dart';
import 'package:filmfolio/ui/screens/movie_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  List<Movie> movies = [];
  final UserController _userController = UserController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserContent();
  }

  Future<void> fetchUserContent() async {
    try {
      final fetchedMovies = await _userController.fetchUserShows();
      setState(() {
        movies = fetchedMovies;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching watchlist: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Watchlist'),
        backgroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black87, Colors.black54],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.amber))
            : movies.isEmpty
            ? const Center(
          child: Text(
            'Your watchlist is empty',
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
        )
            : ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0, // Adjusted vertical padding
                horizontal: 16.0,
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Colors.grey[900],
                elevation: 6, // Reduced elevation
                shadowColor: Colors.amber.withOpacity(0.3),
                child: Padding(
                  padding: const EdgeInsets.all(12.0), // Reduced inner padding
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Movie Thumbnail with rounded corners
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          movie.thumbnailUrl,
                          width: 90, // Adjusted width
                          height: 100, // Adjusted height
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: 90,
                                height: 100,
                                color: Colors.grey[300],
                                child: const Icon(Icons.movie,
                                    size: 40, color: Colors.grey),
                              ),
                        ),
                      ),
                      const SizedBox(width: 12), // Adjusted spacing
                      // Movie Information
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Movie Title
                            Text(
                              movie.name,
                              style: const TextStyle(
                                color: Colors.amber,
                                fontSize: 20, // Slightly reduced font size
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Movie Release Date
                            Text(
                              DateFormat.yMMMd().format(movie.releaseDate),
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16, // Slightly reduced font size
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // 'View Details' Button
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MovieDetailScreen(movie: movie),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0), // Adjusted padding
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: const Text(
                                'View Details',
                                style: TextStyle(color: Colors.black, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton<String>(
                        onSelected: (value) async {
                          await _userController.removeFromWatchlist(movie.id);
                          await fetchUserContent();
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'remove',
                            child: Text(
                              'Remove',
                              style: TextStyle(color: Colors.amber, fontSize: 20),
                            ),
                          ),
                        ],
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.amber,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}