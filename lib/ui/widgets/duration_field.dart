import 'package:flutter/material.dart';

class DurationField extends StatelessWidget {
  final TextEditingController controller;

  const DurationField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Duration (minutes)',
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.amber),
        ),
      ),
      keyboardType: TextInputType.number,
      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
    );
  }
}
