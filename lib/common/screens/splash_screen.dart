import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../features/auth/providers/auth_providers.dart';
import '../../../ui/design_system/tokens/colors.dart';
import 'dart:async';
import 'package:lottie/lottie.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  final List<String> _messages = [
    "Getting things ready for you…",
    "Warming up the experience…",
    "Almost there, hang tight…",
    "Preparing your learning journey…",
    "Just a moment more…",
  ];

  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startMessageRotation();
    checkInternetAndNavigate();
  }

  void _startMessageRotation() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _currentIndex = (_currentIndex + 1) % _messages.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
          children: [
            Lottie.asset(
              'assets/animations/walk.json',
              height: 140,
              repeat: true,
            ),
            const SizedBox(height: 20),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Text(
                _messages[_currentIndex],
                key: ValueKey(_currentIndex),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
