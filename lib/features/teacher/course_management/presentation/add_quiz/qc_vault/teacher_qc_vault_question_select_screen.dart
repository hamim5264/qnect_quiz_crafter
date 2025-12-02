import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qnect_quiz_crafter/common/widgets/app_loader.dart';

import 'package:qnect_quiz_crafter/common/widgets/common_rounded_app_bar.dart';
import 'package:qnect_quiz_crafter/ui/design_system/tokens/colors.dart';
import 'package:qnect_quiz_crafter/ui/design_system/tokens/typography.dart';

import '../../../../../../common/screens/qc_vault/controller/qc_vault_controller.dart';
import '../../../../../../common/screens/qc_vault/data/qc_vault_models.dart';


class TeacherQCVaultQuestionSelectScreen extends ConsumerStatefulWidget {
  final QCVaultCourse course;

  const TeacherQCVaultQuestionSelectScreen({
    super.key,
    required this.course,
  });

  @override
  ConsumerState<TeacherQCVaultQuestionSelectScreen> createState() =>
      _TeacherQCVaultQuestionSelectScreenState();
}

class _TeacherQCVaultQuestionSelectScreenState
    extends ConsumerState<TeacherQCVaultQuestionSelectScreen> {
  /// Store question indices that are selected
  final Set<int> _selectedIndexes = {};

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndexes.contains(index)) {
        _selectedIndexes.remove(index);
      } else {
        _selectedIndexes.add(index);
      }
    });
  }

  void _importSelected(List<QCVaultQuestion> allQuestions) {
    if (_selectedIndexes.isEmpty) return;

    final selectedMaps = <Map<String, dynamic>>[];

    for (final q in allQuestions) {
      if (_selectedIndexes.contains(q.index)) {
        selectedMaps.add({
          'question': q.question,
          'options': q.options, // already {A,B,C,D}
          'correct': q.correctOption,
          'explanation': q.explanation,
        });
      }
    }

    context.pop(selectedMaps);
  }

  @override
  Widget build(BuildContext context) {
    final questionsAsync =
    ref.watch(qcVaultQuestionsProvider(widget.course.id));

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: CommonRoundedAppBar(
        title: widget.course.title,
        titleSize: 14,
        subtitle:
        'Select questions to import (${widget.course.group} • ${widget.course.level})',
        maxLines: 2,
        ellipsis: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: questionsAsync.when(
            loading: () => const Center(
              child: AppLoader(size: 32,),
            ),
            error: (e, _) => Center(
              child: Text(
                'Failed to load questions\n$e',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  color: Colors.white70,
                ),
              ),
            ),
            data: (questions) {
              if (questions.isEmpty) {
                return const Center(
                  child: Text(
                    'No questions found in this QC course.',
                    style: TextStyle(
                      fontFamily: AppTypography.family,
                      color: Colors.white70,
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: questions.length,
                      separatorBuilder: (_, __) =>
                      const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final q = questions[index];
                        final selected = _selectedIndexes.contains(q.index);
                        return _QuestionTile(
                          question: q,
                          selected: selected,
                          onTap: () => _toggleSelection(q.index),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  SafeArea(
                    top: false,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _selectedIndexes.isEmpty
                            ? null
                            : () => _importSelected(questions),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryDark,
                          padding:
                          const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          _selectedIndexes.isEmpty
                              ? 'Select questions to import'
                              : 'Import ${_selectedIndexes.length} Questions',
                          style: const TextStyle(
                            fontFamily: AppTypography.family,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _QuestionTile extends StatelessWidget {
  final QCVaultQuestion question;
  final bool selected;
  final VoidCallback onTap;

  const _QuestionTile({
    required this.question,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final options = question.options;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.secondaryDark.withOpacity(0.15)
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.secondaryDark : Colors.transparent,
            width: 1.4,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOP ROW: checkbox + question
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected
                          ? AppColors.secondaryDark
                          : Colors.black26,
                      width: 2,
                    ),
                    color: selected
                        ? AppColors.secondaryDark
                        : Colors.transparent,
                  ),
                  child: selected
                      ? const Icon(
                    Icons.check,
                    size: 14,
                    color: Colors.black,
                  )
                      : null,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    question.question,
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // OPTIONS
            ...['A', 'B', 'C', 'D'].map((key) {
              final text = options[key] ?? '';
              final isCorrect = question.correctOption == key;
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$key)',
                      style: TextStyle(
                        fontFamily: AppTypography.family,
                        fontWeight:
                        isCorrect ? FontWeight.bold : FontWeight.w500,
                        color: isCorrect
                            ? AppColors.chip3
                            : Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        text,
                        style: TextStyle(
                          fontFamily: AppTypography.family,
                          fontSize: 13,
                          color: isCorrect
                              ? AppColors.chip3
                              : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),

            if (question.explanation.trim().isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                'Explanation: ${question.explanation}',
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
