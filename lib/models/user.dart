class User {
  final String id;
  final String name;
  final String email;
  List<String> watchlist;
  String profileUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.profileUrl,
  }) : watchlist = [];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'watchlist': watchlist,
    'profileUrl': profileUrl,
  };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profileUrl: json['profileUrl'],
    )..watchlist = List<String>.from(json['watchlist'] ?? []);
  }
}