import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class StudentQuizResultScreen extends StatelessWidget {
  final String title;
  final int points;
  final int total;

  const StudentQuizResultScreen({
    super.key,
    required this.title,
    required this.points,
    required this.total,
  });

  /// Get the logged-in user's first name
  Future<String> _getUserName() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snap =
    await FirebaseFirestore.instance.collection("users").doc(uid).get();

    return (snap.data()?["firstName"] ?? "Student") as String;
  }

  @override
  Widget build(BuildContext context) {
    final double percentage = total == 0 ? 0 : (points / total) * 100;

    // Animation & Message Logic
    String message;
    String subMessage;
    String animationAsset;

    if (percentage < 40) {
      message = "Don't Give Up!";
      subMessage = "Keep practicing, you’ll improve!";
      animationAsset = "assets/animations/sad.json"; // change to your sad animation
    } else if (percentage < 70) {
      message = "Good Effort!";
      subMessage = "You're improving — keep going!";
      animationAsset = "assets/animations/improvement.json"; // change to your medium animation
    } else {
      message = "Excellent!";
      subMessage = "Outstanding performance!";
      animationAsset = "assets/animations/win.json"; // change to your happy animation
    }

    return FutureBuilder<String>(
      future: _getUserName(),
      builder: (context, snapshot) {
        final userName = snapshot.data ?? "Student";

        return Scaffold(
          backgroundColor: AppColors.primaryDark,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  // Title
                  const Text(
                    "Quiz Result",
                    style: TextStyle(
                      fontFamily: AppTypography.family,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Lottie Animation (Full Screen Top)
                  SizedBox(
                    height: 220,
                    child: Lottie.asset(animationAsset, repeat: true),
                  ),

                  const SizedBox(height: 10),

                  // Congratulations Text
                  Text(
                    "$message, $userName!",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Points Display
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        points.toString(),
                        style: const TextStyle(
                          fontFamily: AppTypography.family,
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          color: AppColors.secondaryDark,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        "/",
                        style: TextStyle(
                          fontFamily: AppTypography.family,
                          fontSize: 22,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        total.toString(),
                        style: const TextStyle(
                          fontFamily: AppTypography.family,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        "Points",
                        style: TextStyle(
                          fontFamily: AppTypography.family,
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Go to Dashboard Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryDark,
                        padding: const EdgeInsets.symmetric(
                          vertical: 13,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                      ),
                      onPressed: () {
                        context.goNamed("guestHome"); // Update route
                      },
                      child: const Text(
                        "Back to Dashboard",
                        style: TextStyle(
                          fontFamily: AppTypography.family,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
