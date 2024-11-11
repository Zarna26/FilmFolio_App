import 'package:flutter/material.dart';
import '../../models/crew.dart';

class CrewSection extends StatelessWidget {
  final List<String> selectedCrew;
  final List<Crew> crewList;
  final Function(String, bool) onCrewSelected;

  CrewSection({
    Key? key,
    required this.selectedCrew,
    required this.crewList,
    required this.onCrewSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> allCrew = crewList.map((crew) => crew.name).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Crew:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Wrap(
          spacing: 8,
          children: allCrew.map((member) {
            return FilterChip(
              label: Text(
                member,
                style: TextStyle(
                  color: selectedCrew.contains(member)
                      ? Colors.black
                      : Colors.white,
                ),
              ),
              selected: selectedCrew.contains(member),
              selectedColor: Colors.amber,
              backgroundColor: Colors.black,
              checkmarkColor: Colors.black,
              onSelected: (selected) => onCrewSelected(member, selected),
            );
          }).toList(),
        ),
      ],
    );
  }
}
