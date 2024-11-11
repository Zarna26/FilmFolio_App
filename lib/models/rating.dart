class Rating {
  final String id;
  final String contentId;
  final double rating;
  final String comment;
  final DateTime date;

  Rating({
    required this.id,
    required this.contentId,
    required this.rating,
    required this.comment,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'contentId': contentId,
    'rating': rating,
    'comment': comment,
    'date': date.toIso8601String(),
  };
}