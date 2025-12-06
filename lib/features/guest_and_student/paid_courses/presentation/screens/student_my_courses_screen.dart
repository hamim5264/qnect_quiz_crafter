import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qnect_quiz_crafter/common/widgets/app_loader.dart';
import 'package:qnect_quiz_crafter/common/widgets/common_rounded_app_bar.dart';

import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import '../widgets/student_my_course_card.dart';

class StudentMyCoursesScreen extends StatefulWidget {
  const StudentMyCoursesScreen({super.key});

  @override
  State<StudentMyCoursesScreen> createState() => _StudentMyCoursesScreenState();
}

class _StudentMyCoursesScreenState extends State<StudentMyCoursesScreen> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: CommonRoundedAppBar(title: "My Courses"),
      body: Column(
        children: [
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              onChanged:
                  (v) => setState(() => _search = v.trim().toLowerCase()),
              style: const TextStyle(
                fontFamily: AppTypography.family,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'Search courses...',
                hintStyle: const TextStyle(
                  fontFamily: AppTypography.family,
                  color: Colors.white60,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Colors.white10,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .collection('myCourses')
                      .orderBy('boughtAt', descending: true)
                      .snapshots(),
              builder: (context, myCourseSnap) {
                if (myCourseSnap.connectionState == ConnectionState.waiting) {
                  return const Center(child: AppLoader());
                }

                if (!myCourseSnap.hasData || myCourseSnap.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.book_fill,
                          size: 85,
                          color: Colors.white24,
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "You haven’t bought any course yet.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppTypography.family,
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          "Purchase a course to get started learning!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppTypography.family,
                            color: Colors.white38,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final myCourses = myCourseSnap.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: myCourses.length,
                  itemBuilder: (_, i) {
                    final myCourseData =
                        myCourses[i].data() as Map<String, dynamic>;
                    final courseId = myCourseData['courseId'] as String;

                    return FutureBuilder<DocumentSnapshot>(
                      future:
                          FirebaseFirestore.instance
                              .collection('courses')
                              .doc(courseId)
                              .get(),
                      builder: (context, courseSnap) {
                        if (!courseSnap.hasData || !courseSnap.data!.exists) {
                          return const SizedBox.shrink();
                        }

                        final courseData =
                            courseSnap.data!.data() as Map<String, dynamic>;

                        final title =
                            (courseData['title'] ?? 'Untitled Course')
                                as String;

                        if (_search.isNotEmpty &&
                            !title.toLowerCase().contains(_search)) {
                          return const SizedBox.shrink();
                        }

                        final int totalQuizzes =
                            (myCourseData['totalQuizzes'] ?? 0) as int;
                        final int completedQuizzes =
                            (myCourseData['completedQuizzes'] ?? 0) as int;

                        final double progress =
                            totalQuizzes == 0
                                ? 0
                                : (completedQuizzes / totalQuizzes)
                                    .clamp(0.0, 1.0)
                                    .toDouble();

                        return StudentMyCourseCard(
                          courseId: courseId,
                          course: courseData,
                          progress: progress,
                          completedQuizzes: completedQuizzes,
                          totalQuizzes: totalQuizzes,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
