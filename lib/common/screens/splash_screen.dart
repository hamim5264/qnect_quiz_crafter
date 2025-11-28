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
      if (mounted) context.go('/onboarding');
      return;
    }

    final firestore = ref.read(firestoreProvider);

    if (user.email == "devenginesoftsolution@gmail.com") {
      final adminDoc = await firestore.collection("users").doc(user.uid).get();
      if (adminDoc.data()?['role'] == "admin") {
        if (mounted) context.go('/admin-home');
        return;
      }
    }

    final snap = await firestore.collection("users").doc(user.uid).get();
    final data = snap.data();

    if (data == null) {
      await auth.signOut();
      if (mounted) context.go('/sign-in');
      return;
    }

    final role = data['role'];
    final status = data['accountStatus'] ?? "approved";

    if (role == "teacher") {
      if (status == "pending") {
        if (mounted) {
          context.go('/teacher-status', extra: data['email']);
        }
        return;
      }

      if (status == "rejected") {
        if (mounted) {
          context.go('/rejected', extra: data['email']);
        }
        return;
      }

      if (status == "blocked") {
        if (mounted) context.go('/blocked');
        return;
      }

      if (status == "approved") {
        if (mounted) context.go('/teacher-home');
        return;
      }
    }

    if (role == "student") {
      if (mounted) context.go('/guest_and_student-home');
      return;
    }

    if (mounted) context.go('/sign-in');
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
