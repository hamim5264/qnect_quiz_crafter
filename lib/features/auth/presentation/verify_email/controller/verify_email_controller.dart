// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import '../../../../../common/widgets/app_toast.dart';
// import '../../../data/email_otp/email_otp_sender.dart';
//
// final verifyEmailControllerProvider =
// NotifierProvider<VerifyEmailController, VerifyEmailState>(
//   VerifyEmailController.new,
// );
//
// class VerifyEmailState {
//   final String email;
//   final bool isLoading;
//
//   VerifyEmailState({
//     required this.email,
//     required this.isLoading,
//   });
//
//   VerifyEmailState copyWith({
//     String? email,
//     bool? isLoading,
//   }) {
//     return VerifyEmailState(
//       email: email ?? this.email,
//       isLoading: isLoading ?? this.isLoading,
//     );
//   }
// }
//
// class VerifyEmailController extends Notifier<VerifyEmailState> {
//   @override
//   VerifyEmailState build() {
//     return VerifyEmailState(email: '', isLoading: false);
//   }
//
//   void updateEmail(String value) {
//     state = state.copyWith(email: value);
//   }
//
//   Future<void> verifyEmail(BuildContext context) async {
//     final email = state.email.trim();
//
//     if (email.isEmpty) {
//       AppToast.showError(context, "Enter your email first");
//       return;
//     }
//
//     state = state.copyWith(isLoading: true);
//
//     final sent = await EmailOtpSender.sendOtpToEmail(
//       userEmail: email,
//       userName: "User",
//     );
//
//     state = state.copyWith(isLoading: false);
//
//     if (!sent) {
//       AppToast.showError(context, "OTP send failed, try again");
//       return;
//     }
//
//     /// ✅ goto OTP screen with ONLY email
//     context.push('/reset-password', extra: email);
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/app_toast.dart';

final verifyEmailControllerProvider =
    NotifierProvider<VerifyEmailController, VerifyEmailState>(
      VerifyEmailController.new,
    );

class VerifyEmailState {
  final String email;
  final bool isLoading;
  final bool linkSent;

  VerifyEmailState({
    required this.email,
    required this.isLoading,
    required this.linkSent,
  });

  VerifyEmailState copyWith({String? email, bool? isLoading, bool? linkSent}) {
    return VerifyEmailState(
      email: email ?? this.email,
      isLoading: isLoading ?? this.isLoading,
      linkSent: linkSent ?? this.linkSent,
    );
  }
}

class VerifyEmailController extends Notifier<VerifyEmailState> {
  @override
  VerifyEmailState build() {
    return VerifyEmailState(email: '', isLoading: false, linkSent: false);
  }

  void updateEmail(String value) {
    state = state.copyWith(email: value);
  }

  Future<void> verifyEmail(BuildContext context) async {
    final email = state.email.trim();

    if (email.isEmpty) {
      AppToast.showError(context, "Enter your email first");
      return;
    }

    state = state.copyWith(isLoading: true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      AppToast.showSuccess(
        context,
        "Reset link sent! Please check your email.",
      );

      if (context.mounted) {
        Future.delayed(const Duration(seconds: 1), () {
          context.go('/sign-in');
        });
      }
    } catch (e) {
      AppToast.showError(context, "Failed to send reset link. Try again");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void goToSignIn(BuildContext context) {
    state = state.copyWith(linkSent: false, email: '');
    context.go('/sign-in');
  }
}
