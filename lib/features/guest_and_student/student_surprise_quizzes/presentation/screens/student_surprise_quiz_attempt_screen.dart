import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:screen_protector/screen_protector.dart';

import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class StudentSurpriseQuizAttemptScreen extends StatefulWidget {
  final String quizId;
  final String title;
  final int durationSeconds;
  final List<Map<String, dynamic>> questions;

  const StudentSurpriseQuizAttemptScreen({
    super.key,
    required this.quizId,
    required this.title,
    required this.durationSeconds,
    required this.questions,
  });

  @override
  State<StudentSurpriseQuizAttemptScreen> createState() =>
      _StudentSurpriseQuizAttemptScreenState();
}

class _StudentSurpriseQuizAttemptScreenState
    extends State<StudentSurpriseQuizAttemptScreen> {
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

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || _finished) return;

      if (remainingSeconds <= 0) {
        _submitQuiz(reason: "time_up");
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

  String get _timeLabel {
    final m = remainingSeconds ~/ 60;
    final s = remainingSeconds % 60;
    return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  Future<void> _submitQuiz({required String reason}) async {
    if (_submitting || _finished) return;

    setState(() => _submitting = true);
    _finished = true;
    _timer?.cancel();

    final uid = FirebaseAuth.instance.currentUser!.uid;

    final attemptRef = FirebaseFirestore.instance
        .collection("surpriseQuizzes")
        .doc(widget.quizId)
        .collection("attempts")
        .doc(uid);

    final alreadyAttempted = await attemptRef.get();
    if (alreadyAttempted.exists) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You already attempted this quiz"),
          backgroundColor: Colors.redAccent,
        ),
      );
      context.pop();
      return;
    }

    int correct = 0;
    for (int i = 0; i < widget.questions.length; i++) {
      final correctIndex = widget.questions[i]["correctIndex"] as int;
      if (selected[i] == correctIndex) correct++;
    }

    await attemptRef.set({
      "quizId": widget.quizId,
      "userId": uid,
      "points": correct,
      "total": widget.questions.length,
      "answers": selected,
      "reason": reason,
      "timestamp": FieldValue.serverTimestamp(),
    });

    if (!mounted) return;

    context.pushReplacementNamed(
      "studentQuizResult",
      extra: {
        "title": widget.title,
        "points": correct,
        "total": widget.questions.length,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[currentIndex];

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: AppColors.primaryDark,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => _submitQuiz(reason: "manual_exit"),
                      child: const Icon(
                        CupertinoIcons.back,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: AppTypography.family,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color:
                            remainingSeconds <= 60
                                ? Colors.redAccent
                                : Colors.white,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: Lottie.asset('assets/icons/quiz_time.json'),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _timeLabel,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  remainingSeconds <= 60
                                      ? Colors.white
                                      : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildQuestionCard(
                    index: currentIndex,
                    question: question,
                  ),
                ),
              ),

              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed:
                            currentIndex == 0
                                ? null
                                : () => setState(() => currentIndex--),
                        icon: _navCircle(
                          CupertinoIcons.back,
                          disabled: currentIndex == 0,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              selected[currentIndex] == null
                                  ? null
                                  : () {
                                    if (currentIndex <
                                        widget.questions.length - 1) {
                                      setState(() => currentIndex++);
                                    } else {
                                      _submitQuiz(reason: "submitted");
                                    }
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryLight,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            currentIndex == widget.questions.length - 1
                                ? "Submit"
                                : "Next",
                            style: const TextStyle(
                              fontFamily: AppTypography.family,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
    final rawOptions = question["options"];
    final labels = ["A", "B", "C", "D"];

    final List<String> options;
    if (rawOptions is Map) {
      options = labels.map((k) => rawOptions[k]?.toString() ?? "").toList();
    } else if (rawOptions is List) {
      options = rawOptions.map((e) => e.toString()).toList();
    } else {
      options = [];
    }

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
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            question["question"],
            style: const TextStyle(
              fontFamily: AppTypography.family,
              fontSize: 16,
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
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? AppColors.secondaryDark.withValues(alpha: 0.25)
                              : const Color(0xFFEDEFF2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color:
                            isSelected
                                ? AppColors.primaryLight
                                : Colors.transparent,
                        width: 1.4,
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
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            options[i],
                            style: const TextStyle(
                              fontFamily: AppTypography.family,
                              fontSize: 15,
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

  Widget _navCircle(IconData icon, {bool disabled = false}) {
    return Container(
      height: 42,
      width: 42,
      decoration: BoxDecoration(
        color: disabled ? Colors.white24 : AppColors.primaryLight,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: disabled ? Colors.white24 : Colors.white),
    );
  }
}
