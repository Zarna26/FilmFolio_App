import 'package:filmfolio/models/episode.dart';

class Season {
  final int seasonNumber;
  final String seasonTrailer;
  final int numberOfEpisodes;
  final DateTime releaseDate;
  final List<Episode> episodes;

  Season({
    required this.seasonNumber,
    required this.seasonTrailer,
    required this.numberOfEpisodes,
    required this.releaseDate,
    required this.episodes,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      seasonNumber: json['seasonNumber'],
      seasonTrailer: json['seasonTrailer'],
      numberOfEpisodes: json['numberOfEpisodes'],
      releaseDate: DateTime.parse(json['releaseDate']),
      episodes: (json['episodes'] as List)
          .map((e) => Episode.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seasonNumber': seasonNumber,
      'seasonTrailer': seasonTrailer,
      'numberOfEpisodes': numberOfEpisodes,
      'releaseDate': releaseDate.toIso8601String(),
      'episodes': episodes.map((e) => e.toJson()).toList(),
    };
  }
}
