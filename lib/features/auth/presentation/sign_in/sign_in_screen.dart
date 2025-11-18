import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qnect_quiz_crafter/features/auth/presentation/sign_in/widgets/free_trial.dart';
import '../../../../common/widgets/app_loader.dart';
import '../../../../ui/design_system/tokens/colors.dart';
import 'controller/sign_in_controller.dart';
import 'widgets/header.dart';
import 'widgets/email_field.dart';
import 'widgets/password_field.dart';
import 'widgets/remember_forgot_row.dart';
import 'widgets/bottom_row.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  static const _hero = 'assets/images/auth/sign_in.png';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signInControllerProvider);
    final c = ref.read(signInControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SignInHeader(assetPath: _hero),
                const SizedBox(height: 20),
                const EmailField(),
                const SizedBox(height: 14),
                const PasswordField(),
                const SizedBox(height: 10),
                const RememberForgotRow(),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton(
                    onPressed:
                        state.loading ? null : () => c.signInEmail(context),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                const BottomRow(),

                const SizedBox(height: 10),
                const FreeTrial(),
              ],
            ),
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          state.loading
              ? const ColoredBox(
                color: Color(0x66000000),
                child: SizedBox.expand(child: AppLoader(size: 60)),
              )
              : null,
    );
  }
}
