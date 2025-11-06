import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      {
        'title': "Teacher's Request",
        'subtitle': 'Manage & Verify Request',
        'icon': LucideIcons.userCheck,
        'route': '/teacher-requests',
      },
      {
        'title': 'Manage Users',
        'subtitle': 'Delete, Block, Msg...',
        'icon': LucideIcons.users,
        'route': '/manage-users',
      },
      {
        'title': 'Practice Quizzes',
        'subtitle': 'Update & Delete...',
        'icon': LucideIcons.penTool,
        'route': '/practice-quizzes',
      },
      {
        'title': 'All Course',
        'subtitle': 'Manage Every Course',
        'icon': LucideIcons.bookOpen,
        'route': '/all-course',
      },
      {
        'title': 'QuizGenie',
        'subtitle': 'Build Faster Quiz',
        'icon': LucideIcons.wand2,
        'route': '/quizgenie',
      },
      {
        'title': 'Community Chat',
        'subtitle': 'Share & Collaborate with Teachers & Students',
        'icon': LucideIcons.messageCircle,
        'route': '/community-chat',
      },
      {
        'title': 'Leaderboard',
        'subtitle': 'See all Students...',
        'icon': LucideIcons.trophy,
        'route': '/leaderboard',
      },
      {
        'title': 'QC Vault',
        'subtitle': 'Your Reusable Questions',
        'icon': LucideIcons.folderLock,
        'route': '/qc-vault',
      },
      {
        'title': 'Surprise Test',
        'subtitle': 'Let Students Grow...',
        'icon': LucideIcons.alertTriangle,
        'route': '/surprise-test',
      },
      {
        'title': 'Achievements',
        'subtitle': 'Manage Badges...',
        'icon': LucideIcons.award,
        'route': '/achievements',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontFamily: AppTypography.family,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children:
                actions.map((e) {
                  return GestureDetector(
                    onTap: () {
                      final route = e['route'] as String?;
                      if (route != null && route.isNotEmpty) {
                        context.push(route);
                      }
                    },
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 48) / 2,
                      height: 72,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryDark,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              e['icon'] as IconData,
                              color: AppColors.primaryDark,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  e['title'] as String,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontFamily: AppTypography.family,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  e['subtitle'] as String,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: AppTypography.family,
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
