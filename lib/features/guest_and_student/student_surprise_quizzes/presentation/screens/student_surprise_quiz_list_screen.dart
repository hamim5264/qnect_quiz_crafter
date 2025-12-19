import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../data/providers/student_surprise_quiz_attempt_status_provider.dart';
import '../../data/providers/student_surprise_quiz_provider.dart';
import '../../widgets/student_surprise_quiz_card.dart';

class StudentSurpriseQuizListScreen extends ConsumerWidget {
  const StudentSurpriseQuizListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncQuizzes = ref.watch(studentSurpriseQuizListProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: "Surprise Quizzes"),
      body: asyncQuizzes.when(
        loading:
            () => const Center(
              child: CupertinoActivityIndicator(
                color: AppColors.secondaryDark,
                radius: 14,
              ),
            ),
        error:
            (e, _) => Center(
              child: Text(
                e.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
        data: (docs) {
          if (docs.isEmpty) {
            return const Center(
              child: Text(
                "No surprise quizzes available",
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final d = docs[i].data() as Map<String, dynamic>;

              final publishedAt = (d['publishedAt'] as Timestamp).toDate();
              final hours = d['visibilityHours'] ?? 24;
              final expiry = publishedAt.add(Duration(hours: hours));
              final expired = DateTime.now().isAfter(expiry);

              final remaining = expiry.difference(DateTime.now());
              final visibilityText =
                  expired
                      ? "Expired"
                      : "Visibility: ${remaining.inHours}h ${remaining.inMinutes % 60}m left";

              final quizId = docs[i].id;

              return Consumer(
                builder: (context, ref, _) {
                  final attemptedAsync = ref.watch(
                    surpriseQuizAttemptedProvider(quizId),
                  );

                  return attemptedAsync.when(
                    loading:
                        () => StudentSurpriseQuizCard(
                          title: d['title'] ?? "Surprise Quiz",
                          description: d['description'] ?? "",
                          duration: d['durationSeconds'] ?? 600,
                          points: d['points'] ?? 0,
                          expired: true,
                          visibilityText: "Checking...",
                          onAttempt: null,
                        ),

                    error: (_, __) => const SizedBox.shrink(),

                    data: (attempted) {
                      final isLocked = expired || attempted;

                      return StudentSurpriseQuizCard(
                        title: d['title'] ?? "Surprise Quiz",
                        description: d['description'] ?? "",
                        duration: d['durationSeconds'] ?? 600,
                        points: d['points'] ?? 0,
                        expired: isLocked,
                        visibilityText:
                            attempted ? "Already Attempted" : visibilityText,
                        onAttempt:
                            isLocked
                                ? null
                                : () async {
                                  final quizData =
                                      docs[i].data() as Map<String, dynamic>;

                                  final dynamic raw = quizData['questions'];
                                  List<Map<String, dynamic>> parsedQuestions =
                                      [];

                                  if (raw is List) {
                                    parsedQuestions =
                                        raw.map<Map<String, dynamic>>((q) {
                                          final question =
                                              Map<String, dynamic>.from(q);

                                          return {
                                            "question": question["question"],
                                            "options": question["options"],
                                            "correctIndex": [
                                              "A",
                                              "B",
                                              "C",
                                              "D",
                                            ].indexOf(question["correct"]),
                                            "explanation":
                                                question["explanation"],
                                          };
                                        }).toList();
                                  } else if (raw is Map) {
                                    final entries =
                                        Map<String, dynamic>.from(
                                            raw,
                                          ).entries.toList()
                                          ..sort(
                                            (a, b) => int.parse(
                                              a.key,
                                            ).compareTo(int.parse(b.key)),
                                          );

                                    parsedQuestions =
                                        entries.map<Map<String, dynamic>>((e) {
                                          final q = Map<String, dynamic>.from(
                                            e.value,
                                          );

                                          return {
                                            "question": q["question"],
                                            "options": q["options"],
                                            "correctIndex": [
                                              "A",
                                              "B",
                                              "C",
                                              "D",
                                            ].indexOf(q["correct"]),
                                            "explanation": q["explanation"],
                                          };
                                        }).toList();
                                  }

                                  if (parsedQuestions.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "No questions found for this quiz",
                                        ),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                    return;
                                  }

                                  context.pushNamed(
                                    'studentSurpriseQuizAttempt',
                                    extra: {
                                      "quizId": quizId,
                                      "title": quizData['title'],
                                      "durationSeconds":
                                          quizData['durationSeconds'],
                                      "questions": parsedQuestions,
                                    },
                                  );
                                },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
