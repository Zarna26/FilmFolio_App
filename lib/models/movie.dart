import 'package:filmfolio/models/award.dart';
import 'package:filmfolio/models/crew.dart';
import 'package:filmfolio/models/review.dart';
import 'package:filmfolio/models/season.dart';

class Movie {
  final String id;
  final String name;
  final String director;
  double? rating;
  List<Review>? reviews;
  final int? popularity;
  final bool isMovie;
  final String thumbnailUrl;
  final String trailer;
  final List<String> photos;
  final List<String> categories;
  final String storyline;
  final String language;
  final DateTime releaseDate;
  final int duration;
  final List<Crew> crew;
  final List<Award>? awards;
  final int? numberOfSeasons;
  final int? numberOfEpisodes;
  final List<Season>? seasons;

  Movie({
    required this.id,
    required this.name,
    required this.director,
    rating,
    reviews,
    popularity,
    required this.isMovie,
    required this.thumbnailUrl,
    required this.trailer,
    required this.photos,
    required this.categories,
    required this.storyline,
    required this.language,
    required this.releaseDate,
    required this.duration,
    required this.crew,
    this.awards,
    this.numberOfSeasons,
    this.numberOfEpisodes,
    this.seasons,
  })  : rating = rating ?? 0.0,
        popularity = popularity ?? 0,
        reviews = reviews ?? [];

  void addReview(Review review) {
    reviews ??= [];
    reviews!.add(review);
  }

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['_id'],
      name: json['name'] ?? '',
      director: json['director'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      reviews: (json['reviews'] as List?)
          ?.map((i) => Review.fromJson(i as Map<String, dynamic>))
          .toList() ?? [],
      popularity: json['popularity'] ?? 0,
      isMovie: json['isMovie'] ?? false,
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      trailer: json['trailer'] ?? '',
      photos: List<String>.from(json['photos'] ?? []),
      categories: List<String>.from(json['categories'] ?? []),
      storyline: json['storyline'] ?? '',
      language: json['language'] ?? '',
      releaseDate: json['releaseDate'] != null
          ? DateTime.parse(json['releaseDate'])
          : DateTime.now(),
      duration: json['duration'] ?? 0,
      crew: (json['crew'] as List?)?.map((i) => Crew.fromJson(i)).toList() ?? [],
      awards: json['awards'] != null
          ? (json['awards'] as List).map((i) => Award.fromJson(i)).toList()
          : null,
      numberOfSeasons: json['numberOfSeasons'],
      numberOfEpisodes: json['numberOfEpisodes'],
      seasons: json['seasons'] != null
          ? (json['seasons'] as List)
          .map((i) => Season.fromJson(i as Map<String, dynamic>))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'director': director,
      'rating': rating,
      'reviews': reviews?.map((i) => i.toJson()).toList(),
      'popularity': popularity,
      'isMovie': isMovie,
      'thumbnailUrl': thumbnailUrl,
      'trailer': trailer,
      'photos': photos,
      'categories': categories,
      'storyline': storyline,
      'language': language,
      'releaseDate': releaseDate.toIso8601String(),
      'duration': duration,
      'crew': crew.map((i) => i.toJson()).toList(),
      'awards': awards?.map((i) => i.toJson()).toList(),
      'numberOfSeasons': numberOfSeasons,
      'numberOfEpisodes': numberOfEpisodes,
      'seasons': seasons?.map((i) => i.toJson()).toList(),
    };
  }
}
