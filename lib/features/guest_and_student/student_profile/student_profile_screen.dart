import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:qnect_quiz_crafter/features/guest_and_student/student_profile/widgets/student_account_status_card.dart';
import 'package:qnect_quiz_crafter/features/guest_and_student/student_profile/widgets/student_profile_actions_section.dart';
import 'package:qnect_quiz_crafter/features/guest_and_student/student_profile/widgets/student_profile_header.dart';

import '../../../../common/widgets/common_curved_background.dart';
import '../presentation/dashboard/provider/student_provider.dart';

class StudentProfileScreen extends ConsumerWidget {
  final bool isGuest;
  final String username;
  final String email;
  final String? profileImage;

  const StudentProfileScreen({
    super.key,
    required this.isGuest,
    required this.username,
    required this.email,
    this.profileImage,
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
                  StudentProfileHeader(
                    isGuest: isGuest,
                    username: isGuest ? "" : username,
                    email: isGuest ? "" : email,
                    profileImage: profileImage,
                    onLogout: () async {
                      if (!isGuest) {
                        await FirebaseAuth.instance.signOut();

                        ref.invalidate(studentControllerProvider);

                        context.go('/onboarding');
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  StudentAccountStatusCard(
                    isGuest: isGuest,
                    onLoginTap: () => context.push('/sign-in'),
                    onCreateTap: () => context.push('/sign-up'),
                  ),

                  const SizedBox(height: 30),

                  StudentProfileActionsSection(
                    isGuest: isGuest,
                    onEditProfile: () {
                      if (!isGuest) {
                        context.push('/edit-profile/student');
                      }
                    },
                    onCertificates: () {
                      context.pushNamed('userCertificates');
                    },
                    onDeleteAccount: () {
                      if (!isGuest) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Feature not available",
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    },
                    onStudentFeedback: () {
                      context.pushNamed('feedback');
                    },
                    onAdminFeedback: () => context.push('/guidelines'),
                    onStudentAddRating: () => context.pushNamed('addAppRating'),
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
