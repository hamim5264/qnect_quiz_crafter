import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class LeaderboardUserCard extends StatelessWidget {
  final String name;
  final String email;
  final int level;
  final int points;
  final int rank;
  final String image;
  final bool highlight;

  const LeaderboardUserCard({
    super.key,
    required this.name,
    required this.email,
    required this.level,
    required this.points,
    required this.rank,
    required this.image,
    this.highlight = false,
  });

  String? get _trophy {
    switch (rank) {
      case 1:
        return 'assets/trophy/gold.json';
      case 2:
        return 'assets/trophy/silver.json';
      case 3:
        return 'assets/trophy/bronze.json';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color:
            highlight
                ? AppColors.white
                : AppColors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.white,
            backgroundImage: image.isNotEmpty ? NetworkImage(image) : null,
            child:
                image.isEmpty
                    ? const Icon(Icons.person, size: 28, color: Colors.black54)
                    : null,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontFamily: AppTypography.family,
                    fontWeight: FontWeight.bold,
                    color: highlight ? Colors.black : Colors.white,
                    fontSize: 16,
                  ),
                ),
                Text(
                  email,
                  style: TextStyle(
                    fontFamily: AppTypography.family,
                    color: highlight ? Colors.black54 : Colors.white70,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 4),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.chip3,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "$points Points",
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: 60,
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child:
                _trophy != null
                    ? Lottie.asset(_trophy!, width: 48, height: 48)
                    : Text(
                      rank.toString(),
                      style: const TextStyle(
                        fontFamily: AppTypography.family,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
