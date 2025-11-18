import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import '../../ui/design_system/tokens/colors.dart';
import '../widgets/network_helper.dart';

class StartupGate extends ConsumerStatefulWidget {
  const StartupGate({super.key});

  @override
  ConsumerState<StartupGate> createState() => _StartupGateState();
}

class _StartupGateState extends ConsumerState<StartupGate> {
  @override
  void initState() {
    super.initState();
    _initialize();
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

    if (user.email == "devenginesoftsolution@gmail.com") {
      final adminSnap =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      final adminRole = adminSnap.data()?['role'];
      if (adminRole == "admin") {
        return context.go('/admin-home');
      }
    }

    final snap =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

    if (!mounted) return;

    final role = snap.data()?['role'];

    if (role == 'teacher') {
      return context.go('/teacher-home');
    } else {
      return context.go('/guest_and_student-home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          "Checking connection & preparing your journey...",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
      backgroundColor: AppColors.primaryDark,
    );
  }
}
