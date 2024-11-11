import 'package:flutter/material.dart';

class CategorySection extends StatelessWidget {
  final List<String> allCategories;
  final List<String> selectedCategories;
  final Function(String, bool) onCategorySelected;

  const CategorySection({
    Key? key,
    required this.allCategories,
    required this.selectedCategories,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories:',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 8.0),
        Wrap(
          spacing: 8,
          children: allCategories.map((category) => FilterChip(
            label: Text(
              category,
              style: TextStyle(
                color: selectedCategories.contains(category)
                    ? Colors.black
                    : Colors.white,
              ),
            ),
            selected: selectedCategories.contains(category),
            selectedColor: Colors.amber,
            backgroundColor: Colors.black,
            checkmarkColor: Colors.black,
            onSelected: (selected) => onCategorySelected(category, selected),
          )).toList(),
        ),
      ],
    );
  }
}
