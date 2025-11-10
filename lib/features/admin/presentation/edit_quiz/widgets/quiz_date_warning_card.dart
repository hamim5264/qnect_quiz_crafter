import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class QuizDateWarningCard extends StatelessWidget {
  final String courseStart;
  final String courseEnd;

  const QuizDateWarningCard({
    super.key,
    required this.courseStart,
    required this.courseEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.warning_rounded, color: Colors.white, size: 20),
          const SizedBox(width: 6),
          Text(
            "Pick date between $courseStart - $courseEnd",
            style: const TextStyle(
              fontFamily: AppTypography.family,
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
