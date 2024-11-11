class Episode {
  final int episodeNumber;
  final String title;
  final int duration;
  final DateTime airDate;

  Episode({
    required this.episodeNumber,
    required this.title,
    required this.duration,
    required this.airDate,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      episodeNumber: json['episodeNumber'],
      title: json['title'],
      duration: json['duration'],
      airDate: DateTime.parse(json['airDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'episodeNumber': episodeNumber,
      'title': title,
      'duration': duration,
      'airDate': airDate.toIso8601String(),
    };
  }
}
