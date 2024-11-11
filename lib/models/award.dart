class Award {
  final String name;
  final int year;
  final String category;

  Award({required this.name, required this.year, required this.category});

  factory Award.fromJson(Map<String, dynamic> json) {
    return Award(
      name: json['name'],
      year: json['year'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'year': year,
      'category': category,
    };
  }

  @override
  String toString() {
    return 'Award(name: $name, year: $year, category: $category)';
  }

}
