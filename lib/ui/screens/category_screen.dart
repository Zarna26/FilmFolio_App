import 'package:filmfolio/controllers/content_controller.dart';
import 'package:filmfolio/models/movie.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final ContentController _contentController = ContentController();
  final List<String> _categories = [
    "Anime",
    "Horror",
    "Romantic",
    "Science-fiction",
    "Action",
    "Comedy",
    "Documentary",
    "Drama",
    "Fantasy",
    "Mystery",
    "Thriller",
  ];

  List<Movie> _movies = [];
  List<Movie> _categoryWiseMovies = [];
  int? _selectedCategoryIndex;

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  void fetchMovies() async {
    _movies = await _contentController.getAllMovies();
    setState(() {});
  }

  void _filterMoviesByCategory(String category) {
    _categoryWiseMovies = _movies
        .where((movie) => movie.categories.contains(category))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Categories",
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                title: Text(
                  _categories[index],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_circle_right_outlined,
                  color: Colors.amber,
                ),
                onTap: () {
                  setState(() {
                    if (_selectedCategoryIndex == index) {
                      _selectedCategoryIndex = null;
                    } else {
                      _selectedCategoryIndex = index;
                      _filterMoviesByCategory(_categories[index]);
                    }
                  });
                },
              ),
              if (_selectedCategoryIndex == index)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categoryWiseMovies.map((movie) {
                      return Container(
                        width: 150,
                        margin: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              movie.thumbnailUrl,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              movie.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ],
          );
        },
        padding: const EdgeInsets.all(8.0),
        shrinkWrap: true,
      ),
      backgroundColor: Colors.black87,
    );
  }
}
