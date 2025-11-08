import 'package:flutter/material.dart';
import '../../../../ui/design_system/tokens/colors.dart';
import '../../../../common/widgets/common_rounded_app_bar.dart';
import 'widgets/availability_card.dart';
import 'widgets/unlock_badge_card.dart';
import 'widgets/badge_grid_section.dart';

class AdminAchievementsScreen extends StatelessWidget {
  const AdminAchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: 'Achievements'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              AvailabilityCard(),
              SizedBox(height: 20),
              UnlockBadgeCard(),
              SizedBox(height: 30),
              BadgeGridSection(role: 'Teacher'),
              SizedBox(height: 30),
              BadgeGridSection(role: 'Student'),
            ],
          ),
        ),
      ),
    );
  }
}
