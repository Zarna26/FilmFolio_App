import 'package:filmfolio/models/movie.dart';
import 'package:flutter/material.dart';

class MovieInfo extends StatelessWidget {
  final Movie movie;

  const MovieInfo({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Director: ${movie.director}',
            style: const TextStyle(fontSize: 16.0, color: Colors.white70),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Type: ${movie.isMovie ? "Movie" : "Series"}',
            style: const TextStyle(fontSize: 16.0, color: Colors.white70),
          ),
        ),
        Text(
          'Rating: ${movie.rating}/10',
          style: const TextStyle(
            fontSize: 16.0,
            color: Colors.amber,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16.0),
        Text(
          movie.storyline,
          style: const TextStyle(fontSize: 14.0, color: Colors.white70),
        ),
        const SizedBox(height: 24.0),
        _buildAwardsSection(),
        const SizedBox(height: 16.0),
        _buildCrewSection(),
      ],
    );
  }

  Widget _buildAwardsSection() {
    if (movie.awards == null || movie.awards!.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildSection(
      title: 'Awards',
      items: movie.awards!.map((award) => award.name).toList(),
    );
  }

  Widget _buildCrewSection() {
    if (movie.crew.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildSection(
      title: 'Crew',
      items: movie.crew.map((crewMember) => crewMember.name).toList(),
    );
  }

  Widget _buildSection({required String title, required List<String> items}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 8.0),
          ...items.map((item) => _buildItemCard(item)).toList(),
        ],
      ),
    );
  }

  Widget _buildItemCard(String itemName) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber),
      ),
      child: Text(
        itemName,
        style: const TextStyle(
          fontSize: 14.0,
          color: Colors.white70,
        ),
      ),
    );
  }
}
