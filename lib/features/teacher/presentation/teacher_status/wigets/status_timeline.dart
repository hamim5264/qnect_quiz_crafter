import 'package:flutter/material.dart';
import 'package:qnect_quiz_crafter/ui/design_system/tokens/colors.dart';

import '../../../../../ui/design_system/tokens/typography.dart';

class StatusTimeline extends StatelessWidget {
  final String status;

  const StatusTimeline({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final bool isApproved = status == "approved";
    final bool isPending = status == "pending";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StatusStep(
          index: 1,
          title: "Account Created",
          subtitle: "Your teacher profile is created",
          active: true,
        ),
        _VerticalLine(),
        _StatusStep(
          index: 2,
          title: "Under Review",
          subtitle: "Our team is reviewing your request",
          active: isPending || isApproved,
        ),
        _VerticalLine(),
        _StatusStep(
          index: 3,
          title: "Approved",
          subtitle: "You can access teacher dashboard",
          active: isApproved,
        ),
      ],
    );
  }
}

class _StatusStep extends StatelessWidget {
  final int index;
  final String title;
  final String subtitle;
  final bool active;

  const _StatusStep({
    required this.index,
    required this.title,
    required this.subtitle,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? AppColors.secondaryDark : Colors.white10,
            border: Border.all(
              color: active ? Colors.white : Colors.white38,
              width: 1.2,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            "$index",
            style: TextStyle(
              fontFamily: AppTypography.family,
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: active ? Colors.black : Colors.white54,
            ),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: AppTypography.family,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: active ? Colors.white : Colors.white60,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  fontSize: 12,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _VerticalLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16,
      margin: const EdgeInsets.only(left: 12),
      width: 1.5,
      color: Colors.white24,
    );
  }
}
