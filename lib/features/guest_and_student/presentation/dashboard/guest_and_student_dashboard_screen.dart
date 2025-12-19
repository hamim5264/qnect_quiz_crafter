import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qnect_quiz_crafter/features/guest_and_student/presentation/dashboard/provider/student_provider.dart';
import 'package:qnect_quiz_crafter/features/guest_and_student/presentation/dashboard/provider/student_latest_surprise_quiz_provider.dart';
import 'package:qnect_quiz_crafter/features/guest_and_student/presentation/dashboard/widgets/student_surprise_quiz_card.dart' show StudentSurpriseQuizCard;

import '../../../../common/screens/quiz_genie/widgets/approved_courses_provider.dart';
import '../../../../common/widgets/universal_dashboard_app_bar.dart';
import '../../../../ui/design_system/tokens/colors.dart';

import '../../../teacher/presentation/teacher_dashboard/widgets/teacher_explore_paid_courses.dart';
import 'controller/dashboard_scroll_controller.dart';
import 'widgets/stats_grid.dart';
import 'widgets/practice_card.dart';
import 'widgets/quick_actions_section.dart';
import 'widgets/concept_vault.dart';
import 'widgets/support_feedback.dart';

class GuestAndStudentDashboardScreen extends ConsumerStatefulWidget {
  final bool isGuestUser;

  const GuestAndStudentDashboardScreen({super.key, this.isGuestUser = true});

  @override
  ConsumerState<GuestAndStudentDashboardScreen> createState() =>
      _GuestAndStudentDashboardScreenState();
}

