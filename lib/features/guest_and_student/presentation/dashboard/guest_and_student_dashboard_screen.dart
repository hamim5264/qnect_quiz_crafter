import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/universal_dashboard_app_bar.dart';
import '../../../../ui/design_system/tokens/colors.dart';

import 'controller/dashboard_scroll_controller.dart';
import 'widgets/stats_grid.dart';
import 'widgets/practice_card.dart';
import 'widgets/quick_actions_section.dart';
import 'widgets/explore_paid_courses.dart';
import 'widgets/concept_vault.dart';
import 'widgets/support_feedback.dart';

class GuestAndStudentDashboardScreen extends StatefulWidget {
  const GuestAndStudentDashboardScreen({super.key});

  @override
  State<GuestAndStudentDashboardScreen> createState() =>
      _GuestAndStudentDashboardScreenState();
}

class _GuestAndStudentDashboardScreenState
    extends State<GuestAndStudentDashboardScreen> {
  late final DashboardController controller;

  @override
  void initState() {
    super.initState();
    controller = DashboardController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: visible ? null : 0,
                  child: AnimatedOpacity(
                    opacity: visible ? 1 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: UniversalDashboardAppBar(
                      greeting: _greetingText(),
                      username: "User${_randomGuestId()}",
                      motto: "Learn. Practice. Triumph.",
                      levelText: "Level 00",
                      xpText: "120 XP",
                      isGuest: true,
                      onLoginTap: () => context.push('/login'),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: StatsGrid(),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PracticeCard(
                onTap: () {
                  context.push('/practice-quiz');
                },
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: QuickActionsSection(
                locked: true,
                onLockedTap: () => _showLoginRequired(context),
                items: [
                  QuickActionItem(
                    title: "Practice Quizzes",
                    subtitle: "Practice quizzes",
                    icon: Icon(
                      Icons.quiz_rounded,
                      size: 22,
                      color: AppColors.chip2,
                    ),
                    onTap: () {},
                  ),
                  QuickActionItem(
                    title: "Notice Board",
                    subtitle: "Get updates",
                    icon: Icon(
                      Icons.notes_rounded,
                      size: 22,
                      color: AppColors.chip2,
                    ),
                    onTap: () {},
                  ),
                  QuickActionItem(
                    title: "My Courses",
                    subtitle: "Your enrolled courses",
                    icon: Icon(
                      Icons.book_rounded,
                      size: 22,
                      color: AppColors.chip2,
                    ),
                    onTap: () {},
                  ),
                  QuickActionItem(
                    title: "App Paid Courses",
                    subtitle: "See all paid courses",
                    icon: Icon(
                      Icons.monetization_on_rounded,
                      size: 22,
                      color: AppColors.chip2,
                    ),
                    onTap: () {},
                  ),
                  QuickActionItem(
                    title: "Purchase History",
                    subtitle: "Track your purchases",
                    icon: Icon(
                      Icons.history_rounded,
                      size: 22,
                      color: AppColors.chip2,
                    ),
                    onTap: () {},
                  ),
                  QuickActionItem(
                    title: "Community Chat",
                    subtitle: "Share your thoughts",
                    icon: Icon(
                      Icons.add_reaction_rounded,
                      size: 22,
                      color: AppColors.chip2,
                    ),
                    onTap: () {},
                  ),
                  QuickActionItem(
                    title: "Leaderboard",
                    subtitle: "See your progress",
                    icon: Icon(
                      Icons.leaderboard_rounded,
                      size: 22,
                      color: AppColors.chip2,
                    ),
                    onTap: () {},
                  ),
                  QuickActionItem(
                    title: "Teacher List",
                    subtitle: "See all teachers",
                    icon: Icon(
                      Icons.diversity_1_rounded,
                      size: 22,
                      color: AppColors.chip2,
                    ),
                    onTap: () {},
                  ),
                  QuickActionItem(
                    title: "Achievements",
                    subtitle: "See your achievements",
                    icon: Icon(
                      Icons.emoji_events_rounded,
                      size: 22,
                      color: AppColors.chip2,
                    ),
                    onTap: () {},
                  ),
                  QuickActionItem(
                    title: "Planner",
                    subtitle: "Plan your learning",
                    icon: Icon(
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
              child: ExplorePaidCourses(
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
                onTapCourse: (course) {
                  context.push('/course-details', extra: course);
                },
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ConceptVaultSection(
                locked: true,
                onLockedTap: () => _showLoginRequired(context),
                items: [
                  ConceptVaultItem(
                    title: "Lecture Stream",
                    subtitle: "Stream lectures",
                    icon: Icon(
                      Icons.video_call_rounded,
                      size: 22,
                      color: AppColors.white,
                    ),
                    onTap: () {},
                  ),
                  ConceptVaultItem(
                    title: "PDF Vault",
                    subtitle: "Notes and resources",
                    icon: Icon(
                      Icons.picture_as_pdf,
                      size: 22,
                      color: AppColors.white,
                    ),
                    onTap: () {},
                  ),
                  ConceptVaultItem(
                    title: "BookBazaar",
                    subtitle: "Find books and ebooks",
                    icon: Icon(
                      Icons.book_rounded,
                      size: 22,
                      color: AppColors.white,
                    ),
                    onTap: () {},
                  ),
                  ConceptVaultItem(
                    title: "QuizRumble",
                    subtitle: "1v1 or team battles",
                    icon: Icon(
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
                onFAQ: () => context.push('/faq'),
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

  int _randomGuestId() {
    return 100 + (DateTime.now().millisecond % 999);
  }

  void _showLoginRequired(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: AppColors.primaryLight,
          title: const Text(
            "Login Required",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Please login or create an account to access this feature.",
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
            TextButton(
              onPressed: () {
                context.pop();
                context.push('/login');
              },
              child: const Text(
                "Login",
                style: TextStyle(color: AppColors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
