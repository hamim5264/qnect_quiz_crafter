import 'package:go_router/go_router.dart';
import 'package:qnect_quiz_crafter/common/screens/community_chat/community_chat_screen.dart';
import 'package:qnect_quiz_crafter/common/screens/dev_info_screen.dart';
import 'package:qnect_quiz_crafter/common/screens/notification/notification_screen.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/achievements/admin_achievements_screen.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/all_course/all_course_screen.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/app_ratings/app_ratings_screen.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/course_details/course_details_screen.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/dashboard/admin_dashboard_home_screen.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/feedback/feedback_screen.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/guest_home_screen.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/practice_quizzes/practice_quizzes_screen.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/sales_report/sales_report_screen.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/surprise_quiz_test/add/add_surprise_quiz_screen.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/surprise_quiz_test/surprise_quiz_screen.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/teacher_home_screen.dart';
import 'package:qnect_quiz_crafter/features/auth/presentation/verification/verify_otp_screen.dart';

import '../common/gates/startup_gate.dart';
import '../common/screens/chat/chat_screen.dart';
import '../common/screens/edit_profile/edit_profile_screen.dart';
import '../common/screens/guidelines_screen.dart';
import '../common/screens/leaderboard/leaderboard_screen.dart';
import '../common/screens/messages/message_screen.dart';
import '../common/screens/need_help_screen.dart';
import '../common/screens/no_internet_screen.dart';
import '../features/admin/presentation/admin_profile/admin_profile_screen.dart';
import '../features/admin/presentation/certificates/certificates_screen.dart';
import '../features/admin/presentation/certificates/generated_certificates_screen.dart';
import '../features/admin/presentation/certificates/templates_screen.dart';
import '../features/admin/presentation/course_edit/edit_course_screen.dart';
import '../features/admin/presentation/edit_quiz/edit_quiz_screen.dart';
import '../features/admin/presentation/invoice/invoice_screen.dart';
import '../features/admin/presentation/manage_users/manage_users_screen.dart';
import '../features/admin/presentation/notify_hub/add_notice_screen.dart';
import '../features/admin/presentation/notify_hub/edit_notice_screen.dart';
import '../features/admin/presentation/notify_hub/notify_hub_screen.dart';
import '../features/admin/presentation/quiz_details/quiz_details_screen.dart';
import '../features/admin/presentation/quiz_questions_info/quiz_questions_info_screen.dart';
import '../features/admin/presentation/teacher_request/teacher_request_screen.dart';
import '../features/admin/presentation/teacher_sells_report/teacher_sells_report_screen.dart';
import '../features/admin/presentation/user_details/user_details_screen.dart';
import '../features/admin/presentation/user_home_screen.dart';
import '../features/auth/presentation/onboarding/onboarding_screen.dart';

import '../features/auth/presentation/set_password/set_password_screen.dart';
import '../features/auth/presentation/sign_in/sign_in_screen.dart';
import '../features/auth/presentation/sign_up/sign_up_screen.dart';
import '../features/auth/presentation/verify_email/verify_email_screen.dart';

