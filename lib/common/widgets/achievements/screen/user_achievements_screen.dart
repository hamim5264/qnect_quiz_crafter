import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qnect_quiz_crafter/common/services/user_achievements_controller.dart';
import 'package:qnect_quiz_crafter/common/widgets/app_loader.dart';
import 'package:qnect_quiz_crafter/common/widgets/common_rounded_app_bar.dart';

import '../../../../ui/design_system/tokens/colors.dart';
import '../../../../ui/design_system/tokens/typography.dart';
import '../user_achievement_badge_item.dart';

class UserAchievementsScreen extends ConsumerWidget {
  final String role;

  const UserAchievementsScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userAchievementsControllerProvider(role));
    final controller = ref.read(
      userAchievementsControllerProvider(role).notifier,
    );

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: CommonRoundedAppBar(title: "Achievements"),

      body: RefreshIndicator(
        onRefresh: () => controller.refresh(),
        color: AppColors.secondaryDark,
        backgroundColor: AppColors.primaryLight,
        child:
            state.loading
                ? const _LoadingState()
                : state.error != null
                ? _ErrorState(message: state.error!)
                : _AchievementsBody(state: state),
      ),
    );
  }
}

class _AchievementsBody extends StatelessWidget {
  final UserAchievementsState state;

  const _AchievementsBody({required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _currentStreakCard(),

          const SizedBox(height: 24),

          _levelProgress(),

          const SizedBox(height: 28),
          const Text(
            "My Badges",
            style: TextStyle(
              fontFamily: AppTypography.family,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 14),
          _badgesGrid(),
        ],
      ),
    );
  }

  Widget _currentStreakCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondaryDark,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  "7 Days",
                  style: TextStyle(
                    fontFamily: AppTypography.family,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "+ ${state.sevenDayGrowth.toStringAsFixed(2)}%",
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  color: Colors.redAccent,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const Text(
            "Current Streak",
            style: TextStyle(
              fontFamily: AppTypography.family,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              _infoPill(
                label: "XP",
                value: "${state.xp}/1000",
                icon: Icons.auto_graph,
              ),
              const SizedBox(width: 12),
              _infoPill(
                label: "Level",
                value: "${state.level}/10",
                icon: Icons.shield,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoPill({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.chip3,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.chip1, size: 20),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _levelProgress() {
    final currentXp = state.xp % 1000;
    final progress = currentXp / 1000;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Level ${state.level.toString().padLeft(2, '0')}",
          style: const TextStyle(
            fontFamily: AppTypography.family,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$currentXp/1000 XP",
              style: const TextStyle(
                fontFamily: AppTypography.family,
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),

        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.white24,
            valueColor: const AlwaysStoppedAnimation(AppColors.secondaryDark),
          ),
        ),
      ],
    );
  }

  Widget _badgesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: state.badges.length,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: .88,
      ),
      itemBuilder: (context, index) {
        final badge = state.badges[index];

        return UserAchievementBadgeItem(badge: badge);
      },
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(child: AppLoader());
  }
}

class _ErrorState extends StatelessWidget {
  final String message;

  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.redAccent,
          fontFamily: AppTypography.family,
        ),
      ),
    );
  }
}
