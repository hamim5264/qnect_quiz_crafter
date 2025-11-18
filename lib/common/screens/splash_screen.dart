import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../features/auth/providers/auth_providers.dart';
import '../../../ui/design_system/tokens/colors.dart';
import '../../../common/widgets/app_loader.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkInternetAndNavigate();
  }

  Future<bool> _hasInternet() async {
    final connectivity = await Connectivity().checkConnectivity();
    return connectivity != ConnectivityResult.none;
  }

  Future<void> checkInternetAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));

    bool connected = await _hasInternet();
    if (!connected) {
      if (mounted) context.go('/no-internet');
      return;
    }

    final auth = ref.read(firebaseAuthProvider);
    final user = auth.currentUser;

    if (user == null) {
      context.go('/onboarding');
      return;
    }

    if (user.email == "devenginesoftsolution@gmail.com") {
      final doc =
          await ref
              .read(firestoreProvider)
              .collection('users')
              .doc(user.uid)
              .get();

      final role = doc.data()?['role'];
      if (role == "admin") {
        context.go('/admin-home');
        return;
      }
    }

    final doc =
        await ref
            .read(firestoreProvider)
            .collection('users')
            .doc(user.uid)
            .get();

    final role = doc.data()?['role'];

    if (role == 'teacher') {
      context.go('/teacher-home');
    } else if (role == 'student') {
      context.go('/guest_and_student-home');
    } else {
      context.go('/guest_and_student-home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryDark,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            AppLoader(size: 60),
            SizedBox(height: 18),
            Text(
              "Checking your connection\nand preparing your journey...",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
