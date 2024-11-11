class Crew {
  final String name;
  final String imageUrl;

  Crew({required this.name, required this.imageUrl});

  factory Crew.fromJson(Map<String, dynamic> json) {
    return Crew(
      name: json['name'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  @override
  String toString() {
    return 'Crew(name: $name, imageUrl: $imageUrl)';
  }

}
