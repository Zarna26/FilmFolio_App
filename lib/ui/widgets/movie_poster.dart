import 'package:filmfolio/models/movie.dart';
import 'package:flutter/material.dart';

class MoviePoster extends StatelessWidget {
  final Movie movie;
  const MoviePoster({super.key,required this.movie});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.network(
        movie.thumbnailUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 250.0,
        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: double.infinity,
            height: 250.0,
            color: Colors.grey,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: 250.0,
            color: Colors.grey,
            child: const Center(child: Text('Image not available')),
          );
        },
      ),
    );
  }
}
