import 'package:filmfolio/controllers/content_controller.dart';
import 'package:filmfolio/controllers/user_controller.dart';
import 'package:filmfolio/models/movie.dart';
import 'package:filmfolio/models/review.dart';
import 'package:filmfolio/models/user.dart';
import 'package:filmfolio/ui/screens/home_screen.dart';
import 'package:filmfolio/ui/widgets/content_player.dart';
import 'package:filmfolio/ui/widgets/movie_info.dart';
import 'package:filmfolio/ui/widgets/movie_poster.dart';
import 'package:filmfolio/ui/widgets/movie_title.dart';
import 'package:filmfolio/ui/widgets/secsons_info.dart';
import 'package:flutter/material.dart';


class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(),
      floatingActionButton: _buildReviewButton(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        widget.movie.name,
        style: const TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.black,
      elevation: 4.0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.amber),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MoviePoster(movie: widget.movie),
          const SizedBox(height: 16.0),
          MovieTitle(movie: widget.movie),
          const SizedBox(height: 8.0),
          MovieInfo(movie: widget.movie),
          const SizedBox(height: 24.0),
          SeasonInfo(movie: widget.movie),
          const SizedBox(height: 10),
          ContentPlayer(movie: widget.movie),
          const SizedBox(height: 16.0),
          _buildReviewsSection(),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    if (widget.movie.reviews!.isEmpty) {
      return const Center(
        child: Text(
          'No reviews available',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reviews',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8.0),
        ...widget.movie.reviews!.map((review) => _buildReviewItem(review)).toList(),
      ],
    );
  }

  Widget _buildReviewItem(Review review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.amber),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Avatar
          CircleAvatar(
            backgroundColor: Colors.amber,
            child: Text(
              review.username.isNotEmpty ? review.username[0].toUpperCase() : '?',
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Review Text
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    review.reviewText,
                    style: const TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ),
                // Username
                Text(
                  review.username,
                  style: const TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildReviewButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        _showReviewForm(context);
        setState(() {});
      },
      child: const Icon(Icons.add_comment, color: Colors.white),
      backgroundColor: Colors.amber,
    );
  }

  void _showReviewForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: _ReviewForm(movie: widget.movie),
        );
      },
    );
  }
}

class _ReviewForm extends StatefulWidget {
  final Movie movie;

  const _ReviewForm({required this.movie});

  @override
  _ReviewFormState createState() => _ReviewFormState();
}

class _ReviewFormState extends State<_ReviewForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _reviewController = TextEditingController();
  final UserController _userController = UserController();
  final ContentController _contentController = ContentController();
  User? user;
  double _rating = 5.0;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Submit a Review',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _reviewController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Review',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber),
                ),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your review';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Rating Slider
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rating (out of 10)',
                  style: TextStyle(color: Colors.white),
                ),
                Slider(
                  value: _rating,
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: _rating.round().toString(),
                  activeColor: Colors.amber,
                  inactiveColor: Colors.white,
                  onChanged: (value) {
                    setState(() {
                      _rating = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _submitReview(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitReview(BuildContext context) async {
    user = await _userController.loadUserFromLocalStorage();
    final newReview = Review(
      id: DateTime.now().toString(),
      username: user?.name ?? "",
      reviewText: _reviewController.text,
      contentId: widget.movie.id,
    );
    await _contentController.addReviewToShow(newReview,_rating);
    setState(() {
      widget.movie.reviews!.add(newReview);
    });
    Navigator.pop(context);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }
}
