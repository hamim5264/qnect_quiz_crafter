import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qnect_quiz_crafter/features/auth/presentation/sign_up/widgets/_form_box.dart';
import 'package:qnect_quiz_crafter/features/auth/presentation/sign_up/widgets/_header_text.dart';
import 'package:qnect_quiz_crafter/features/auth/presentation/sign_up/widgets/_numbered_stepper.dart';
import 'package:qnect_quiz_crafter/features/auth/presentation/sign_up/widgets/bottom_row_login_terms.dart';
import 'package:qnect_quiz_crafter/features/auth/presentation/sign_up/widgets/role_tabs.dart';
import '../../../../ui/design_system/tokens/colors.dart';
import 'controller/sign_up_controller.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  final String? email;

  const SignUpScreen({super.key, this.email});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signUpControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.only(bottom: 22),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Column(
                    children: [
                      const HeaderText(),
                      const RoleTabs(),
                      const SizedBox(height: 16),
                      NumberedStepper(currentIndex: state.step),
                      const SizedBox(height: 16),
                      FormBox(controller: _pageController),
                      const SizedBox(height: 16),
                      const BottomRowLoginTerms(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
