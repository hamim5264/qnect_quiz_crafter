// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import '../../../../common/widgets/common_rounded_app_bar.dart';
// import '../../../../common/widgets/common_confirm_dialog.dart';
// import '../../../../common/widgets/action_success_dialog.dart';
// import '../../../../ui/design_system/tokens/colors.dart';
// import '../../../../ui/design_system/tokens/typography.dart';
// import 'widgets/header_course_card.dart';
// import 'widgets/stats_and_status_grid.dart';
// import 'widgets/quiz_item_card.dart';
//
// class CourseDetailsScreen extends StatefulWidget {
//   final Map<String, dynamic> courseData;
//
//   const CourseDetailsScreen({super.key, required this.courseData});
//
//   @override
//   State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
// }
//
// class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
//   bool hasChanges = false;
//   String courseStatus = 'Pending';
//   String? rejectionReason;
//
//   late List<Map<String, dynamic>> quizzes;
//
//   @override
//   void initState() {
//     super.initState();
//
//     quizzes = List<Map<String, dynamic>>.from(
//       widget.courseData['quizzes'] ?? [],
//     );
//   }
//
//   void _onStatusChanged(String value, {String? reason}) {
//     setState(() {
//       courseStatus = value;
//       rejectionReason = reason;
//       hasChanges = true;
//     });
//   }
//
//   void _onEditQuiz(int index) {
//     setState(() => hasChanges = true);
//   }
//
//   void _onDeleteQuiz(int index) {
//     showDialog(
//       context: context,
//       builder:
//           (_) => CommonConfirmDialog(
//             title: "Delete Quiz",
//             message: "Are you sure you want to delete this quiz?",
//             icon: CupertinoIcons.trash,
//             iconColor: Colors.red,
//             confirmColor: Colors.red,
//             onConfirm: () {
//               setState(() {
//                 quizzes.removeAt(index);
//                 hasChanges = true;
//               });
//               showDialog(
//                 context: context,
//                 builder:
//                     (_) => ActionSuccessDialog(
//                       title: 'Success',
//                       message: 'The quiz has been deleted successfully.',
//                       onConfirm: () => Navigator.pop(context),
//                     ),
//               );
//             },
//           ),
//     );
//   }
//
//   void _onDeleteCourse() {
//     showDialog(
//       context: context,
//       builder:
//           (_) => CommonConfirmDialog(
//             title: "Delete Course",
//             message: "Are you sure you want to delete this course?",
//             icon: CupertinoIcons.trash,
//             iconColor: Colors.red,
//             confirmColor: Colors.red,
//             onConfirm: () {
//               showDialog(
//                 context: context,
//                 builder:
//                     (_) => ActionSuccessDialog(
//                       title: 'Success',
//                       message: 'The course has been deleted successfully.',
//                       onConfirm: () => Navigator.pop(context),
//                     ),
//               );
//             },
//           ),
//     );
//   }
//
//   void _onUpdate() {
//     showDialog(
//       context: context,
//       builder:
//           (_) => ActionSuccessDialog(
//             title: 'Success',
//             message: 'Your changes have been updated successfully.',
//             onConfirm: () {
//               setState(() => hasChanges = false);
//               Navigator.pop(context);
//             },
//           ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final course = widget.courseData;
//     return Scaffold(
//       backgroundColor: AppColors.primaryDark,
//       appBar: CommonRoundedAppBar(title: course['title'] ?? 'Course Details'),
//       body: SafeArea(
//         child: ListView(
//           padding: const EdgeInsets.all(16),
//           children: [
//             HeaderCourseCard(
//               icon: course['icon'] ?? Icons.menu_book_rounded,
//               title: course['title'] ?? 'Untitled Course',
//               fullDescription:
//                   course['description'] ?? 'No description available.',
//               createdAtText: course['createdAt'] ?? 'Created at: --',
//               price: course['price'] ?? 0,
//               discountPercent: course['discount'] ?? 0,
//             ),
//             const SizedBox(height: 14),
//
//             StatsAndStatusGrid(
//               quizzes: course['quizCount'] ?? 0,
//               enrolled: course['enrolled'] ?? 0,
//               sold: course['sold'] ?? 0,
//               price: course['price'] ?? 0,
//               discountPercent: course['discount'] ?? 0,
//               total: course['total'] ?? 0,
//               durationText: course['duration'] ?? 'N/A',
//               teacherName: course['teacherName'] ?? 'Unknown',
//               teacherImage: course['teacherImage'],
//               initialStatus: courseStatus,
//               initialRejection: rejectionReason,
//               onDeleteCourse: _onDeleteCourse,
//               onEditCourse: () => setState(() => hasChanges = true),
//               onStatusChanged: _onStatusChanged,
//             ),
//             const SizedBox(height: 16),
//
//             ...List.generate(quizzes.length, (i) {
//               final q = quizzes[i];
//               return Padding(
//                 padding: EdgeInsets.only(
//                   bottom: i == quizzes.length - 1 ? 0 : 12,
//                 ),
//                 child: QuizItemCard(
//                   icon: q['icon'] ?? Icons.help_outline,
//                   title: q['title'] ?? 'Untitled Quiz',
//                   description: q['desc'] ?? '',
//                   points: q['points'] ?? 0,
//                   timeLeft: q['timeLeft'] ?? '0 h 0 m',
//                   onDetails: () {},
//                   onEdit: () => _onEditQuiz(i),
//                   onDelete: () => _onDeleteQuiz(i),
//                 ),
//               );
//             }),
//
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: hasChanges ? _onUpdate : null,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor:
//                       hasChanges
//                           ? AppColors.primaryLight
//                           : AppColors.white.withValues(alpha: 0.3),
//                   disabledBackgroundColor: AppColors.white.withValues(
//                     alpha: 0.3,
//                   ),
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//                 child: Text(
//                   'Update',
//                   style: TextStyle(
//                     fontFamily: AppTypography.family,
//                     fontWeight: FontWeight.bold,
//                     color: hasChanges ? AppColors.white : Colors.white70,
//                     fontSize: 15,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qnect_quiz_crafter/common/widgets/app_loader.dart';

