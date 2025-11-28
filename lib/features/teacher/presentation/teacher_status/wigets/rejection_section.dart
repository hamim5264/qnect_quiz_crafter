import 'package:flutter/material.dart';

import '../../../../../ui/design_system/tokens/typography.dart';
import '../model/teacher_status_state.dart';

class RejectionSection extends StatelessWidget {
  final TeacherStatusState state;

  const RejectionSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final name = state.name ?? "Teacher";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          state.rejectionTitle ?? "Request Rejected",
          style: const TextStyle(
            fontFamily: AppTypography.family,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.redAccent,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          state.rejectionMessage ??
              "Hello $name, unfortunately your teacher account request was rejected. Please review the feedback below and try again if possible.",
          style: const TextStyle(
            fontFamily: AppTypography.family,
            fontSize: 13,
            color: Colors.white70,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 14),

        if (state.feedback.isNotEmpty) ...[
          const Text(
            "Feedback from Admin:",
            style: TextStyle(
              fontFamily: AppTypography.family,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          ...state.feedback.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                "• $f",
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  fontSize: 13,
                  color: Colors.white60,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
