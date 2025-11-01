import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../ui/design_system/tokens/colors.dart';
import '../../../../ui/design_system/tokens/typography.dart';
import 'widgets/set_password_widgets.dart';
import 'controller/set_password_controller.dart';

class SetPasswordScreen extends ConsumerWidget {
  const SetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(setPasswordControllerProvider);
    final controller = ref.read(setPasswordControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const SetPasswordTopImage(),
              const SizedBox(height: 20),

              const Text(
                "Set Password",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontFamily: AppTypography.family,
                ),
              ),
              const SizedBox(height: 10),

              const Text(
                "Protect your account with a strong password. Use\n8+ characters & mix letters/numbers/symbols.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  fontFamily: AppTypography.family,
                ),
              ),
              const SizedBox(height: 30),
              PasswordStrengthIndicator(strength: state.strength),
              const SizedBox(height: 16),

              PasswordField(
                label: "Password",
                onChanged: controller.updatePassword,
                obscure: !state.showPassword,
                toggleObscure: controller.togglePassword,
              ),
              const SizedBox(height: 16),

              PasswordField(
                label: "Confirm Password",
                onChanged: controller.updateConfirmPassword,
                obscure: !state.showConfirmPassword,
                toggleObscure: controller.toggleConfirmPassword,
              ),

              const SizedBox(height: 30),

              SetPasswordButton(
                loading: state.loading,
                onPressed: () => controller.submit(context),
              ),
              const SizedBox(height: 8),

              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (_) => AlertDialog(
                          title: const Text("Skip Password?"),
                          content: const Text(
                            "You must set a password to secure your account.",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                  );
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.white70,
                    fontFamily: AppTypography.family,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
