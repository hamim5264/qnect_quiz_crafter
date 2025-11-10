import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class QuizDetailsHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const QuizDetailsHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: 190,
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withValues(alpha: 0.7),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(100),
              bottomRight: Radius.circular(100),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 40, left: 24, right: 24),
          child: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                  fontSize: 20,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  color: Colors.white60,
                  fontSize: 13.5,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),

        Positioned(
          bottom: -38,
          child: CircleAvatar(
            radius: 42,
            backgroundColor: AppColors.chip3,
            child: Icon(icon, size: 42, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
