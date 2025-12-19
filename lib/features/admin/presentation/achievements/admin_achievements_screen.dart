import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qnect_quiz_crafter/common/widgets/app_loader.dart';
import '../../../../ui/design_system/tokens/colors.dart';
import '../../../../common/widgets/common_rounded_app_bar.dart';
import 'widgets/availability_card.dart';
import 'widgets/unlock_badge_card.dart';
import 'widgets/badge_grid_section.dart';

class AdminAchievementsScreen extends StatelessWidget {
  const AdminAchievementsScreen({super.key});

  Future<bool> _preloadData() async {
    final users = await FirebaseFirestore.instance.collection('users').get();

    if (users.docs.isNotEmpty) {
      return true;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: 'Achievements'),

      body: FutureBuilder<bool>(
        future: _preloadData(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: AppLoader());
          }

          if (snap.hasError) {
            return const Center(
              child: Text(
                "Failed to load data",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return SafeArea(
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
          );
        },
      ),
    );
  }
}
