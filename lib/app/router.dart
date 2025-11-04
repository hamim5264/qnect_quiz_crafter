import 'package:go_router/go_router.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/dashboard/admin_dashboard_home_screen.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/guest_home_screen.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/teacher_home_screen.dart';
import 'package:qnect_quiz_crafter/features/auth/presentation/verification/verify_otp_screen.dart';

import '../common/gates/startup_gate.dart';
import '../common/screens/guidelines_screen.dart';
import '../common/screens/need_help_screen.dart';
import '../common/screens/no_internet_screen.dart';
import '../features/admin/presentation/manage_users/manage_users_screen.dart';
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
      builder: (_, __) => const NeedHelpScreen(),
    ),
    GoRoute(
      path: '/guidelines',
      name: 'guidelines',
      builder: (_, __) => const GuidelinesScreen(),
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
  ],
);
