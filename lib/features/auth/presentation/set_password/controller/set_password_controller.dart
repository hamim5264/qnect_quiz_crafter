import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/app_toast.dart';
import '../../../providers/temp_auth_providers.dart';

final setPasswordControllerProvider =
    NotifierProvider<SetPasswordController, SetPasswordState>(
      SetPasswordController.new,
    );

class SetPasswordState {
  final String password;
  final String confirmPassword;
  final bool showPassword;
  final bool showConfirmPassword;
  final double strength;
  final bool loading;

  SetPasswordState({
    required this.password,
    required this.confirmPassword,
    required this.showPassword,
    required this.showConfirmPassword,
    required this.strength,
    required this.loading,
  });

  SetPasswordState copyWith({
    String? password,
    String? confirmPassword,
    bool? showPassword,
    bool? showConfirmPassword,
    double? strength,
    bool? loading,
  }) {
    return SetPasswordState(
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      showPassword: showPassword ?? this.showPassword,
      showConfirmPassword: showConfirmPassword ?? this.showConfirmPassword,
      strength: strength ?? this.strength,
      loading: loading ?? this.loading,
    );
  }
}

class SetPasswordController extends Notifier<SetPasswordState> {
  @override
  SetPasswordState build() {
    return SetPasswordState(
      password: '',
      confirmPassword: '',
      showPassword: false,
      showConfirmPassword: false,
      strength: 0,
      loading: false,
    );
  }

  void updatePassword(String value) {
    state = state.copyWith(password: value, strength: _strength(value));
  }

  void updateConfirmPassword(String value) {
    state = state.copyWith(confirmPassword: value);
  }

  void togglePassword() {
    state = state.copyWith(showPassword: !state.showPassword);
  }

  void toggleConfirmPassword() {
    state = state.copyWith(showConfirmPassword: !state.showConfirmPassword);
  }

  double _strength(String p) {
    double s = 0;
    if (p.length >= 8) s += 0.25;
    if (RegExp(r'[A-Z]').hasMatch(p)) s += 0.25;
    if (RegExp(r'[0-9]').hasMatch(p)) s += 0.25;
    if (RegExp(r'[!@#\$&*~_\-.,]').hasMatch(p)) s += 0.25;
    return s;
  }

  Future<void> submit(BuildContext context) async {
    if (state.password.length < 8) {
      AppToast.showError(context, "Password must be at least 8 characters");
      return;
    }

    if (state.password != state.confirmPassword) {
      AppToast.showError(context, "Passwords do not match");
      return;
    }

    state = state.copyWith(loading: true);

    try {
      final tempEmail = ref.read(tempEmailProvider);
      const tempPass = "temp@123456";

      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: tempEmail!,
        password: tempPass,
      );

      final user = cred.user;

      if (user == null) {
        AppToast.showError(context, "Session expired. Please login again.");
        context.go('/sign-in');
        return;
      }

      await user.updatePassword(state.password);

      AppToast.showSuccess(context, "Password set successfully!");

      ref.read(tempEmailProvider.notifier).state = null;

      if (context.mounted) context.go('/sign-in');
    } catch (e) {
      AppToast.showError(context, "Error: Failed to set password.");
    } finally {
      state = state.copyWith(loading: false);
    }
  }
}
