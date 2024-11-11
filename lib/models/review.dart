class Review {
  String id;
  String username;
  String reviewText;
  String contentId;
  DateTime date;

  Review({
    required this.id,
    required this.username,
    required this.reviewText,
    required this.contentId,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'reviewText': reviewText,
    'contentId': contentId,
    'date': date.toIso8601String(),
  };

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      reviewText: json['reviewText'] ?? '',
      contentId: json['contentId'] ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
    );
  }
}
