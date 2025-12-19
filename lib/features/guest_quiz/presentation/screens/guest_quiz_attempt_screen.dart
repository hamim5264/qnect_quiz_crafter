import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import '../../data/guest_quiz_questions.dart';
import '../../widgets/guest_question_card.dart';

class GuestQuizAttemptScreen extends StatefulWidget {
  const GuestQuizAttemptScreen({super.key});

  @override
  State<GuestQuizAttemptScreen> createState() => _GuestQuizAttemptScreenState();
}

class _GuestQuizAttemptScreenState extends State<GuestQuizAttemptScreen> {
  final List<Map<String, Object>> _questions = GuestQuizQuestions.questions;

  late final List<int?> _selected;
  int _currentIndex = 0;

  late int _remainingSeconds;
  Timer? _timer;

  bool _submitting = false;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _selected = List<int?>.filled(_questions.length, null);
    _remainingSeconds = GuestQuizQuestions.durationSeconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_finished) return;

      if (_remainingSeconds <= 0) {
        _finishQuiz(reason: "time_up");
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _timeLabel {
    final m = _remainingSeconds ~/ 60;
    final s = _remainingSeconds % 60;
    return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  Future<void> _finishQuiz({required String reason}) async {
    if (_submitting || _finished) return;

    setState(() => _submitting = true);
    _timer?.cancel();
    _finished = true;

    int correct = 0;

    for (int i = 0; i < _questions.length; i++) {
      final q = _questions[i];
      final correctIndex = (q["correctIndex"] as int);
      final chosen = _selected[i];
      if (chosen != null && chosen == correctIndex) correct++;
    }

    if (!mounted) return;

    context.pushReplacementNamed(
      'guestQuizResult',
      extra: {"correct": correct, "total": _questions.length, "reason": reason},
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = _questions.length;
    final q = _questions[_currentIndex];

    final questionText = (q["question"] as String);
    final optionsDynamic = q["options"];
    final options = Map<String, String>.from(optionsDynamic as Map);

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
                      onTap: () => _finishQuiz(reason: "manual_exit"),
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white24, width: 1),
                        ),
                        child: const Icon(
                          CupertinoIcons.back,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "Guest Quiz",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
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
                            _remainingSeconds <= 60
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
                          const SizedBox(width: 6),
                          Text(
                            _timeLabel,
                            style: TextStyle(
                              fontFamily: AppTypography.family,
                              fontWeight: FontWeight.bold,
                              color:
                                  _remainingSeconds <= 60
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

              const SizedBox(height: 16),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GuestQuestionCard(
                    index: _currentIndex,
                    total: total,
                    questionText: questionText,
                    options: options,
                    selectedIndex: _selected[_currentIndex],
                    onSelect:
                        (i) => setState(() => _selected[_currentIndex] = i),
                  ),
                ),
              ),

              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed:
                            _currentIndex == 0
                                ? null
                                : () => setState(() => _currentIndex--),
                        icon: _navCircle(
                          CupertinoIcons.back,
                          disabled: _currentIndex == 0,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              (_selected[_currentIndex] == null || _submitting)
                                  ? null
                                  : () {
                                    if (_currentIndex < total - 1) {
                                      setState(() => _currentIndex++);
                                    } else {
                                      _finishQuiz(reason: "submitted");
                                    }
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryLight,
                            disabledBackgroundColor: Colors.white12,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            _currentIndex == total - 1 ? "Submit" : "Next",
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
