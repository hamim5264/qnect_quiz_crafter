import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

import '../../../providers/auth_providers.dart';
import 'sign_in_state.dart';
import '../../../../../common/widgets/app_toast.dart';

final signInControllerProvider =
    NotifierProvider<SignInController, SignInState>(SignInController.new);

class SignInController extends Notifier<SignInState> {
  @override
  SignInState build() => const SignInState();

  void setEmail(String v) => state = state.copyWith(email: v);

  void setPassword(String v) => state = state.copyWith(password: v);

  void toggleObscure() => state = state.copyWith(obscure: !state.obscure);

  void setRemember(bool v) => state = state.copyWith(remember: v);

  Future<void> signInEmail(BuildContext context) async {
    if (state.loading) return;

    if (state.email.trim().isEmpty || state.password.isEmpty) {
      AppToast.showError(context, "Email & password are required");
      return;
    }

    state = state.copyWith(loading: true);

    final auth = ref.read(authServiceProvider);

    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection("teacher_status_lookup")
              .doc(state.email.trim())
              .get();

      if (snapshot.exists) {
        final lookup = snapshot.data()!;
        final status = lookup["accountStatus"];

        if (status == "pending") {
          if (context.mounted) {
            context.go('/teacher-status', extra: state.email.trim());
          }
          state = state.copyWith(loading: false);
          return;
        }

        if (status == "rejected") {
          if (context.mounted) {
            context.go('/rejected', extra: state.email.trim());
          }
          state = state.copyWith(loading: false);
          return;
        }

        if (status == "blocked") {
          if (context.mounted) {
            context.go('/blocked');
          }
          state = state.copyWith(loading: false);
          return;
        }
      }

      final cred = await auth.signInWithEmail(
        state.email.trim(),
        state.password,
      );

      final uid = cred.user!.uid;

      final userDoc =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();

      if (!userDoc.exists) {
        AppToast.showError(
          context,
          "Your account has been removed. Please contact support.",
        );
        return;
      }

      final data = userDoc.data()!;
      final role = data["role"];
      final status = (data["accountStatus"] ?? "approved") as String;

      if (status == "blocked") {
        if (context.mounted) {
          context.go('/blocked');
        }
        return;
      }

      if (role == "teacher") {
        if (status == "pending") {
          if (context.mounted) {
            context.go('/teacher-status', extra: state.email.trim());
          }
          return;
        }

        if (status == "rejected") {
          if (context.mounted) {
            context.go('/rejected', extra: state.email.trim());
          }
          return;
        }
      }

      if (context.mounted) {
        await showBetaNoticeDialog(context);
        context.go('/');
      }

      if (context.mounted) context.go('/');
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          AppToast.showError(context, "No user found with this email");
          break;
        case 'wrong-password':
          AppToast.showError(context, "Incorrect password");
          break;
        case 'invalid-email':
          AppToast.showError(context, "Invalid email format");
          break;
        default:
          AppToast.showError(context, "Login failed, try again");
      }
    } finally {
      state = state.copyWith(loading: false);
    }
  }
}

Future<void> showBetaNoticeDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Dialog(
          backgroundColor: Colors.white.withValues(alpha: 0.85),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Warm Welcome 👋",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Dear User,\n\n"
                  "Thank you for signing in to QuizCrafter.\n\n"
                  "Please note that this application is currently running in "
                  "beta mode. All payments, purchases, and other financial "
                  "transactions within the app are strictly for testing "
                  "purposes only and do not represent real monetary activity.\n\n"
                  "We truly appreciate your understanding and thank you for "
                  "being part of our early journey.\n\n"
                  "— Team Qnect",
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "I Understand",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
