import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:qnect_quiz_crafter/common/widgets/app_toast.dart';
import '../../../providers/auth_providers.dart';
import 'sign_in_state.dart';

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
      await auth.signInWithEmail(state.email.trim(), state.password);

      AppToast.showSuccess(context, "Welcome back!");

      if (context.mounted) {
        context.go('/');
      }
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
