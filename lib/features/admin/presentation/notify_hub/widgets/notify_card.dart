import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class NotifyCard extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final String audience;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const NotifyCard({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.audience,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.5,
                    color: AppColors.chip1,
                  ),
                ),
              ),
              IconButton(
                onPressed: onEdit,
                icon: const Icon(
                  LucideIcons.edit3,
                  size: 18,
                  color: AppColors.chip2,
                ),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(
                  CupertinoIcons.trash,
                  size: 18,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            description,
            style: const TextStyle(
              fontFamily: AppTypography.family,
              color: Colors.black54,
              fontSize: 13.5,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Delivered at: $date",
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  fontSize: 12,
                  color: Colors.black45,
                ),
              ),
              _AudienceChip(text: audience),
            ],
          ),
        ],
      ),
    );
  }
}

class _AudienceChip extends StatelessWidget {
  final String text;

  const _AudienceChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: AppTypography.family,
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
