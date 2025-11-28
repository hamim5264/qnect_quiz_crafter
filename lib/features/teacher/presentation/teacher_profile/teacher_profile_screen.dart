import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/common_curved_background.dart';

import '../../../guest_and_student/presentation/dashboard/provider/student_provider.dart';
import '../../../teacher/data/providers/teacher_providers.dart';
import '../../../admin/presentation/dashboard/controller/admin_controller.dart';

import 'widgets/profile_header.dart';
import 'widgets/profile_actions_section.dart';

class TeacherProfileScreen extends ConsumerWidget {
  final String username;
  final String email;
  final String? profileImage;

  const TeacherProfileScreen({
    super.key,
    required this.username,
    required this.email,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const Positioned.fill(child: CommonCurvedBackground()),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileHeader(
                    username: username,
                    email: email,
                    profileImage: profileImage,
                    onLogout: () async {
                      await FirebaseAuth.instance.signOut();

                      ref.invalidate(studentControllerProvider);
                      ref.invalidate(teacherControllerProvider);
                      ref.invalidate(adminControllerProvider);

                      if (context.mounted) {
                        context.go('/onboarding');
                      }
                    },
                  ),

                  const SizedBox(height: 30),

                  ProfileActionsSection(
                    onEditProfile: () {
                      context.push('/edit-profile/teacher');
                    },
                    onCertificates: () {
                      context.push('/teacher-certificates');
                    },
                    onDeleteAccount: () {
                      context.push('/delete-account');
                    },
                    onStudentFeedback: () {
                      context.push('/teacher-feedback');
                    },
                    onAdminFeedback: () {
                      context.push('/admin-feedback', extra: email);
                    },
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
