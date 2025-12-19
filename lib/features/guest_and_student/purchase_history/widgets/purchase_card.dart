import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../ui/design_system/tokens/colors.dart';
import '../../../../ui/design_system/tokens/typography.dart';

class PurchaseCard extends StatelessWidget {
  final String title;
  final String courseId;
  final int amount;
  final String status;
  final dynamic date;
  final VoidCallback onDelete;

  const PurchaseCard({
    super.key,
    required this.title,
    required this.courseId,
    required this.amount,
    required this.status,
    required this.date,
    required this.onDelete,
  });

  Color _statusColor() {
    switch (status.toLowerCase()) {
      case "success":
      case "completed":
        return Colors.green;
      case "refunded":
        return Colors.orange;
      case "cancelled":
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  String _formattedDate() {
    if (date is Timestamp) {
      return DateFormat("d MMM yyyy").format(date.toDate());
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: AppColors.chip3,
                  size: 32,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: AppTypography.family,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "#$courseId",
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                        fontFamily: AppTypography.family,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "$amount BDT",
                      style: const TextStyle(
                        color: AppColors.secondaryDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: AppTypography.family,
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                children: [
                  GestureDetector(
                    onTap: onDelete,
                    child: const Icon(
                      CupertinoIcons.trash,
                      color: Colors.redAccent,
                      size: 26,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        color: Colors.white70,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _formattedDate(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: AppTypography.family,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        Positioned(
          top: 0,
          right: 0,
          child: Transform.rotate(
            angle: 0.75,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _statusColor(),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                status[0].toUpperCase() + status.substring(1),
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                  fontFamily: AppTypography.family,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
