import 'package:filmfolio/models/movie.dart';
import 'package:flutter/material.dart';

class SeasonInfo extends StatelessWidget {
  final Movie movie;
  const SeasonInfo({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    if (movie.seasons == null || movie.seasons!.isEmpty)
      return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Seasons:',
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8.0),
        ...movie.seasons!.map((season) => Text(
              'Season ${season.seasonNumber}: ${season.episodes.length} episodes',
              style: const TextStyle(fontSize: 14.0, color: Colors.white70),
            )),
        const SizedBox(height: 24.0),
      ],
    );
  }
}
