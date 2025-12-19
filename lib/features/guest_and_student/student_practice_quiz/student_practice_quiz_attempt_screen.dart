import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:screen_protector/screen_protector.dart';

import '../../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class StudentPracticeQuizAttemptScreen extends StatefulWidget {
  final String quizId;
  final String title;
  final int durationSeconds;
  final List<Map<String, dynamic>> questions;

  const StudentPracticeQuizAttemptScreen({
    super.key,
    required this.quizId,
    required this.title,
    required this.durationSeconds,
    required this.questions,
  });

  @override
  State<StudentPracticeQuizAttemptScreen> createState() =>
      _StudentPracticeQuizAttemptScreenState();
}

class _StudentPracticeQuizAttemptScreenState
    extends State<StudentPracticeQuizAttemptScreen> {
  late List<int?> selected;
  int currentIndex = 0;
  late int remainingSeconds;
  Timer? _timer;
  bool _submitting = false;
  bool _finished = false;

  @override
  void initState() {
    super.initState();

    selected = List<int?>.filled(widget.questions.length, null);
    remainingSeconds = widget.durationSeconds;

    ScreenProtector.preventScreenshotOn();

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (remainingSeconds <= 0) {
        _onTimeUp();
      } else {
        setState(() => remainingSeconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    ScreenProtector.preventScreenshotOff();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (_finished) return true;

    final shouldLeave = await _showConfirmDialog(
      title: "Exit Quiz?",
      message:
          "If you go back now, your current answers will be submitted as final.",
    );

    if (shouldLeave == true) {
      _submitQuiz(reason: "manual_exit");
      return false;
    }
    return false;
  }

  void _onTimeUp() {
    if (_finished) return;
    _submitQuiz(reason: "time_up");
  }

  Future<void> _submitQuiz({String reason = "submit"}) async {
    if (_submitting || _finished) return;

    setState(() => _submitting = true);
    _timer?.cancel();
    _finished = true;

    int correctCount = 0;
    for (int i = 0; i < widget.questions.length; i++) {
      final correctIndex = (widget.questions[i]["correctIndex"] ?? 0) as int;
      if (selected[i] == correctIndex) {
        correctCount++;
      }
    }

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection("practice_quizzes")
          .doc(widget.quizId)
          .collection("attempts")
          .doc(uid)
          .set({
            "quizId": widget.quizId,
            "userId": uid,
            "points": correctCount,
            "total": widget.questions.length,
            "answers": selected,
            "timestamp": FieldValue.serverTimestamp(),
            "reason": reason,
          });
    } catch (e) {
      debugPrint("Error saving practice quiz result: $e");
    }

    if (!mounted) return;

    context.pushReplacementNamed(
      "studentQuizResult",
      extra: {
        "title": widget.title,
        "points": correctCount,
        "total": widget.questions.length,
      },
    );
  }

  String get _timeLabel {
    final m = remainingSeconds ~/ 60;
    final s = remainingSeconds % 60;
    return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  bool get _allAnswered => selected.every((v) => v != null);

  Future<bool?> _showConfirmDialog({
    required String title,
    required String message,
  }) {
    return showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(
              title,
              style: const TextStyle(
                fontFamily: AppTypography.family,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              message,
              style: const TextStyle(fontFamily: AppTypography.family),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  "Yes",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.questions.length;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColors.primaryDark,

        appBar: CommonRoundedAppBar(
          title: widget.title,
          ellipsis: true,
          titleSize: 18,
          onBack: () async {
            if (_finished) {
              Navigator.pop(context);
            } else {
              final ok = await _onWillPop();
              if (ok && mounted) Navigator.pop(context);
            }
          },
        ),

        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color:
                          remainingSeconds <= 60
                              ? Colors.redAccent
                              : AppColors.white,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 28,
                          width: 28,
                          child: Lottie.asset(
                            'assets/icons/quiz_time.json',
                            repeat: true,
                            animate: true,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _timeLabel,
                          style: TextStyle(
                            fontFamily: AppTypography.family,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color:
                                remainingSeconds <= 60
                                    ? Colors.white
                                    : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              SizedBox(
                height: 40,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: total,
                  separatorBuilder: (_, __) => const SizedBox(width: 6),
                  itemBuilder: (_, index) {
                    final isCurrent = index == currentIndex;
                    final answered = selected[index] != null;

                    Color bg;
                    Color textColor;

                    if (isCurrent) {
                      bg = AppColors.secondaryDark;
                      textColor = Colors.black;
                    } else if (answered) {
                      bg = AppColors.chip3;
                      textColor = Colors.white;
                    } else {
                      bg = Colors.white24;
                      textColor = Colors.white70;
                    }

                    return GestureDetector(
                      onTap: () => setState(() => currentIndex = index),
                      child: Container(
                        width: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          (index + 1).toString().padLeft(2, '0'),
                          style: TextStyle(
                            fontFamily: AppTypography.family,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildQuestionCard(
                    index: currentIndex,
                    question: widget.questions[currentIndex],
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                color: AppColors.primaryDark,
                child: Row(
                  children: [
                    IconButton(
                      onPressed:
                          currentIndex == 0
                              ? null
                              : () => setState(() => currentIndex--),
                      icon: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryDark,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          CupertinoIcons.back,
                          color:
                              currentIndex == 0 ? Colors.black12 : Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _allAnswered
                                  ? AppColors.primaryLight
                                  : Colors.grey.shade500,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: const BorderSide(
                              color: Colors.white24,
                              width: 1.2,
                            ),
                          ),
                        ),
                        onPressed:
                            !_allAnswered || _submitting
                                ? null
                                : () async {
                                  final ok = await _showConfirmDialog(
                                    title: "Submit Quiz?",
                                    message:
                                        "Are you sure you want to submit your answers?",
                                  );
                                  if (ok == true) {
                                    _submitQuiz(reason: "submitted");
                                  }
                                },
                        child: Text(
                          "Submit Answer",
                          style: TextStyle(
                            fontFamily: AppTypography.family,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: _allAnswered ? Colors.white : Colors.white60,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    IconButton(
                      onPressed:
                          currentIndex == total - 1
                              ? null
                              : () => setState(() => currentIndex++),
                      icon: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          CupertinoIcons.forward,
                          color:
                              currentIndex == total - 1
                                  ? Colors.white24
                                  : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard({
    required int index,
    required Map<String, dynamic> question,
  }) {
    final options =
        (question["options"] as List).map((e) => e.toString()).toList();
    final labels = ["A", "B", "C", "D"];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Question ${index + 1}",
            style: const TextStyle(
              fontFamily: AppTypography.family,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            question["question"] ?? "",
            style: const TextStyle(
              fontFamily: AppTypography.family,
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: options.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final isSelected = selected[index] == i;

                return GestureDetector(
                  onTap: () => setState(() => selected[index] = i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? AppColors.chip2.withValues(alpha: 0.4)
                              : const Color(0xFFF4F5F7),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color:
                            isSelected
                                ? AppColors.primaryLight
                                : Colors.transparent,
                        width: 1.6,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 32,
                          width: 32,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? AppColors.primaryLight
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            labels[i],
                            style: TextStyle(
                              fontFamily: AppTypography.family,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            options[i],
                            style: const TextStyle(
                              fontFamily: AppTypography.family,
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
