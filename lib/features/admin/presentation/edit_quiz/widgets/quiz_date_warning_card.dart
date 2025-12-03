import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class QuizDateWarningCard extends StatelessWidget {
  final String courseStart;
  final String courseEnd;

  const QuizDateWarningCard({
    super.key,
    required this.courseStart,
    required this.courseEnd,
  });

  String formatDate(String date) {
    final d = DateTime.parse(date);
    return DateFormat('d MMMM yyyy').format(d);
    // Example: 1 December 2025
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_rounded, color: Colors.white, size: 20),
          const SizedBox(width: 8),

          // 🔥 Expanded FIXES overflow by allowing wrapping
          Expanded(
            child: Text(
              "Pick a date between ${formatDate(courseStart)} - ${formatDate(courseEnd)}",
              style: const TextStyle(
                fontFamily: AppTypography.family,
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
