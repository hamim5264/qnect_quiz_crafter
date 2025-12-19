import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import '../../ui/design_system/tokens/colors.dart';
import '../widgets/network_helper.dart';
import 'dart:async';
import 'package:lottie/lottie.dart';

class StartupGate extends ConsumerStatefulWidget {
  const StartupGate({super.key});

  @override
  ConsumerState<StartupGate> createState() => _StartupGateState();
}

class _StartupGateState extends ConsumerState<StartupGate> {
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
    _initialize();
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

  Future<void> _initialize() async {
    await Future.delayed(const Duration(milliseconds: 600));

    final hasNet = await NetworkHelper.hasInternet();
    if (!mounted) return;

    if (!hasNet) {
      return context.go('/no-internet');
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return context.go('/onboarding');
    }

    final snap =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

    if (!mounted) return;

    if (!snap.exists) {
      FirebaseAuth.instance.signOut();
      return context.go('/sign-in');
    }

    final data = snap.data()!;
    final role = data['role'];
    final status = data['accountStatus'] ?? "approved";

    if (user.email == "devenginesoftsolution@gmail.com" && role == "admin") {
      return context.go('/admin-home');
    }

    if (role == "teacher") {
      if (status == "pending") {
        return context.go('/teacher-status', extra: user.email);
      }

      if (status == "rejected") {
        return context.go('/rejected', extra: user.email);
      }

      if (status == "blocked") {
        return context.go('/blocked');
      }

      if (status == "approved") {
        return context.go('/teacher-home');
      }
    }

    if (role == "student") {
      return context.go('/guest_and_student-home');
    }

    return context.go('/sign-in');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/walk.json',
              height: 180,
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
      backgroundColor: AppColors.primaryDark,
    );
  }
}
