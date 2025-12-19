import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qnect_quiz_crafter/common/widgets/app_loader.dart';

import '../../../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../../ui/design_system/tokens/typography.dart';

import '../../models/teacher_course_model.dart';
import '../../providers/teacher_course_providers.dart';

import 'widgets/quiz_title_fields.dart';
import 'widgets/quiz_time_picker.dart';
import 'widgets/quiz_icon_picker.dart';
import 'widgets/quiz_question_card.dart';

class TeacherAddQuizScreen extends ConsumerStatefulWidget {
  final TeacherCourseModel course;

  const TeacherAddQuizScreen({super.key, required this.course});

  @override
  ConsumerState<TeacherAddQuizScreen> createState() =>
      _TeacherAddQuizScreenState();
}

class _TeacherAddQuizScreenState extends ConsumerState<TeacherAddQuizScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  Duration _quizTime = const Duration(minutes: 10);

  IconData? _selectedIcon;

  late DateTime _startDate;
  late DateTime _endDate;
  late DateTime allowedStart;
  late DateTime allowedEnd;

  List<Map<String, dynamic>> _questions = [];

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _startDate = widget.course.startDate;
    _endDate = widget.course.endDate;

    allowedStart = widget.course.startDate.add(const Duration(days: 10));
    allowedEnd = widget.course.endDate;

    if (_startDate.isBefore(allowedStart)) {
      _startDate = allowedStart;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final initial = isStart ? _startDate : _endDate;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: isStart ? allowedStart : allowedStart,
      lastDate: allowedEnd,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.secondaryDark,
              surface: AppColors.primaryLight,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;

    setState(() {
      if (isStart) {
        _startDate = picked;

        if (_endDate.isBefore(_startDate)) {
          _endDate = _startDate;
        }
      } else {
        _endDate = picked;
      }
    });
  }

  String _formatShort(DateTime d) =>
      "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year.toString().substring(2)}";

  Future<void> _saveQuiz() async {
    if (_titleCtrl.text.trim().isEmpty) {
      _showError("Please enter quiz name.");
      return;
    }

    if (_selectedIcon == null) {
      _showError("Please select a quiz icon.");
      return;
    }

    if (_questions.isEmpty) {
      _showError("Please add at least one question.");
      return;
    }

    setState(() => _isSaving = true);

    final repo = ref.read(teacherCourseRepositoryProvider);

    await repo.addQuiz(widget.course.id, {
      "title": _titleCtrl.text.trim(),
      "subtitle": _descCtrl.text.trim(),
      "time": _quizTime.inSeconds,

      "icon": _selectedIcon!.codePoint,
      "iconFont": _selectedIcon!.fontFamily,

      "startDate": _startDate.toIso8601String(),
      "endDate": _endDate.toIso8601String(),

      "questions": _questions,
      "createdAt": DateTime.now().toIso8601String(),
    });

    setState(() => _isSaving = false);
    context.pop();
  }

  void _showError(String msg) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: AppColors.primaryLight,
            title: const Text(
              "Warning",
              style: TextStyle(
                fontFamily: AppTypography.family,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              msg,
              style: const TextStyle(fontFamily: AppTypography.family),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: "Add New Quiz"),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              QuizTitleFields(titleCtrl: _titleCtrl, descCtrl: _descCtrl),

              QuizTimePicker(
                duration: _quizTime,
                onChanged: (d) => setState(() => _quizTime = d),
              ),

              QuizIconPicker(
                selectedIcon: _selectedIcon,
                onIconSelected: (icon) {
                  setState(() => _selectedIcon = icon);
                },
              ),

              const SizedBox(height: 6),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _pickDate(isStart: true),
                      child: _dateTile("Starting Date", _startDate),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _pickDate(isStart: false),
                      child: _dateTile("End Date", _endDate),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Container(
                margin: const EdgeInsets.only(bottom: 12),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.warning_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Pick date between ${_formatShort(allowedStart)} - ${_formatShort(allowedEnd)}",
                      style: const TextStyle(
                        fontFamily: AppTypography.family,
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              QuizQuestionCard(
                onQuestionsChanged: (qs) {
                  setState(() => _questions = qs);
                },
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveQuiz,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryLight,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child:
                      _isSaving
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: AppLoader(size: 28),
                          )
                          : const Text(
                            "Save",
                            style: TextStyle(
                              fontFamily: AppTypography.family,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateTile(String label, DateTime value) {
    final text = _formatShort(value);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white54, width: 1.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  fontSize: 12,
                  color: Colors.white60,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                text,
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Icon(
            Icons.calendar_month_rounded,
            color: Colors.white60,
            size: 22,
          ),
        ],
      ),
    );
  }
}
