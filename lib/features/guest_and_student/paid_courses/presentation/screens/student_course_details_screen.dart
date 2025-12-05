import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:qnect_quiz_crafter/common/widgets/app_loader.dart';
import 'package:qnect_quiz_crafter/common/widgets/common_rounded_app_bar.dart';

import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import '../widgets/student_course_quiz_tile.dart';

class StudentCourseDetailsScreen extends StatelessWidget {
  final String courseId;

  const StudentCourseDetailsScreen({
    super.key,
    required this.courseId,
  });

  DateTime _toDate(dynamic v) {
    if (v == null) return DateTime.now();
    if (v is Timestamp) return v.toDate();
    if (v is String) return DateTime.tryParse(v) ?? DateTime.now();
    return DateTime.now();
  }

  String _durationText(DateTime start, DateTime end) {
    final now = DateTime.now();
    final totalDays = end.difference(start).inDays;
    final remaining = end.isAfter(now) ? end.difference(now) : Duration.zero;
    final remDays = remaining.inDays;
    final remHours = remaining.inHours % 24;

    if (totalDays <= 0) return 'Duration not set';

    if (remaining == Duration.zero) return 'Course time ended';

    return '$remDays Days $remHours Hours left';
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final db = FirebaseFirestore.instance;

    final courseRef = db.collection('courses').doc(courseId);
    final myCourseRef =
    db.collection('users').doc(uid).collection('myCourses').doc(courseId);

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: CommonRoundedAppBar(title: "Course Details",),
      body: StreamBuilder<DocumentSnapshot>(
        stream: courseRef.snapshots(),
        builder: (context, courseSnap) {
          if (!courseSnap.hasData || !courseSnap.data!.exists) {
            return const Center(
              child: AppLoader(),
            );
          }

          final course =
          courseSnap.data!.data() as Map<String, dynamic>;

          return StreamBuilder<DocumentSnapshot>(
            stream: myCourseRef.snapshots(),
            builder: (context, myCourseSnap) {
              final myCourse = myCourseSnap.data?.data() as Map<String, dynamic>?;
              final totalQuizzes = (myCourse?['totalQuizzes'] ?? 0) as int;
              final completedQuizzes =
              (myCourse?['completedQuizzes'] ?? 0) as int;

              final double progress = totalQuizzes == 0
                  ? 0
                  : (completedQuizzes / totalQuizzes)
                  .clamp(0.0, 1.0)
                  .toDouble();

              final percent = (progress * 100).round();

              final title = (course['title'] ?? 'Untitled Course') as String;
              final description =
              (course['description'] ?? '') as String;
              final iconPath = (course['iconPath'] ?? '') as String;
              final enrolledCount =
              (course['enrolledCount'] ?? 0) as int;
              final teacherId = (course['teacherId'] ?? '') as String;
              final startDate = _toDate(course['startDate']);
              final endDate = _toDate(course['endDate']);

              return FutureBuilder<DocumentSnapshot>(
                future: teacherId.isEmpty
                    ? null
                    : db.collection('users').doc(teacherId).get(),
                builder: (context, teacherSnap) {
                  final teacher = teacherSnap.data?.data() as Map<String, dynamic>?;
                  final teacherName =
                  (teacher?['firstName'] ?? 'Course Teacher') as String;

                  return Column(
                    children: [
                      const SizedBox(height: 12),

                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          children: [
                            // MAIN INFO CARD
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white38,),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryLight.withValues(alpha: 0.35),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          color: AppColors.white.withValues(alpha: 0.3),
                                          borderRadius:
                                          BorderRadius.circular(18),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(18),
                                          child: iconPath.isNotEmpty
                                              ? Image.asset(iconPath,
                                              fit: BoxFit.contain)
                                              : const Icon(
                                            Icons.menu_book_rounded,
                                            color: Colors.white,
                                            size: 34,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              title,
                                              style: const TextStyle(
                                                fontFamily:
                                                AppTypography.family,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: AppColors.secondaryDark,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              description,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontFamily:
                                                AppTypography.family,
                                                color: Colors.white70,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Wrap(
                                              spacing: 8,
                                              runSpacing: 8,
                                              children: [
                                                _infoPill(
                                                  icon: CupertinoIcons.group,
                                                  label: '$enrolledCount Enrolled',
                                                  bg: const Color(0xFFFFE2E0),
                                                ),
                                                _infoPill(
                                                  icon: CupertinoIcons.person,
                                                  label: teacherName,
                                                  bg: const Color(0xFFE1F5FE),
                                                ),
                                                _infoPill(
                                                  icon: CupertinoIcons.book,
                                                  label: '$totalQuizzes Quizzes',
                                                  bg: const Color(0xFFE0F2F1),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 16),
                                  const Text(
                                    'Overall Progress',
                                    style: TextStyle(
                                      fontFamily: AppTypography.family,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(999),
                                          child: LinearProgressIndicator(
                                            value: progress,
                                            minHeight: 10,
                                            backgroundColor:
                                            Colors.grey.shade300,
                                            color: AppColors.secondaryDark,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '$percent%',
                                        style: const TextStyle(
                                          fontFamily: AppTypography.family,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 16),

                                  // Duration pill
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: AppColors.chip3,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
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
                                        const SizedBox(width: 8),
                                        Text(
                                          _durationText(startDate, endDate),
                                          style: const TextStyle(
                                            fontFamily: AppTypography.family,
                                            color: Colors.white,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 18),

                            const Text(
                              'Quizzes',
                              style: TextStyle(
                                fontFamily: AppTypography.family,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // QUIZ LIST
                            StreamBuilder<QuerySnapshot>(
                              stream: courseRef
                                  .collection('quizzes')
                                  .orderBy('startDate')
                                  .snapshots(),
                              builder: (context, quizSnap) {
                                if (!quizSnap.hasData) {
                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: AppLoader(),
                                    ),
                                  );
                                }

                                final quizDocs = quizSnap.data!.docs;

                                if (quizDocs.isEmpty) {
                                  return const Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Text(
                                      'No quizzes added for this course yet.',
                                      style: TextStyle(
                                        fontFamily: AppTypography.family,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  );
                                }

                                // return Column(
                                //   children: quizDocs.map((d) {
                                //     final q =
                                //     d.data() as Map<String, dynamic>;
                                //     final quizId = d.id;
                                //
                                //     final qTitle =
                                //     (q['title'] ?? 'Quiz') as String;
                                //     final qDesc =
                                //     (q['description'] ?? '') as String;
                                //     final start = _toDate(q['startDate']);
                                //     final end = _toDate(q['endDate']);
                                //
                                //     final int questionCount =
                                //     (q['questionCount'] ??
                                //         (q['questions']?.length ?? 0))
                                //     as int;
                                //
                                //     final now = DateTime.now();
                                //     //final bool locked = now.isBefore(start);
                                //     //final bool expired = now.isAfter(end);
                                //     final bool locked = false; // TEMP: unlock quizzes for testing
                                //     final bool expired = false; // TEMP: allow testing even after expiration
                                //
                                //
                                //
                                //
                                //     const int earnedPoints = 0;
                                //     final bool completed =
                                //         earnedPoints > 0; // placeholder
                                //
                                //     // return StudentCourseQuizTile(
                                //     //   courseId: courseId,
                                //     //   quizId: quizId,
                                //     //   title: qTitle,
                                //     //   description: qDesc,
                                //     //   totalPoints: questionCount,
                                //     //   earnedPoints: earnedPoints,
                                //     //   locked: locked,
                                //     //   expired: expired,
                                //     //   startDate: start,
                                //     //   endDate: end,
                                //     //   completed: completed,
                                //     // );
                                //     return StudentCourseQuizTile(
                                //       courseId: courseId,
                                //       quizId: quizId,
                                //       title: qTitle,
                                //       description: qDesc,
                                //       totalPoints: questionCount,
                                //       earnedPoints: earnedPoints,
                                //       locked: locked,
                                //       expired: expired,
                                //       startDate: start,
                                //       endDate: end,
                                //       completed: completed,
                                //       questions: q['questions'] ?? [],     // ← NEW
                                //       durationSeconds: q['duration'] ?? 900, // default 15 min
                                //     );
                                //   }).toList(),
                                // );

                                return Column(
                                  children: quizDocs.map((d) {
                                    final q = d.data() as Map<String, dynamic>;
                                    final quizId = d.id;

                                    final qTitle = (q['title'] ?? 'Quiz') as String;
                                    final qDesc = (q['description'] ?? '') as String;

                                    final start = _toDate(q['startDate']);
                                    final end = _toDate(q['endDate']);

                                    final int questionCount =
                                    (q['questionCount'] ?? (q['questions']?.length ?? 0)) as int;

                                    //final bool locked = false;
                                    //final bool expired = false;
                                    final now = DateTime.now();
                                    final bool locked = now.isBefore(start);
                                    final bool expired = now.isAfter(end);

                                    final questions = q['questions'] ?? [];
                                    final durationSeconds = q['duration'] ?? 900;

                                    // FETCH USER ATTEMPT --------------------------
                                    return FutureBuilder<QuerySnapshot>(
                                      future: FirebaseFirestore.instance
                                          .collection("courses")
                                          .doc(courseId)
                                          .collection("quizzes")
                                          .doc(quizId)
                                          .collection("attempts")
                                          .where("userId", isEqualTo: uid)
                                          .limit(1)
                                          .get(),
                                      builder: (context, attemptSnap) {
                                        if (!attemptSnap.hasData) {
                                          return const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: AppLoader(size: 24,),
                                          );
                                        }

                                        bool completed = attemptSnap.data!.docs.isNotEmpty;

                                        String? attemptId;
                                        int earnedPoints = 0;

                                        if (completed) {
                                          final doc = attemptSnap.data!.docs.first;
                                          attemptId = doc.id;
                                          earnedPoints = (doc['points'] ?? 0) as int;
                                        }

                                        return StudentCourseQuizTile(
                                          courseId: courseId,
                                          quizId: quizId,
                                          title: qTitle,
                                          subtitle: qDesc,
                                          totalPoints: questionCount,
                                          earnedPoints: earnedPoints,
                                          locked: locked,
                                          expired: expired,
                                          startDate: start,
                                          endDate: end,
                                          completed: completed,
                                          questions: questions,
                                          durationSeconds: durationSeconds,
                                          attemptId: attemptId,   // <-- pass to tile
                                        );
                                      },
                                    );
                                  }).toList(),
                                );


                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _infoPill({
    required IconData icon,
    required String label,
    required Color bg,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.redAccent),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: AppTypography.family,
              fontSize: 11,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
