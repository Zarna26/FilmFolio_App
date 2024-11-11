import 'package:filmfolio/models/award.dart';
import 'package:flutter/material.dart';

class AwardsSection extends StatelessWidget {
  final List<Award> allAwards;
  final List<Award> selectedAwards;
  final Function(Award, bool) onAwardSelected;

  const AwardsSection({
    Key? key,
    required this.allAwards,
    required this.selectedAwards,
    required this.onAwardSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Awards (Optional):',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 8.0),
        Wrap(
          spacing: 8,
          children: allAwards.map((award) => FilterChip(
            label: Text(
              '${award.category}: ${award.name}',
              style: TextStyle(
                color: selectedAwards.contains(award)
                    ? Colors.black
                    : Colors.white,
              ),
            ),
            selected: selectedAwards.contains(award),
            selectedColor: Colors.amber,
            backgroundColor: Colors.black,
            checkmarkColor: Colors.black,
            onSelected: (selected) => onAwardSelected(award, selected),
          )).toList(),
        ),
      ],
    );
  }
}