import '../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../common/widgets/common_confirm_dialog.dart';
import '../../../../common/widgets/action_success_dialog.dart';

import '../../../../ui/design_system/tokens/colors.dart';
import '../../../../ui/design_system/tokens/typography.dart';

import 'widgets/header_course_card.dart';
import 'widgets/stats_and_status_grid.dart';
import 'widgets/quiz_item_card.dart';

class CourseDetailsScreen extends StatefulWidget {
  final String courseId;

  const CourseDetailsScreen({super.key, required this.courseId});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  Map<String, dynamic>? course;
  Map<String, dynamic>? teacher;
  List<Map<String, dynamic>> quizzes = [];

  String courseStatus = "pending";
  String? rejectionReason;
  bool hasChanges = false;

  @override
  void initState() {
    super.initState();
    _loadCourse();
    _loadQuizzes();
  }

  // ---------------------------------------------------
  // LOAD COURSE
  // ---------------------------------------------------
  Future<void> _loadCourse() async {
    final doc = await FirebaseFirestore.instance
        .collection("courses")
        .doc(widget.courseId)
        .get();

    if (!doc.exists) return;

    course = doc.data();
    courseStatus = (course!["status"] ?? "pending").toString();

    setState(() {});

    // Fetch teacher info
    if (course!["teacherId"] != null) {
      _loadTeacher(course!["teacherId"]);
    }
  }