class _GuestAndStudentDashboardScreenState
    extends ConsumerState<GuestAndStudentDashboardScreen> {
  late final DashboardController controller;

  @override
  void initState() {
    super.initState();
    controller = DashboardController();

    Future.microtask(() {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        ref.read(studentControllerProvider.notifier).loadStudent(user.uid);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isGuest = user == null;
    final uid = FirebaseAuth.instance.currentUser?.uid;

    final studentState = isGuest ? null : ref.watch(studentControllerProvider);
    final student = studentState?.student;

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
                      role: isGuest ? "guest" : "student",
                      greeting: _greetingText(),
                      username:
                          isGuest
                              ? "User${_randomGuestId()}"
                              : (student?.fullName ?? "Loading..."),
                      email:
                          isGuest
                              ? "guest_${_randomGuestId()}@mail.com"
                              : (student?.email ?? ""),
                      profileImage: isGuest ? null : student?.profileImage,
                      motto: "Learn. Practice. Triumph.",
                      levelText: student?.level ?? "Level 00",
                      xpText: student?.xp ?? "0 XP",
                      isGuest: isGuest,
                      onLoginTap: () => context.push('/sign-in'),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: isGuest
                  ? const StatsGrid(uid: null)
                  : StatsGrid(uid: uid!),
            ),



            const SizedBox(height: 16),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: isGuest
                  ? PracticeCard(
                onTap: () => context.pushNamed('guestQuizWarning'),
              )
                  : Consumer(
                builder: (context, ref, _) {
                  final quizAsync = ref.watch(studentLatestSurpriseQuizProvider);


                  return quizAsync.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (quiz) {
                      if (quiz == null) {
                        return PracticeCard(
                          onTap: () => context.push('/practice-quiz'),
                        );
                      }
                      return StudentSurpriseQuizCard(quiz: quiz);
                    },
                  );

                },
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: QuickActionsSection(
                locked: isGuest,
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
                    onTap: () {
                      context.pushNamed('studentPracticeQuizList');
                    },
                  ),
                  QuickActionItem(
                    title: "Notice Board",
                    subtitle: "Get updates",
                    icon: Icon(
                      Icons.notes_rounded,
                      size: 22,
                      color: AppColors.chip2,
                    ),
                    onTap: () {
                      context.pushNamed(
                        'noticeFeed',
                        extra: 'Students',
                      );
                    },
                  ),
                  QuickActionItem(
                    title: "My Courses",
                    subtitle: "Your enrolled courses",
                    icon: Icon(
                      Icons.book_rounded,
                      size: 22,
                      color: AppColors.chip2,
                    ),
                    onTap: () {
                      context.pushNamed('studentMyCourses');
                    },
                  ),
                  QuickActionItem(
                    title: "App Paid Courses",
                    subtitle: "See all paid courses",
                    icon: Icon(
                      Icons.monetization_on_rounded,
                      size: 22,
                      color: AppColors.chip2,
                    ),
                    onTap: () {
                      context.pushNamed("studentPaidCourses");
                    },
                  ),
                  QuickActionItem(
                    title: "Purchase History",
                    subtitle: "Track your purchases",
                    icon: Icon(
                      Icons.history_rounded,
                      size: 22,
                      color: AppColors.chip2,
                    ),
                    onTap: () {
                      context.push('/student-purchase-history');
                    },
                  ),
                  QuickActionItem(
                    title: "Community Chat",
                    subtitle: "Share your thoughts",
                    icon: Icon(
                      Icons.add_reaction_rounded,
                      size: 22,
                      color: AppColors.chip2,
                    ),
                    onTap: () {
                      context.push('/community-chat');
                    },
                  ),
                  QuickActionItem(
                    title: "Leaderboard",
                    subtitle: "See your progress",
                    icon: Icon(
                      Icons.leaderboard_rounded,
                      size: 22,
                      color: AppColors.chip2,
                    ),
                    onTap: () {
                      context.pushNamed(
                        'leaderboard',
                        extra: {'role': 'student', 'userId': uid},
                      );
                    },
                  ),
                  QuickActionItem(
                    title: "Classroom",
                    subtitle: "Your academic space",
                    icon: Icon(
                      Icons.diversity_1_rounded,
                      size: 22,
                      color: AppColors.chip2,
                    ),
                    onTap: () {
                      context.pushNamed('classroom');
                    },
                  ),
                  QuickActionItem(
                    title: "Achievements",
                    subtitle: "See your achievements",
                    icon: Icon(
                      Icons.emoji_events_rounded,
                      size: 22,
                      color: AppColors.chip2,
                    ),
                    onTap: () {
                      context.pushNamed(
                        'userAchievements',
                        pathParameters: {'role': 'student'},
                      );
                    },
                  ),
                  QuickActionItem(
                    title: "Planner",
                    subtitle: "Plan your learning",
                    icon: Icon(
                      Icons.event_repeat_rounded,
                      size: 22,
                      color: AppColors.chip2,
                    ),
                    onTap: () {
                      context.pushNamed('planner');
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Consumer(
                builder: (context, ref, _) {
                  final coursesAsync = ref.watch(approvedCoursesProvider);

                  return coursesAsync.when(
                    loading: () => const SizedBox(
                      height: 150,
                      child: Center(child: CupertinoActivityIndicator(color: AppColors.white,)),
                    ),
                    error: (e, _) => const SizedBox(
                      height: 150,
                      child: Center(
                        child: Text(
                          'Failed to load courses',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                    data: (courses) {
                      if (courses.isEmpty) {
                        return const SizedBox(
                          height: 150,
                          child: Center(
                            child: Text(
                              'No approved courses yet',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        );
                      }

                      return TeacherExplorePaidCourses(
                        courses: courses,
                        onSeeAll: () => context.push('/student-paid-courses'),
                        onTapCourse: (course) =>
                            context.push('/student-paid-courses', extra: course),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ConceptVaultSection(
                locked: isGuest,
                onLockedTap: () => _showLoginRequired(context),
                items: [
                  ConceptVaultItem(
                    title: "Lecture Stream",
                    subtitle: "Stream lectures",
                    icon: const Icon(
                      Icons.video_call_rounded,
                      size: 22,
                      color: Colors.white,
                    ),
                    onTap: () {},
                  ),
                  ConceptVaultItem(
                    title: "PDF Vault",
                    subtitle: "Notes and resources",
                    icon: const Icon(
                      Icons.picture_as_pdf,
                      size: 22,
                      color: Colors.white,
                    ),
                    onTap: () {},
                  ),
                  ConceptVaultItem(
                    title: "BookBazaar",
                    subtitle: "Find books and ebooks",
                    icon: const Icon(
                      Icons.book_rounded,
                      size: 22,
                      color: Colors.white,
                    ),
                    onTap: () {},
                  ),
                  ConceptVaultItem(
                    title: "QuizRumble",
                    subtitle: "1v1 or team battles",
                    icon: const Icon(
                      Icons.gas_meter,
                      size: 22,
                      color: Colors.white,
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
                onFAQ: () {
                  context.push('/faq');
                },
                onSupport: () => context.push('/need-help'),
                onDeveloper: () => context.push('/developer-info'),

                onShare: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Feature not available right now!", style: TextStyle(color: Colors.white,),),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                },

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
      builder:
          (_) => AlertDialog(
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
                  context.push('/sign-in');
                },
                child: const Text(
                  "Login",
                  style: TextStyle(color: AppColors.white),
                ),
              ),
            ],
          ),
    );
  }
}
