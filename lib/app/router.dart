import 'package:firebase_auth/firebase_auth.dart';
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
import '../common/user_certificates/certificate_preview_screen.dart';
import '../common/user_certificates/user_certificates_screen.dart';
import '../common/widgets/achievements/screen/user_achievements_screen.dart';
import '../features/admin/presentation/admin_profile/admin_profile_screen.dart';
import '../features/admin/presentation/app_ratings/add_app_rating_screen.dart';
import '../features/admin/presentation/certificates/certificates_screen.dart';
import '../features/admin/presentation/certificates/generated_certificates_screen.dart';
import '../features/admin/presentation/certificates/templates_screen.dart';
import '../features/admin/presentation/course_edit/edit_course_screen.dart';
import '../features/admin/presentation/edit_quiz/edit_quiz_screen.dart';
import '../features/admin/presentation/feedback/add_feedback_screen.dart';
import '../features/admin/presentation/feedback/feedback_screen.dart';
import '../features/admin/presentation/invoice/invoice_screen.dart';
import '../features/admin/presentation/manage_users/manage_users_screen.dart';
import '../features/admin/presentation/notify_hub/add_notice_screen.dart';
import '../features/admin/presentation/notify_hub/edit_notice_screen.dart';
import '../features/admin/presentation/notify_hub/notice_feed_screen.dart';
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
import '../features/classroom/presentation/classroom_screen.dart';
import '../features/faq/faq_screen.dart';
import '../features/guest_and_student/paid_courses/presentation/screens/student_buy_course_screen.dart';
import '../features/guest_and_student/paid_courses/presentation/screens/student_course_details_screen.dart';
import '../features/guest_and_student/paid_courses/presentation/screens/student_my_courses_screen.dart';
import '../features/guest_and_student/paid_courses/presentation/screens/student_paid_courses_screen.dart';
import '../features/guest_and_student/purchase_history/student_purchase_history_screen.dart';
import '../features/guest_and_student/quiz/presentation/screens/student_quiz_attempt_screen.dart';
import '../features/guest_and_student/quiz/presentation/screens/student_quiz_details_screen.dart';
import '../features/guest_and_student/quiz/presentation/screens/student_quiz_instruction_screen.dart';
import '../features/guest_and_student/quiz/presentation/screens/student_quiz_result_screen.dart';
import '../features/guest_and_student/student_practice_quiz/student_practice_quiz_attempt_screen.dart';
import '../features/guest_and_student/student_practice_quiz/student_practice_quiz_details_screen.dart';
import '../features/guest_and_student/student_practice_quiz/student_practice_quiz_instruction_screen.dart';
import '../features/guest_and_student/student_practice_quiz/student_practice_quiz_list_screen.dart';
import '../features/guest_and_student/student_profile/student_profile_screen.dart';
import '../features/guest_and_student/student_surprise_quizzes/presentation/screens/student_surprise_quiz_attempt_screen.dart';
import '../features/guest_and_student/student_surprise_quizzes/presentation/screens/student_surprise_quiz_list_screen.dart';
import '../features/guest_quiz/presentation/screens/guest_quiz_attempt_screen.dart';
import '../features/guest_quiz/presentation/screens/guest_quiz_result_screen.dart';
import '../features/guest_quiz/presentation/screens/guest_quiz_warning_screen.dart';
import '../features/planner/planner_screen.dart';
import '../features/teacher/admin_feedback/teacher_admin_feedback_screen.dart';
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
      name: "notification",
      path: "/notification",
      builder: (_, __) => const NotificationScreen(role: "admin"),
    ),

    GoRoute(
      name: "teacherNotification",
      path: "/teacher-notification",
      builder: (context, state) {
        final uid = FirebaseAuth.instance.currentUser!.uid;
        return NotificationScreen(role: "teacher", uid: uid);
      },
    ),
    GoRoute(
      name: "studentNotification",
      path: "/student-notification",
      builder: (context, state) {
        final uid = FirebaseAuth.instance.currentUser!.uid;
        return NotificationScreen(role: "student", uid: uid);
      },
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
        final role = state.pathParameters['role'] ?? "Unknown";

        final email = state.extra is String ? state.extra as String : "";

        return UserDetailsScreen(role: role, email: email);
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
          quizDuration: data["time"] as Duration,
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
        final role =
            state.extra is Map ? (state.extra as Map)['role'] : "student";
        final userId = state.extra is Map ? (state.extra as Map)['userId'] : "";

        return LeaderboardScreen(userRole: role, currentUserId: userId);
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
        final course = state.extra as Map<String, dynamic>;
        return StudentBuyCourseScreen(course: course);
      },
    ),
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

    GoRoute(
      path: '/student-quiz-instruction',
      name: 'studentQuizInstruction',
      builder: (context, state) {
        final extra = state.extra! as Map<String, dynamic>;
        return StudentQuizInstructionScreen(
          quizId: extra['quizId'],
          courseId: extra['courseId'],
          title: extra['title'],
          durationSeconds: extra['durationSeconds'],
          questions: (extra['questions'] as List).cast<Map<String, dynamic>>(),
        );
      },
    ),

    GoRoute(
      path: '/student-quiz-attempt',
      name: 'studentQuizAttempt',
      builder: (context, state) {
        final extra = state.extra! as Map<String, dynamic>;
        return StudentQuizAttemptScreen(
          quizId: extra['quizId'],
          courseId: extra['courseId'],
          title: extra['title'],
          durationSeconds: extra['durationSeconds'],
          questions: (extra['questions'] as List).cast<Map<String, dynamic>>(),
        );
      },
    ),

    GoRoute(
      path: '/student-quiz-result',
      name: 'studentQuizResult',
      builder: (context, state) {
        final extra = state.extra! as Map<String, dynamic>;
        return StudentQuizResultScreen(
          title: extra['title'],
          points: extra['points'] as int,
          total: extra['total'] as int,
        );
      },
    ),

    GoRoute(
      path: '/student-quiz-details',
      name: 'studentQuizDetails',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;

        return StudentQuizDetailsScreen(
          quizId: extra['quizId'],
          courseId: extra['courseId'],
          title: extra['title'],
          questions: extra['questions'],
          attemptId: extra['attemptId'],
        );
      },
    ),
    GoRoute(
      path: '/achievements/:role',
      name: 'userAchievements',
      builder: (context, state) {
        final role = state.pathParameters['role'] ?? 'student';
        return UserAchievementsScreen(role: role.toLowerCase());
      },
    ),
    GoRoute(
      path: '/user-certificates',
      name: 'userCertificates',
      builder: (context, state) => const UserCertificatesScreen(),
    ),

    GoRoute(
      path: '/user-certificate-preview',
      name: 'userCertificatePreview',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>?;

        return UserCertificatePreviewScreen(
          certName: data?['certName'] ?? '',
          userName: data?['userName'] ?? '',
          role: data?['role'] ?? 'Student',
          issueDate: data?['issueDate'] ?? '',
        );
      },
    ),

    GoRoute(
      name: "studentPurchaseHistory",
      path: "/student-purchase-history",
      builder: (context, state) => const StudentPurchaseHistoryScreen(),
    ),

    GoRoute(
      path: '/practice-quizzes',
      name: 'studentPracticeQuizList',
      builder: (context, state) => const StudentPracticeQuizListScreen(),
    ),

    GoRoute(
      path: '/practice-quiz/instruction',
      name: 'studentPracticeQuizInstruction',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return StudentPracticeQuizInstructionScreen(
          quizId: extra['quizId'] as String,
          title: extra['title'] as String,
          durationSeconds: extra['durationSeconds'] as int,
          questions: (extra['questions'] as List).cast<Map<String, dynamic>>(),
        );
      },
    ),

    GoRoute(
      path: '/practice-quiz/attempt',
      name: 'studentPracticeQuizAttempt',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return StudentPracticeQuizAttemptScreen(
          quizId: extra['quizId'] as String,
          title: extra['title'] as String,
          durationSeconds: extra['durationSeconds'] as int,
          questions: (extra['questions'] as List).cast<Map<String, dynamic>>(),
        );
      },
    ),
    GoRoute(
      path: '/practice-quiz/details',
      name: 'studentPracticeQuizDetails',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;

        return StudentPracticeQuizDetailsScreen(
          quizId: extra['quizId'] as String,
          title: extra['title'] as String,
          questions: (extra['questions'] as List).cast<Map<String, dynamic>>(),
        );
      },
    ),

    GoRoute(
      path: '/student-surprise-quizzes',
      name: 'studentSurpriseQuizList',
      builder: (context, state) {
        return const StudentSurpriseQuizListScreen();
      },
    ),

    GoRoute(
      path: '/student-surprise-quiz-attempt',
      name: 'studentSurpriseQuizAttempt',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;

        return StudentSurpriseQuizAttemptScreen(
          quizId: extra['quizId'] as String,
          title: extra['title'] as String,
          durationSeconds: extra['durationSeconds'] as int,
          questions: List<Map<String, dynamic>>.from(
            extra['questions'] as List,
          ),
        );
      },
    ),

    GoRoute(
      path: '/guest-quiz-warning',
      name: 'guestQuizWarning',
      builder: (context, state) {
        return const GuestQuizWarningScreen();
      },
    ),

    GoRoute(
      path: '/guest-quiz-attempt',
      name: 'guestQuizAttempt',
      builder: (context, state) {
        return const GuestQuizAttemptScreen();
      },
    ),

    GoRoute(
      path: '/guest-quiz-result',
      name: 'guestQuizResult',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;

        return GuestQuizResultScreen(
          correct: data['correct'] as int,
          total: data['total'] as int,
          reason: data['reason'] as String,
        );
      },
    ),

    GoRoute(
      path: '/classroom',
      name: 'classroom',
      builder: (context, state) => const ClassroomScreen(),
    ),

    GoRoute(
      path: '/feedback',
      name: 'feedback',
      builder: (_, __) => const FeedbackScreen(),
    ),

    GoRoute(
      path: '/add-feedback',
      name: 'addFeedback',
      builder: (_, __) => const AddFeedbackScreen(),
    ),

    GoRoute(
      path: '/app-ratings',
      name: 'appRatings',
      builder: (context, state) => const AppRatingsScreen(),
    ),

    GoRoute(
      path: '/add-app-rating',
      name: 'addAppRating',
      builder: (context, state) => const AddAppRatingScreen(),
    ),

    GoRoute(
      path: '/teacher-admin-feedback',
      name: 'teacherAdminFeedback',
      builder: (context, state) => const TeacherAdminFeedbackScreen(),
    ),

    GoRoute(
      path: '/notify-hub',
      name: 'notifyHub',
      builder: (context, state) => const NotifyHubScreen(),
    ),

    GoRoute(
      path: '/add-notice',
      name: 'addNotice',
      builder: (context, state) => const AddNoticeScreen(),
    ),

    GoRoute(
      path: '/edit-notice',
      name: 'editNotice',
      builder:
          (context, state) =>
              EditNoticeScreen(notice: state.extra as Map<String, dynamic>),
    ),

    GoRoute(
      path: '/notice-feed',
      name: 'noticeFeed',
      builder:
          (context, state) => NoticeFeedScreen(role: state.extra as String),
    ),
    GoRoute(
      path: '/planner',
      name: 'planner',
      builder: (context, state) => const PlannerScreen(),
    ),

    GoRoute(path: '/faq', name: 'faq', builder: (_, __) => const FaqScreen()),
  ],
);