  // ---------------------------------------------------
  // LOAD TEACHER
  // ---------------------------------------------------
  Future<void> _loadTeacher(String teacherId) async {
    final userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(teacherId)
        .get();

    if (!userDoc.exists) return;

    final data = userDoc.data() as Map<String, dynamic>;

    // 🔥 SAFE NAME MAPPING
    final safeName =
        data["name"] ??
            data["fullName"] ??
            data["username"] ??
            data["displayName"] ??
            data["firstName"] ??
            data["email"] ?? // fallback
            "Unknown";

    // 🔥 SAFE IMAGE MAPPING
    final safeImage =
        data["profileImage"] ??
            data["photoUrl"] ??
            data["avatar"] ??
            null;

    teacher = {
      "teacherName": safeName,
      "teacherImage": safeImage,
      "teacherId": teacherId,
    };

    setState(() {});
  }

  // ---------------------------------------------------
  // LOAD QUIZZES
  // ---------------------------------------------------
  Future<void> _loadQuizzes() async {
    final snap = await FirebaseFirestore.instance
        .collection("courses")
        .doc(widget.courseId)
        .collection("quizzes")
        .get();

    quizzes = snap.docs.map((d) => {"id": d.id, ...d.data()}).toList();

    setState(() {});
  }

  // ---------------------------------------------------
  // UPDATE STATUS
  // ---------------------------------------------------
  Future<void> _updateStatus(String status, {String? reason}) async {
    await FirebaseFirestore.instance
        .collection("courses")
        .doc(widget.courseId)
        .update({
      "status": status,
      "remark": reason ?? "",
      "updatedAt": DateTime.now().toIso8601String(),
    });

    _loadCourse();
  }

  // ---------------------------------------------------
  // DELETE QUIZ
  // ---------------------------------------------------
  Future<void> _deleteQuiz(int index) async {
    final quizId = quizzes[index]["id"];

    await FirebaseFirestore.instance
        .collection("courses")
        .doc(widget.courseId)
        .collection("quizzes")
        .doc(quizId)
        .delete();

    setState(() {
      quizzes.removeAt(index);
      hasChanges = true;
    });
  }

  // ---------------------------------------------------
  // DELETE COURSE
  // ---------------------------------------------------
  Future<void> _deleteCourse() async {
    final batch = FirebaseFirestore.instance.batch();

    final quizDocs = await FirebaseFirestore.instance
        .collection("courses")
        .doc(widget.courseId)
        .collection("quizzes")
        .get();

    for (var q in quizDocs.docs) {
      batch.delete(q.reference);
    }

    batch.delete(
      FirebaseFirestore.instance.collection("courses").doc(widget.courseId),
    );

    await batch.commit();
  }

  // ---------------------------------------------------
  // STATUS CHANGE
  // ---------------------------------------------------
  void _onStatusChanged(String status, {String? reason}) {
    setState(() {
      courseStatus = status;
      rejectionReason = reason;
      hasChanges = true;
    });
  }

