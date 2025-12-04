import 'package:go_router/go_router.dart';
import 'package:qnect_quiz_crafter/common/screens/community_chat/community_chat_screen.dart';
import 'package:qnect_quiz_crafter/common/screens/dev_info_screen.dart';
import 'package:qnect_quiz_crafter/common/screens/notification/notification_screen.dart';
import 'package:qnect_quiz_crafter/common/screens/qc_vault/qc_vault_add_question_screen.dart';
import 'package:qnect_quiz_crafter/common/screens/qc_vault/qc_vault_screen.dart';
import 'package:qnect_quiz_crafter/common/screens/qc_vault/qc_vault_view_screen.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/achievements/admin_achievements_screen.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/all_course/all_course_screen.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/app_ratings/app_ratings_screen.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/course_details/course_details_screen.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/dashboard/admin_dashboard_home_screen.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/feedback/feedback_screen.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/practice_quizzes/practice_quizzes_screen.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/sales_report/sales_report_screen.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/surprise_quiz_test/add/add_surprise_quiz_screen.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/surprise_quiz_test/surprise_quiz_screen.dart';
import 'package:qnect_quiz_crafter/features/auth/presentation/verification/verify_otp_screen.dart';
import 'package:qnect_quiz_crafter/features/guest_and_student/presentation/dashboard/guest_and_student_dashboard_screen.dart';
import 'package:qnect_quiz_crafter/features/teacher/presentation/teacher_dashboard/teacher_dashboard_screen.dart';

import '../common/gates/startup_gate.dart';
import '../common/screens/chat/chat_screen.dart';
import '../common/screens/edit_profile/edit_profile_screen.dart';
import '../common/screens/guidelines_screen.dart';
import '../common/screens/leaderboard/leaderboard_screen.dart';
import '../common/screens/messages/message_screen.dart';
import '../common/screens/need_help_screen.dart';
import '../common/screens/no_internet_screen.dart';
import '../common/screens/qc_vault/data/qc_vault_models.dart';
import '../common/screens/quiz_genie/quiz_genie_screen.dart';
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
import '../features/admin/presentation/surprise_quiz_test/add/surprise_quiz_import_screen.dart';
import '../features/admin/presentation/teacher_request/teacher_request_screen.dart';
import '../features/admin/presentation/teacher_sells_report/teacher_sells_report_screen.dart';
import '../features/admin/presentation/user_details/user_details_screen.dart';
import '../features/auth/presentation/onboarding/onboarding_screen.dart';

