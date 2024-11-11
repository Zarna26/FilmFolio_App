import 'package:flutter/material.dart';

class BasicInfoFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController directorController;
  final bool isMovie;
  final ValueChanged<bool> onIsMovieChanged;

  const BasicInfoFields({
    Key? key,
    required this.nameController,
    required this.directorController,
    required this.isMovie,
    required this.onIsMovieChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: nameController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Name',
            labelStyle: const TextStyle(color: Colors.white),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.amber),
            ),
            hoverColor: Colors.amber,
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: directorController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Director',
            labelStyle: const TextStyle(color: Colors.white),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.amber),
            ),
            hoverColor: Colors.amber,
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 16.0),
        Row(
          children: [
            const Text('Is Movie:', style: TextStyle(color: Colors.white)),
            Switch(
              value: isMovie,
              onChanged: onIsMovieChanged,
              activeColor: Colors.amber,
              inactiveTrackColor: Colors.white,
            ),
          ],
        ),
      ],
    );
  }
}
