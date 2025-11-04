import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/common_curved_background.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import 'widgets/profile_header.dart';
import 'widgets/account_status_card.dart';
import 'widgets/section_title.dart';
import 'widgets/profile_action_card.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Stack(
        children: [
          const CommonCurvedBackground(),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ProfileHeader(
                    name: 'Admin',
                    email: 'quizcrafterDev@gmail.com',
                    imageUrl: 'https://i.pravatar.cc/150?img=12',
                  ),
                  const SizedBox(height: 24),

                  const SectionTitle(title: 'Account Status'),
                  const SizedBox(height: 12),
                  const AccountStatusCard(isLoggedIn: true),
                  const SizedBox(height: 24),

                  const SectionTitle(title: 'Profile Actions'),
                  const SizedBox(height: 12),
                  const ProfileActionCard(
                    icon: Icons.edit,
                    title: 'Edit Profile',
                    description: 'Update your info',
                  ),
                  const ProfileActionCard(
                    icon: Icons.workspace_premium_rounded,
                    title: 'Certificates',
                    description: 'Manage user certificates',
                  ),
                  const ProfileActionCard(
                    icon: Icons.receipt_long_rounded,
                    title: 'Invoice',
                    description: 'Manage payments',
                  ),

                  const SizedBox(height: 28),

                  const SectionTitle(title: 'Support & Feedback'),
                  const SizedBox(height: 12),
                  const ProfileActionCard(
                    icon: Icons.feedback_rounded,
                    title: 'Course Feedback',
                    description: 'Manage and see users feedback',
                  ),
                  const ProfileActionCard(
                    icon: Icons.star_rate_rounded,
                    title: 'App Ratings',
                    description: 'See users needs on app',
                  ),
                  ProfileActionCard(
                    icon: Icons.gavel_rounded,
                    title: 'App Guidelines',
                    description: 'Read app rules and policies',
                    onTap: () => context.pushNamed('guidelines'),
                  ),
                  ProfileActionCard(
                    icon: Icons.support_agent_rounded,
                    title: 'App Support',
                    description: 'Get help and support',
                    onTap: () => context.pushNamed('needHelp'),
                  ),
                  const ProfileActionCard(
                    icon: Icons.developer_mode_rounded,
                    title: 'Developer Information',
                    description: 'Know about app developer',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