final router = GoRouter(
  routes: [
    /// Common Screens Routing
    GoRoute(
      path: '/',
      name: 'startup',
      builder: (_, __) => const StartupGate(),
    ),
    GoRoute(
      path: '/no-internet',
      name: 'noInternet',
      builder: (_, __) => const NoInternetScreen(),
    ),

    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (_, __) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/need-help',
      name: 'needHelp',
      builder: (context, state) => const NeedHelpScreen(),
    ),
    GoRoute(
      path: '/guidelines',
      name: 'guidelines',
      builder: (context, state) => const GuidelinesScreen(),
    ),
    GoRoute(
      path: '/developer-info',
      name: 'developerInfo',
      builder: (_, __) => const DevInfoScreen(),
    ),

    GoRoute(
      path: '/notification',
      name: 'notification',
      builder: (_, __) => const NotificationScreen(),
    ),
    GoRoute(
      path: '/messages',
      name: 'messages',
      builder: (context, state) {
        final role = state.extra as String? ?? 'admin';
        return MessageScreen(role: role);
      },
    ),
    GoRoute(
      path: '/chat',
      name: 'chat',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return ChatScreen(
          name: extra['name'] as String? ?? 'Unknown',
          avatar:
              extra['avatar'] as String? ??
              'assets/images/admin/sample_teacher3.png',
          isActive: extra['isActive'] as bool? ?? false,
        );
      },
    ),

    GoRoute(
      path: '/community-chat',
      name: 'communityChat',
      builder: (context, state) => const CommunityChatScreen(),
    ),

    /// Auth Screens Routing
    GoRoute(
      path: '/sign-in',
      name: 'signIn',
      builder: (_, __) => const SignInScreen(),
    ),

    GoRoute(
      path: '/sign-up',
      name: 'signUp',
      builder: (context, state) {
        final args = state.extra as Map<String, String>?;
        final email = args?['email'] ?? '';
        return SignUpScreen(email: email);
      },
    ),
    GoRoute(
      path: '/verify-email',
      name: 'verifyEmail',
      builder: (_, __) => const VerifyEmailScreen(),
    ),

    GoRoute(
      path: '/set-password',
      name: 'setPassword',
      builder: (_, __) => const SetPasswordScreen(),
    ),

    GoRoute(
      path: '/verify-otp',
      name: 'verifyOtp',
      builder: (context, state) {
        final email = state.extra as String;
        return VerifyOtpScreen(email: email);
      },
    ),
    GoRoute(
      path: '/teacher-home',
      name: 'teacherHome',
      builder: (_, __) => const TeacherHomeScreen(),
    ),
    GoRoute(
      path: '/user-home',
      name: 'userHome',
      builder: (_, __) => const UserHomeScreen(),
    ),
    GoRoute(
      path: '/guest-home',
      name: 'guestHome',
      builder: (_, __) => const GuestHomeScreen(),
    ),

    /// Admin Features Screens Routing
    GoRoute(
      path: '/admin-home',
      name: 'adminHome',
      builder: (_, __) => const AdminDashboardHomeScreen(),
    ),
    GoRoute(
      path: '/manage-users',
      name: 'manage-users',
      builder: (_, __) => const ManageUsersScreen(),
    ),
    GoRoute(
      path: '/user-details/:role',
      builder: (context, state) {
        final role = state.pathParameters['role'] ?? 'Teacher';
        return UserDetailsScreen(role: role);
      },
    ),
    GoRoute(
      path: '/teacher-sells-report',
      name: 'teacherSellsReport',
      builder: (context, state) => const TeacherSellsReportScreen(),
    ),
    GoRoute(
      path: '/admin-profile',
      name: 'adminProfile',
      builder: (context, state) => const AdminProfileScreen(),
    ),
    GoRoute(
      path: '/edit-profile/:role',
      name: 'editProfile',
      builder: (context, state) {
        final role = state.pathParameters['role'] ?? 'admin';
        return EditProfileScreen(role: role);
      },
    ),
    GoRoute(
      path: '/certificates',
      name: 'certificates',
      builder: (context, state) => const CertificatesScreen(),
    ),
    GoRoute(
      path: '/certificate-templates',
      name: 'certificateTemplates',
      builder: (context, state) => const CertificateTemplatesScreen(),
    ),
    GoRoute(
      name: 'generatedCertificates',
      path: '/generated-certificates',
      builder: (context, state) {
        final data = state.extra as List<Map<String, String>>?;
        return GeneratedCertificatesScreen(certificates: data);
      },
    ),
    GoRoute(
      path: '/invoice',
      name: 'invoice',
      builder: (context, state) => const InvoiceScreen(),
    ),
    GoRoute(
      path: '/course-feedback',
      name: 'courseFeedback',
      builder: (context, state) => const FeedbackScreen(),
    ),
    GoRoute(
      path: '/app-ratings',
      name: 'appRatings',
      builder: (context, state) => const AppRatingsScreen(),
    ),
    GoRoute(
      path: '/sales-report',
      name: 'salesReport',
      builder: (context, state) => const SalesReportScreen(),
    ),
    GoRoute(
      name: 'teacherRequest',
      path: '/teacher-request',
      builder: (context, state) => const TeacherRequestScreen(),
    ),

    GoRoute(
      name: 'notifyHub',
      path: '/notify-hub',
      builder: (context, state) => const NotifyHubScreen(),
    ),

    GoRoute(
      name: 'addNotice',
      path: '/add-notice',
      builder: (context, state) => const AddNoticeScreen(),
    ),
    GoRoute(
      path: '/edit-notice',
      builder: (context, state) {
        final extra = state.extra;
        final Map<String, dynamic> notice =
            (extra is Map<String, dynamic>) ? extra : <String, dynamic>{};
        return EditNoticeScreen(notice: notice);
      },
    ),
    GoRoute(
      name: 'adminAchievementBadge',
      path: '/admin-achievement-badge',
      builder: (context, state) => const AdminAchievementsScreen(),
    ),
    GoRoute(
      name: 'adminCourseAllCourse',
      path: '/admin-all-course',
      builder: (context, state) => const AllCourseScreen(),
    ),
    GoRoute(
      name: 'adminCourseDetails',
      path: '/admin-course-details',
      builder: (context, state) {
        final courseData = state.extra as Map<String, dynamic>?;
        return CourseDetailsScreen(courseData: courseData ?? {});
      },
    ),
    GoRoute(
      name: 'adminEditCourse',
      path: '/admin-edit-course',
      builder: (context, state) => const EditCourseScreen(),
    ),
    GoRoute(
      path: '/edit-quiz',
      name: 'editQuiz',
      builder: (context, state) => const EditQuizScreen(),
    ),
    GoRoute(
      name: 'adminQuizDetails',
      path: '/admin-quiz-details',
      builder: (context, state) => const QuizDetailsScreen(),
    ),
    GoRoute(
      name: 'adminQuizQuestionsInfo',
      path: '/admin-quiz-questions-info',
      builder: (context, state) => const QuizQuestionsInfoScreen(),
    ),
    GoRoute(
      name: 'adminPracticeQuiz',
      path: '/admin-practice-quiz',
      builder: (context, state) => const PracticeQuizzesScreen(),
    ),
    GoRoute(
      name: 'adminSurpriseQuiz',
      path: '/admin-surprise-quiz',
      builder: (context, state) => const SurpriseQuizScreen(),
    ),
    GoRoute(
      name: 'addSurpriseNewQuiz',
      path: '/add-surprise-new-quiz',
      builder: (context, state) => const AddSurpriseQuizScreen(),
    ),
    GoRoute(
      path: '/leaderboard',
      name: 'leaderboard',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return LeaderboardScreen(
          userRole: extra?['role'] ?? 'student',
          currentUserId: extra?['userId'] ?? '',
        );
      },
    ),
  ],
);
