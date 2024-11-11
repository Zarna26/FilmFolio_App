class WatchlistItem {
  final String? id;
  final String contentId;
  final DateTime dateAdded;

  WatchlistItem({
    required this.id,
    required this.contentId,
  }): dateAdded = DateTime.timestamp();

  Map<String, dynamic> toJson() => {
    'id': id,
    'contentId': contentId,
    'dateAdded': dateAdded.toLocal(),
  };
}