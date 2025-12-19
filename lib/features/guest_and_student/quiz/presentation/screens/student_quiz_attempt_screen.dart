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

class StudentQuizAttemptScreen extends StatefulWidget {
  final String quizId;
  final String courseId;
  final String title;
  final int durationSeconds;
  final List<Map<String, dynamic>> questions;

  const StudentQuizAttemptScreen({
    super.key,
    required this.quizId,
    required this.courseId,
    required this.title,
    required this.durationSeconds,
    required this.questions,
  });

  @override
  State<StudentQuizAttemptScreen> createState() =>
      _StudentQuizAttemptScreenState();
}

class _StudentQuizAttemptScreenState extends State<StudentQuizAttemptScreen> {
  late List<String?> selected;
  int currentIndex = 0;
  late int remainingSeconds;
  Timer? _timer;
  bool _submitting = false;
  bool _finished = false;

  @override
  @override
  @override
  void initState() {
    super.initState();

    selected = List<String?>.filled(widget.questions.length, null);
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
      message: "If you go back now, your current answers will be submitted.",
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
    setState(() {
      _submitting = true;
    });

    _timer?.cancel();
    _finished = true;

    final questions = widget.questions;
    int correctCount = 0;

    for (int i = 0; i < questions.length; i++) {
      final q = questions[i];
      final correct = (q["correct"] ?? "").toString().toUpperCase();
      if (selected[i] != null &&
          selected[i]!.toUpperCase() == correct &&
          selected[i]!.isNotEmpty) {
        correctCount++;
      }
    }

    final totalQuestions = questions.length;
    final points = correctCount;

    try {
      final attemptsRef =
          FirebaseFirestore.instance
              .collection("courses")
              .doc(widget.courseId)
              .collection("quizzes")
              .doc(widget.quizId)
              .collection("attempts")
              .doc();

      await attemptsRef.set({
        "quizId": widget.quizId,
        "courseId": widget.courseId,
        "userId": FirebaseAuth.instance.currentUser!.uid,
        "points": points,
        "total": totalQuestions,
        "answers": selected,
        "timestamp": FieldValue.serverTimestamp(),
        "reason": reason,
      });

      final courseProgressRef = FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("myCourses")
          .doc(widget.courseId);

      await courseProgressRef.set({
        "earnedPoints_${widget.quizId}": points,
        "completedQuizzes": FieldValue.increment(1),
        "totalQuizzes": widget.questions.length,
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint("Error saving quiz result: $e");
    }

    if (!mounted) return;
    context.pushReplacementNamed(
      "studentQuizResult",
      extra: {"title": widget.title, "points": points, "total": totalQuestions},
    );
  }

  String get _timeLabel {
    final m = remainingSeconds ~/ 60;
    final s = remainingSeconds % 60;
    final mm = m.toString().padLeft(2, '0');
    final ss = s.toString().padLeft(2, '0');
    return "$mm:$ss";
  }

  bool get _allAnswered =>
      selected.every((value) => value != null && value.isNotEmpty);

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
    final questions = widget.questions;
    final total = questions.length;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColors.primaryDark,
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (_finished) {
                              Navigator.pop(context);
                            } else {
                              final ok = await _onWillPop();
                              if (ok && mounted) Navigator.pop(context);
                            }
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: AppColors.secondaryDark,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white30,
                                width: 1,
                              ),
                            ),
                            child: const Icon(
                              CupertinoIcons.back,
                              color: Colors.black,
                              size: 28,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            widget.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: AppTypography.family,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
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
                      ],
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
                          onTap: () {
                            setState(() => currentIndex = index);
                          },
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
                        question: questions[currentIndex],
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                    decoration: BoxDecoration(color: AppColors.primaryDark),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed:
                              currentIndex == 0
                                  ? null
                                  : () {
                                    setState(() {
                                      currentIndex--;
                                    });
                                  },
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
                                  currentIndex == 0
                                      ? Colors.black12
                                      : Colors.black,
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
                                color:
                                    _allAnswered
                                        ? Colors.white
                                        : Colors.white60,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 6),

                        IconButton(
                          onPressed:
                              currentIndex == total - 1
                                  ? null
                                  : () {
                                    setState(() {
                                      currentIndex++;
                                    });
                                  },
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
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard({
    required int index,
    required Map<String, dynamic> question,
  }) {
    final options = (question["options"] as Map).cast<String, dynamic>();
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
              itemCount: labels.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final label = labels[i];
                final text = (options[label] ?? "").toString();
                final isSelected = selected[index] == label;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selected[index] = label;
                    });
                  },
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
                            label,
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
                            text.toString().toUpperCase(),
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
