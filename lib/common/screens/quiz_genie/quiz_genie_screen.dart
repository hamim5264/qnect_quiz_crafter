import 'package:flutter/material.dart';
import '../../widgets/common_rounded_app_bar.dart';
import '../../../ui/design_system/tokens/colors.dart';
import 'widgets/quiz_genie_body.dart';

class QuizGenieScreen extends StatelessWidget {
  final String creatorRole;

  const QuizGenieScreen({super.key, required this.creatorRole});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      resizeToAvoidBottomInset: true,
      appBar: const CommonRoundedAppBar(title: 'QuizGenie', subtitle: 'Beta'),
      body: SafeArea(child: QuizGenieBody(creatorRole: creatorRole)),
    );
  }
}
