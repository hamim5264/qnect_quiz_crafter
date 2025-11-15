import 'package:flutter/material.dart';
import 'hint_chip.dart';

class HintSection extends StatelessWidget {
  const HintSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: const [
        HintChip(text: "Psychology"),
        HintChip(text: "Motion"),
        HintChip(text: "Calculus"),
      ],
    );
  }
}
