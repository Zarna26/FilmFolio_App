import 'package:flutter/material.dart';

class ReleaseDatePicker extends StatelessWidget {
  final DateTime? releaseDate;
  final Function(DateTime) onDateSelected;

  const ReleaseDatePicker({
    Key? key,
    required this.releaseDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.amber,
      ),
      onPressed: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          onDateSelected(pickedDate);
        }
      },
      child: Text(
        releaseDate == null
            ? 'Select Release Date'
            : 'Release Date: ${releaseDate?.toLocal().toShortDateString()}',
        style: const TextStyle(color: Colors.amber),
      ),
    );
  }
}

extension DateTimeFormatting on DateTime {
  String toShortDateString() {
    return "${this.year}-${this.month.toString().padLeft(2, '0')}-${this.day.toString().padLeft(2, '0')}";
  }
}
