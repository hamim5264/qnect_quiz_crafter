import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qnect_quiz_crafter/common/widgets/app_loader.dart';

import '../../../../../../common/widgets/universal_dashboard_app_bar.dart';
import '../../../../../../ui/design_system/tokens/colors.dart';

import '../../data/providers/teacher_providers.dart';
import 'controller/teacher_dashboard_scrollbar_controller.dart';

import 'widgets/teacher_stacts_grid.dart';
import 'widgets/teacher_quick_action_section.dart';
import 'widgets/teacher_explore_paid_courses.dart';
import 'widgets/teacher_concept_vault.dart';
import '../../../guest_and_student/presentation/dashboard/widgets/support_feedback.dart';

class TeacherDashboardScreen extends ConsumerStatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  ConsumerState<TeacherDashboardScreen> createState() =>
      _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState
    extends ConsumerState<TeacherDashboardScreen> {
  late final TeacherDashboardScrollbarController controller;

  @override
  void initState() {
    super.initState();
    controller = TeacherDashboardScrollbarController();

    Future.microtask(() {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      ref.read(teacherControllerProvider.notifier).loadTeacher(uid);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teacherState = ref.watch(teacherControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.secondaryDark.withValues(alpha: 0.95),
      body: SingleChildScrollView(
        controller: controller.scrollController,
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: controller.showAppBar,
              builder: (context, visible, _) {
                if (teacherState.loading) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Center(child: AppLoader(size: 40)),
                  );
                }

                final teacher = teacherState.teacher;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: visible ? null : 0,
                  child: AnimatedOpacity(
                    opacity: visible ? 1 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: UniversalDashboardAppBar(
                      role: "teacher",
                      greeting: _greetingText(),
                      username: teacher?.fullName ?? "Teacher",
                      email: teacher?.email ?? "",
                      profileImage: teacher?.profileImage,
                      motto: "Learn. Practice. Triumph.",
                      levelText: "Level ${teacher?.level ?? 0}",
                      xpText: "${teacher?.xp ?? 0} XP",
                      isGuest: false,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TeacherStatsGrid(),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TeacherQuickActionsSection(
                items: [
                  TeacherQuickActionItem(
                    title: "Practice Quizzes",
                    subtitle: "Practice quizzes",
                    icon: const Icon(
                      Icons.quiz_rounded,
                      size: 22,
                      color: AppColors.chip2,
                    ),
                    onTap: () {},
                  ),
                  TeacherQuickActionItem(
                    title: "Notice Board",
                    subtitle: "Latest updates",
                    icon: const Icon(
                      Icons.notes_rounded,
                      size: 22,
                      color: AppColors.chip2,
                    ),
                    onTap: () {},
                  ),
                  TeacherQuickActionItem(
                    title: "My Courses",
                    subtitle: "Your enrolled courses",
                    icon: const Icon(
                      Icons.book_rounded,
                      size: 22,
                      color: AppColors.chip2,
                    ),
                    onTap: () {},
                  ),
                  TeacherQuickActionItem(
                    title: "App Paid Courses",
                    subtitle: "See all paid courses",
                    icon: const Icon(
                      Icons.monetization_on_rounded,
                      size: 22,
                      color: AppColors.chip2,
                    ),
                    onTap: () {},
                  ),
                  TeacherQuickActionItem(
                    title: "Purchase History",
                    subtitle: "Track your purchases",
                    icon: const Icon(
                      Icons.history_rounded,
                      size: 22,
                      color: AppColors.chip2,
                    ),
                    onTap: () {},
                  ),
                  TeacherQuickActionItem(
                    title: "Community Chat",
                    subtitle: "Share thoughts",
                    icon: const Icon(
                      Icons.add_reaction_rounded,
                      size: 22,
                      color: AppColors.chip2,
                    ),
                    onTap: () {
                      context.push('/community-chat');
                    },
                  ),
                  TeacherQuickActionItem(
                    title: "Leaderboard",
                    subtitle: "See your progress",
                    icon: const Icon(
                      Icons.leaderboard_rounded,
                      size: 22,
                      color: AppColors.chip2,
                    ),
                    onTap: () {},
                  ),
                  TeacherQuickActionItem(
                    title: "Teacher List",
                    subtitle: "See all teachers",
                    icon: const Icon(
                      Icons.diversity_1_rounded,
                      size: 22,
                      color: AppColors.chip2,
                    ),
                    onTap: () {},
                  ),
                  TeacherQuickActionItem(
                    title: "Achievements",
                    subtitle: "Your badges",
                    icon: const Icon(
                      Icons.emoji_events_rounded,
                      size: 22,
                      color: AppColors.chip2,
                    ),
                    onTap: () {},
                  ),
                  TeacherQuickActionItem(
                    title: "Planner",
                    subtitle: "Plan your lessons",
                    icon: const Icon(
                      Icons.event_repeat_rounded,
                      size: 22,
                      color: AppColors.chip2,
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TeacherExplorePaidCourses(
                courses: [
                  CourseItem(
                    title: "ICT Complete Course",
                    image:
                        "https://i.ibb.co.com/r5ZxKXX/placeholder-course.png",
                    quizCount: 50,
                    enrolled: 1200,
                    price: 490,
                    discount: 20,
                  ),
                  CourseItem(
                    title: "Physics Mastery",
                    image:
                        "https://i.ibb.co.com/r5ZxKXX/placeholder-course.png",
                    quizCount: 60,
                    enrolled: 800,
                    price: 350,
                    discount: 15,
                  ),
                ],
                onSeeAll: () => context.push('/explore-courses'),
                onTapCourse:
                    (course) => context.push('/course-details', extra: course),
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TeacherConceptVaultSection(
                items: [
                  TeacherConceptVaultItem(
                    title: "Lecture Stream",
                    subtitle: "Stream lectures",
                    icon: const Icon(
                      Icons.video_call_rounded,
                      size: 22,
                      color: AppColors.white,
                    ),
                    onTap: () {},
                  ),
                  TeacherConceptVaultItem(
                    title: "PDF Vault",
                    subtitle: "Notes & resources",
                    icon: const Icon(
                      Icons.picture_as_pdf,
                      size: 22,
                      color: AppColors.white,
                    ),
                    onTap: () {},
                  ),
                  TeacherConceptVaultItem(
                    title: "BookBazaar",
                    subtitle: "Books & eBooks",
                    icon: const Icon(
                      Icons.book_rounded,
                      size: 22,
                      color: AppColors.white,
                    ),
                    onTap: () {},
                  ),
                  TeacherConceptVaultItem(
                    title: "QuizRumble",
                    subtitle: "1v1 or team battles",
                    icon: const Icon(
                      Icons.gas_meter,
                      size: 22,
                      color: AppColors.white,
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SupportFeedback(
                onFAQ: () async {
                  await FirebaseAuth.instance.signOut();
                  if (!mounted) return;
                  context.go('/sign-in');
                },
                onSupport: () => context.push('/support'),
                onShare: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _greetingText() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }
}