import '../features/auth/presentation/set_password/set_password_screen.dart';
import '../features/auth/presentation/sign_in/sign_in_screen.dart';
import '../features/auth/presentation/sign_up/sign_up_screen.dart';
import '../features/auth/presentation/verify_email/verify_email_screen.dart';
import '../features/guest_and_student/paid_courses/presentation/screens/student_buy_course_screen.dart';
import '../features/guest_and_student/paid_courses/presentation/screens/student_course_details_screen.dart';
import '../features/guest_and_student/paid_courses/presentation/screens/student_my_courses_screen.dart';
import '../features/guest_and_student/paid_courses/presentation/screens/student_paid_courses_screen.dart';
import '../features/guest_and_student/student_profile/student_profile_screen.dart';
import '../features/teacher/course_management/models/teacher_course_model.dart';
import '../features/teacher/course_management/presentation/add_course/add_course_screen.dart';
import '../features/teacher/course_management/presentation/add_quiz/add_quiz_screen.dart';
import '../features/teacher/course_management/presentation/add_quiz/qc_vault/teacher_qc_vault_import_screen.dart';
import '../features/teacher/course_management/presentation/add_quiz/qc_vault/teacher_qc_vault_question_select_screen.dart';
import '../features/teacher/course_management/presentation/course_details/teacher_course_details_screen.dart';
import '../features/teacher/course_management/presentation/my_courses/teacher_my_courses_screen.dart';
import '../features/teacher/presentation/teacher_profile/teacher_profile_screen.dart';
import '../features/teacher/presentation/teacher_status/blocked_teacher_screen.dart';
import '../features/teacher/presentation/teacher_status/rejected_teacher_screen.dart';
import '../features/teacher/presentation/teacher_status/teacher_status_screen.dart';

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
      path: '/messages/:role',
      name: 'messages',
      builder: (context, state) {
        final role = state.pathParameters['role'] ?? 'student';

        return MessageScreen(role: role);
      },
    ),

    GoRoute(
      name: 'chat',
      path: '/chat',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};

        final String chatId = (extra['chatId'] ?? '').toString();
        final String peerId = (extra['peerId'] ?? '').toString();
        final String name = (extra['name'] ?? 'Unknown User').toString();
        final String? avatar = extra['avatar'] as String?;
        final bool isActive = extra['isActive'] == true;
        final String peerRole = (extra['peerRole'] ?? 'student').toString();

        return ChatScreen(
          chatId: chatId,
          peerId: peerId,
          name: name,
          avatar: avatar,
          isActive: isActive,
          peerRole: peerRole,
        );
      },
    ),

    GoRoute(
      path: '/community-chat',
      name: 'communityChat',
      builder: (context, state) => const CommunityChatScreen(),
    ),

    GoRoute(
      path: '/edit-profile/:role',
      name: 'editProfile',
      builder: (context, state) {
        final role = state.pathParameters['role'] ?? 'teacher';
        return EditProfileScreen(role: role);
      },
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
      path: '/qc-vault',
      name: 'qcVault',
      builder: (context, state) => const QCVaultScreen(),
    ),
    GoRoute(
      name: 'qcVaultView',
      path: '/qc-vault-view/:courseId/:courseTitle',
      builder: (context, state) {
        final courseId = state.pathParameters['courseId']!;
        final courseTitle = state.pathParameters['courseTitle']!;
        return QCVaultViewScreen(courseId: courseId, courseTitle: courseTitle);
      },
    ),

    GoRoute(
      name: 'qcVaultAddQuestion',
      path: '/qc-vault-add-question/:courseId/:courseTitle',
      builder: (context, state) {
        final courseId = state.pathParameters['courseId']!;
        final courseTitle = state.pathParameters['courseTitle']!;
        return QCVaultAddQuestionScreen(
          courseId: courseId,
          courseTitle: courseTitle,
        );
      },
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
      name: 'user-details',
      builder: (context, state) {
        final role = state.pathParameters['role'];
        final email = state.extra as String;

        return UserDetailsScreen(role: role!, email: email);
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
        final courseId = state.extra as String;
        return CourseDetailsScreen(courseId: courseId);
      },
    ),

    GoRoute(
      path: '/admin-edit-course/:courseId',
      name: 'adminEditCourse',
      builder: (context, state) {
        final courseId = state.pathParameters['courseId']!;
        return EditCourseScreen(courseId: courseId);
      },
    ),

    GoRoute(
      name: 'adminEditQuiz',
      path: '/admin-edit-quiz/:courseId/:quizId',
      builder: (context, state) {
        final courseId = state.pathParameters['courseId']!;
        final quizId = state.pathParameters['quizId']!;
        return EditQuizScreen(courseId: courseId, quizId: quizId);
      },
    ),

    GoRoute(
      name: "adminQuizDetails",
      path: "/admin-quiz-details",
      builder: (context, state) {
        final quiz = state.extra as Map<String, dynamic>;
        return QuizDetailsScreen(quiz: quiz);
      },
    ),

    GoRoute(
      name: 'adminQuizQuestionsInfo',
      path: '/admin/quiz/questions',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;

        return QuizQuestionsInfoScreen(
          quizTitle: data["title"] ?? "",
          quizDuration: data["time"] as Duration, // HERE FIX
          questions: List<Map<String, dynamic>>.from(data["questions"]),
        );
      },
    ),

    GoRoute(
      name: 'adminPracticeQuiz',
      path: '/admin-practice-quiz/:role',
      builder: (context, state) {
        final role = state.pathParameters['role'] ?? 'admin';
        return PracticeQuizzesScreen(role: role);
      },
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
      name: 'importSurpriseQuiz',
      path: '/admin/surprise/import',
      builder: (context, state) => const SurpriseQuizImportScreen(),
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

    GoRoute(
      name: 'quizGenie',
      path: '/quizgenie/:role',
      builder: (context, state) {
        final role = state.pathParameters['role'] ?? 'teacher';
        return QuizGenieScreen(creatorRole: role);
      },
    ),

    /// Teacher Dashboard
    GoRoute(
      path: '/teacher-status',
      builder: (context, state) {
        final email = state.extra as String;
        return TeacherStatusScreen(email: email);
      },
    ),

    GoRoute(
      path: '/rejected',
      builder: (context, state) {
        final email = state.extra as String;
        return RejectedTeacherScreen(email: email);
      },
    ),

    GoRoute(
      path: '/blocked',
      name: 'blocked',
      builder: (context, state) {
        final email = state.extra as String?;
        return BlockedTeacherScreen(email: email);
      },
    ),

    /// Student Dashboard
    GoRoute(
      path: '/student-profile',
      builder: (context, state) {
        final data = state.extra as Map?;
        return StudentProfileScreen(
          isGuest: data?['isGuest'] ?? true,
          username: data?['username'] ?? "GuestUser",
          email: data?['email'] ?? "guest@mail.com",
          profileImage: data?['profileImage'],
        );
      },
    ),
    GoRoute(
      path: '/guest_and_student-home',
      name: 'guestHome',
      builder: (context, state) {
        final isGuest = state.extra as bool? ?? true;
        return GuestAndStudentDashboardScreen(isGuestUser: isGuest);
      },
    ),

    GoRoute(
      path: '/teacher-home',
      name: 'teacherHome',
      builder: (context, state) => const TeacherDashboardScreen(),
    ),
    GoRoute(
      path: '/teacher-profile',
      name: 'teacherProfile',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>?;

        return TeacherProfileScreen(
          username: data?['username'] ?? "Teacher",
          email: data?['email'] ?? "email@example.com",
          profileImage: data?['profileImage'],
        );
      },
    ),

    GoRoute(
      path: '/teacher/my-courses',
      name: 'teacherMyCourses',
      builder: (context, state) => const TeacherMyCoursesScreen(),
    ),

    GoRoute(
      path: '/teacher/add-course',
      name: 'teacherAddCourse',
      builder: (context, state) => const TeacherAddCourseScreen(),
    ),

    GoRoute(
      path: '/teacher/course-details',
      name: 'teacherCourseDetails',
      builder: (context, state) {
        final course = state.extra as TeacherCourseModel;
        return TeacherCourseDetailsScreen(course: course);
      },
    ),

    GoRoute(
      path: '/teacher/add-quiz',
      name: 'teacherAddQuiz',
      builder: (context, state) {
        final course = state.extra as TeacherCourseModel;
        return TeacherAddQuizScreen(course: course);
      },
    ),

    GoRoute(
      path: '/teacher/qc-vault/import',
      name: 'teacherQcVaultImport',
      builder: (context, state) => const TeacherQCVaultImportScreen(),
    ),

    GoRoute(
      path: '/teacher/qc-vault/questions',
      name: 'teacherQcVaultQuestions',
      builder: (context, state) {
        final course = state.extra as QCVaultCourse;
        return TeacherQCVaultQuestionSelectScreen(course: course);
      },
    ),
    GoRoute(
      path: '/student-paid-courses',
      name: 'studentPaidCourses',
      builder: (context, state) => const StudentPaidCoursesScreen(),
    ),

    GoRoute(
      path: '/student-buy-course',
      name: 'studentBuyCourse',
      builder: (context, state) {
        final course = state.extra as Map<String, dynamic>; // incoming course data
        return StudentBuyCourseScreen(course: course);
      },
    ),
    // inside routes list:
    GoRoute(
      path: '/student/my-courses',
      name: 'studentMyCourses',
      builder: (context, state) => const StudentMyCoursesScreen(),
    ),

    GoRoute(
      path: '/student/my-courses/:courseId',
      name: 'studentCourseDetails',
      builder: (context, state) {
        final courseId = state.pathParameters['courseId']!;
        return StudentCourseDetailsScreen(courseId: courseId);
      },
    ),

  ],
);
