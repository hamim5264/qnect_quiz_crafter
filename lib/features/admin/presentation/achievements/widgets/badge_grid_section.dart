import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import 'badge_info_dialog.dart';

class BadgeGridSection extends StatelessWidget {
  final String role;

  const BadgeGridSection({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final badges =
        role == 'Teacher'
            ? [
              'Spark Crafter',
              'Steady Guide',
              'Quiz Coach',
              'Concept Scholar',
              'Master Crafter',
              'Insight Maestro',
              'Prime Mentor',
              'Learning Luminary',
              'Trailblazer Teacher',
              'Legend Crafter',
            ]
            : [
              'Spark Learner',
              'Steady Striver',
              'Quiz Challenger',
              'Concept Builder',
              'Skill Sprinter',
              'Insight Achiever',
              'Prime Performer',
              'Learning Luminary',
              'Trailblazer Student',
              'Legend Scholar',
            ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$role Badges',
          style: const TextStyle(
            fontFamily: AppTypography.family,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          itemCount: badges.length + 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, i) {
            if (i >= badges.length) {
              return _BadgeCard(
                name: "Coming Soon",
                lottiePath: 'assets/badges/soon.json',
                isComingSoon: true,
              );
            }
            return _BadgeCard(
              name: badges[i],
              lottiePath: 'assets/badges/badge${i + 1}.json',
            );
          },
        ),
      ],
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final String name;
  final String lottiePath;
  final bool isComingSoon;

  const _BadgeCard({
    required this.name,
    required this.lottiePath,
    this.isComingSoon = false,
  });

  @override
  Widget build(BuildContext context) {
    final parts = name.split(' ');
    final first = parts.isNotEmpty ? parts.first : name;
    final second = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                lottiePath,
                height: 60,
                repeat: true,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 8),
              Column(
                children: [
                  Text(
                    first,
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.5,
                      color: Colors.white,
                    ),
                  ),
                  if (second.isNotEmpty)
                    Text(
                      second,
                      style: const TextStyle(
                        fontFamily: AppTypography.family,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.5,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: -10,
          right: -10,
          child: IconButton(
            onPressed: () {
              if (isComingSoon) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("This badge will be available soon!"),
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (_) => BadgeInfoDialog(badgeName: name),
                );
              }
            },
            icon: const Icon(
              Icons.info_outline,
              color: Colors.white70,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }
}
