import 'package:flutter/material.dart';

class StorylineAndLanguageFields extends StatelessWidget {
  final TextEditingController storylineController;
  final TextEditingController languageController;

  const StorylineAndLanguageFields({
    Key? key,
    required this.storylineController,
    required this.languageController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: storylineController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Storyline',
            labelStyle: const TextStyle(color: Colors.white),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.amber),
            ),
          ),
          maxLines: 3,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: languageController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Language',
            labelStyle: const TextStyle(color: Colors.white),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.amber),
            ),
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
      ],
    );
  }
}
