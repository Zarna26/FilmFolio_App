import 'package:filmfolio/controllers/user_controller.dart';
import 'package:filmfolio/models/movie.dart';
import 'package:filmfolio/models/user.dart';
import 'package:filmfolio/ui/screens/movie_detail_screen.dart';
import 'package:flutter/material.dart';

class MovieList extends StatefulWidget {
  final List<Movie> movies;

  const MovieList({Key? key, required this.movies}) : super(key: key);

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  final UserController _userController = UserController();
  Set<String> addedToWatchlist = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserWatchList();
  }

  void fetchUserWatchList() async {
    List<String> userwatchlist = await _userController.getWatchlist();
    addedToWatchlist.addAll(userwatchlist);
  }

  void _addToWatchlist(String movieId) async {
    await _userController.addToWatchlist(movieId);
    setState(() {
      addedToWatchlist.add(movieId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Movie added to watchlist'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            _userController.removeFromWatchlist(movieId);
            setState(() {
              addedToWatchlist.remove(movieId);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.movies.length,
        itemBuilder: (context, index) {
          final movie = widget.movies[index];

          return Container(
            width: 130,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetailScreen(movie: movie),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: movie.thumbnailUrl != null
                        ? Image.network(
                            movie.thumbnailUrl!,
                            fit: BoxFit.cover,
                            width: 130,
                            height: 150,
                          )
                        : Container(
                            color: Colors.grey[800],
                            width: 130,
                            height: 150,
                            child: const Center(
                              child: Icon(
                                Icons.movie_creation_outlined,
                                size: 40,
                                color: Colors.white54,
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    movie.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${movie.rating?.toStringAsFixed(1) ?? "N/A"}',
                        style: const TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => _addToWatchlist(movie.id),
                        child: Icon(
                          addedToWatchlist.contains(movie.id)
                              ? Icons.check
                              : Icons.add,
                          color: addedToWatchlist.contains(movie.id)
                              ? Colors.green
                              : Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
