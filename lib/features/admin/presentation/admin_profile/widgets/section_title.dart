import 'package:flutter/material.dart';
import '../../../../../../ui/design_system/tokens/typography.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: AppTypography.family,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 15,
      ),
    );
  }
}
