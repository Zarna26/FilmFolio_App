import 'package:filmfolio/models/movie.dart';
import 'package:flutter/material.dart';

class MovieTitle extends StatelessWidget {
  final Movie movie;
  const MovieTitle({super.key,required this.movie});

  @override
  Widget build(BuildContext context) {
    return Text(
      movie.name,
      style: const TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