  // ---------------------------------------------------
  // BUILD UI
  // ---------------------------------------------------
  @override
  Widget build(BuildContext context) {
    if (course == null) {
      return const Scaffold(
        backgroundColor: AppColors.primaryDark,
        body: Center(child: AppLoader()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: CommonRoundedAppBar(title: course!["title"] ?? "Course Details"),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            HeaderCourseCard(
              iconPath: course!["iconPath"] ?? "assets/icons/default.png",
              title: course!["title"] ?? "",
              fullDescription: course!["description"] ?? "",
              createdAtText: course!["createdAt"] ?? "",
              price: (course!["price"] ?? 0).toInt(),
              discountPercent: course!["discountPercent"] ?? 0,
            ),

            const SizedBox(height: 14),

            StatsAndStatusGrid(
              courseId: widget.courseId,
              quizzes: quizzes.length,
              enrolled: course!["enrolledCount"] ?? 0,
              sold: course!["sold"] ?? 0,
              price: (course!["price"] ?? 0).toInt(),
              discountPercent: course!["discountPercent"] ?? 0,
              total: (course!["price"] ?? 0).toInt(),
              durationText: _calculateDuration(
                course!['startDate'],
                course!['endDate'],
              ),

              teacherId: teacher?["teacherId"] ?? "",
              teacherName: teacher?["teacherName"] ?? "Unknown",
              teacherImage: teacher?["teacherImage"],

              initialStatus: courseStatus,
              initialRejection: rejectionReason,
              onDeleteCourse: () {
                showDialog(
                  context: context,
                  builder: (_) => CommonConfirmDialog(
                    title: "Delete Course",
                    message: "Are you sure?",
                    icon: CupertinoIcons.trash,
                    iconColor: Colors.red,
                    confirmColor: Colors.red,
                    onConfirm: () async {
                      await _deleteCourse();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
                );
              },
              onEditCourse: () {},
              onStatusChanged: _onStatusChanged,
            ),

            const SizedBox(height: 16),

            ...List.generate(quizzes.length, (i) {
              final q = quizzes[i];

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: QuizItemCard(
                  icon: CupertinoIcons.book,

                  title: q["title"] ?? "",
                  description: q["subtitle"] ?? "",
                  questionCount: (q["questions"] as List?)?.length ?? 0,

                  startDate: q["startDate"],
                  endDate: q["endDate"],

                  timeSeconds: q["time"],  // 🔥 FIXED → use q not quiz

                  questions: q["questions"] != null
                      ? List<Map<String, dynamic>>.from(q["questions"])
                      : [],   // 🔥 FIXED → use q not quiz

                  onDetails: () {
                    final cleanedQuestions = (q["questions"] as List).map((qq) {
                      final opts = qq["options"];

                      // Convert Map → List<String> in correct order
                      final List<String> optionsList = [
                        opts["A"]?.toString() ?? "",
                        opts["B"]?.toString() ?? "",
                        opts["C"]?.toString() ?? "",
                        opts["D"]?.toString() ?? "",
                      ];

                      return {
                        "question": qq["question"] ?? "",
                        "options": optionsList,
                        "correct": qq["correct"] ?? "A",
                        "description": qq["description"] ?? "",
                      };
                    }).toList();

                    context.pushNamed(
                      "adminQuizDetails",
                      extra: {
                        "title": q["title"] ?? "",
                        "time": Duration(seconds: q["time"] ?? 0),
                        "questions": cleanedQuestions,
                      },
                    );
                  },


                  onEdit: () {
                    context.pushNamed(
                      'adminEditQuiz',
                      pathParameters: {
                        'courseId': widget.courseId,
                        'quizId': q['id'],
                      },
                    );
                  },

                  onDelete: () {
                    showDialog(
                      context: context,
                      builder: (_) => CommonConfirmDialog(
                        title: "Delete Quiz",
                        message: "Delete this quiz?",
                        icon: CupertinoIcons.trash,
                        iconColor: Colors.red,
                        confirmColor: Colors.red,
                        onConfirm: () async {
                          await _deleteQuiz(i);
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),

              );
            }),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: hasChanges
                    ? () async {
                  await _updateStatus(courseStatus,
                      reason: rejectionReason);

                  showDialog(
                    context: context,
                    builder: (_) => ActionSuccessDialog(
                      title: "Updated",
                      message: "Course updated successfully",
                      onConfirm: () => Navigator.pop(context),
                    ),
                  );

                  setState(() => hasChanges = false);
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  hasChanges ? AppColors.primaryLight : AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "Update",
                  style: TextStyle(
                    fontFamily: AppTypography.family,
                    fontWeight: FontWeight.bold,
                    color: hasChanges ? Colors.white : Colors.white70,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------
  // CALCULATE DURATION
  // ---------------------------------------------------
  String _calculateDuration(dynamic start, dynamic end) {
    DateTime startDate;
    DateTime endDate;

    if (start is Timestamp) {
      startDate = start.toDate();
    } else {
      startDate = DateTime.tryParse(start.toString()) ?? DateTime.now();
    }

    if (end is Timestamp) {
      endDate = end.toDate();
    } else {
      endDate =
          DateTime.tryParse(end.toString()) ??
              DateTime.now().add(const Duration(days: 30));
    }

    final diff = endDate.difference(startDate);
    return "${diff.inDays} D ${diff.inHours % 24} H";
  }
}
