import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qnect_quiz_crafter/common/widgets/app_loader.dart';
import '../../../ui/design_system/tokens/colors.dart';
import '../../../ui/design_system/tokens/typography.dart';
import '../../../common/widgets/common_rounded_app_bar.dart';
import '../../widgets/success_failure_dialog.dart';
import 'controller/qc_vault_controller.dart';

class QCVaultAddQuestionScreen extends ConsumerStatefulWidget {
  final String courseId;
  final String courseTitle;

  const QCVaultAddQuestionScreen({
    super.key,
    required this.courseId,
    required this.courseTitle,
  });

  @override
  ConsumerState<QCVaultAddQuestionScreen> createState() =>
      _QCVaultAddQuestionScreenState();
}

class _QCVaultAddQuestionScreenState
    extends ConsumerState<QCVaultAddQuestionScreen> {
  final questionController = TextEditingController();
  final descriptionController = TextEditingController();

  final List<TextEditingController> options = List.generate(
    4,
    (_) => TextEditingController(),
  );

  String correctAnswer = "A";
  bool canSave = false;

  @override
  void initState() {
    super.initState();
  }

  void validate() {
    setState(() {
      canSave =
          questionController.text.trim().isNotEmpty &&
          descriptionController.text.trim().isNotEmpty &&
          options.every((o) => o.text.trim().isNotEmpty);
    });
  }

  @override
  void dispose() {
    questionController.dispose();
    descriptionController.dispose();
    for (final c in options) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!canSave) {
      showDialog(
        context: context,
        builder:
            (_) => SuccessFailureDialog(
              icon: Icons.info,
              title: "Missing Fields",
              subtitle: "Please fill question, all options and explanation.",
              buttonText: "Okay",
              onPressed: () => Navigator.pop(context),
            ),
      );
      return;
    }

    final controller = ref.read(qcVaultAddControllerProvider.notifier);

    final optionsMap = {
      'A': options[0].text.trim(),
      'B': options[1].text.trim(),
      'C': options[2].text.trim(),
      'D': options[3].text.trim(),
    };

    await controller.addQuestion(
      courseId: widget.courseId,
      question: questionController.text.trim(),
      options: optionsMap,
      correctOption: correctAnswer,
      explanation: descriptionController.text.trim(),
    );

    final state = ref.read(qcVaultAddControllerProvider);

    if (state.errorMessage != null) {
      questionController.clear();
      descriptionController.clear();
      for (final o in options) {
        o.clear();
      }
      setState(() {
        correctAnswer = "A";
        canSave = false;
      });

      showDialog(
        context: context,
        builder:
            (_) => SuccessFailureDialog(
              icon: CupertinoIcons.clear_circled,
              title: "Duplicate Found",
              subtitle: "This question already exists. Please add a new one.",
              buttonText: "Okay",
              onPressed: () => Navigator.pop(context),
            ),
      );

      return;
    }

    if (state.success) {
      questionController.clear();
      descriptionController.clear();
      for (final o in options) {
        o.clear();
      }
      setState(() {
        correctAnswer = "A";
        canSave = false;
      });

      showDialog(
        context: context,
        builder:
            (_) => SuccessFailureDialog(
              icon: Icons.check_circle_rounded,
              title: "Added Successfully",
              subtitle: "Your question has been added to the vault.",
              buttonText: "Great!",
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final addState = ref.watch(qcVaultAddControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: CommonRoundedAppBar(
        title: widget.courseTitle,
        ellipsis: false,
        maxLines: 2,
        titleSize: 18,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _textField(
              label: "Question",
              controller: questionController,
              maxLines: 4,
              onChanged: (_) => validate(),
            ),
            const SizedBox(height: 10),

            ...List.generate(4, (i) {
              final label = String.fromCharCode(65 + i);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color:
                            correctAnswer == label
                                ? AppColors.chip2
                                : Colors.white24,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppTypography.family,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _textField(
                        label: "Option $label",
                        controller: options[i],
                        onChanged: (_) => validate(),
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 6),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white30),
              ),
              child: Row(
                children: [
                  const Text(
                    "Correct Answer:",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: AppTypography.family,
                    ),
                  ),
                  const Spacer(),
                  DropdownButton<String>(
                    value: correctAnswer,
                    dropdownColor: AppColors.primaryLight,
                    underline: const SizedBox(),
                    icon: const Icon(
                      CupertinoIcons.chevron_down,
                      color: Colors.white,
                    ),
                    items: const [
                      DropdownMenuItem(value: "A", child: Text("A")),
                      DropdownMenuItem(value: "B", child: Text("B")),
                      DropdownMenuItem(value: "C", child: Text("C")),
                      DropdownMenuItem(value: "D", child: Text("D")),
                    ],
                    onChanged: (v) => setState(() => correctAnswer = v!),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _textField(
              label: "Explanation / Description",
              controller: descriptionController,
              maxLines: 3,
              onChanged: (_) => validate(),
            ),

            const SizedBox(height: 22),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canSave && !addState.isSaving ? _handleSave : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryDark,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child:
                    addState.isSaving
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: AppLoader(size: 20),
                        )
                        : const Text(
                          "Add Question",
                          style: TextStyle(
                            fontFamily: AppTypography.family,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.08),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white38),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white24),
        ),
      ),
    );
  }
}
