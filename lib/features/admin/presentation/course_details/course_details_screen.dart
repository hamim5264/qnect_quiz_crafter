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

  Future<void> _loadCourse() async {
    final doc =
        await FirebaseFirestore.instance
            .collection("courses")
            .doc(widget.courseId)
            .get();

    if (!doc.exists) return;

    course = doc.data();
    courseStatus = (course!["status"] ?? "pending").toString();

    setState(() {});

    if (course!["teacherId"] != null) {
      _loadTeacher(course!["teacherId"]);
    }
  }

  Future<void> _loadTeacher(String teacherId) async {
    final userDoc =
        await FirebaseFirestore.instance
            .collection("users")
            .doc(teacherId)
            .get();

    if (!userDoc.exists) return;

    final data = userDoc.data() as Map<String, dynamic>;

    final safeName =
        data["name"] ??
        data["fullName"] ??
        data["username"] ??
        data["displayName"] ??
        data["firstName"] ??
        data["email"] ??
        "Unknown";

    final safeImage =
        data["profileImage"] ?? data["photoUrl"] ?? data["avatar"];

    teacher = {
      "teacherName": safeName,
      "teacherImage": safeImage,
      "teacherId": teacherId,
    };

    setState(() {});
  }

  Future<void> _loadQuizzes() async {
    final snap =
        await FirebaseFirestore.instance
            .collection("courses")
            .doc(widget.courseId)
            .collection("quizzes")
            .get();

    quizzes = snap.docs.map((d) => {"id": d.id, ...d.data()}).toList();

    setState(() {});
  }

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

  Future<void> _deleteCourse() async {
    final batch = FirebaseFirestore.instance.batch();

    final quizDocs =
        await FirebaseFirestore.instance
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

  void _onStatusChanged(String status, {String? reason}) {
    setState(() {
      courseStatus = status;
      rejectionReason = reason;
      hasChanges = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int price = (course?["price"] as num?)?.toInt() ?? 0;
    final int discount = (course?["discountPercent"] as num?)?.toInt() ?? 0;
    final bool applyDiscount = (course?["applyDiscount"] as bool?) ?? false;

    final int total =
        applyDiscount ? price - ((price * discount) ~/ 100) : price;

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

              price: price,
              discountPercent: discount,
              total: total,

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
                  builder:
                      (_) => CommonConfirmDialog(
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

                  timeSeconds: q["time"],

                  questions:
                      q["questions"] != null
                          ? List<Map<String, dynamic>>.from(q["questions"])
                          : [],

                  onDetails: () {
                    final cleanedQuestions =
                        (q["questions"] as List).map((qq) {
                          final opts = qq["options"];

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
                    final List rawQuestions = q["questions"] ?? [];

                    final List<Map<String, dynamic>> parsedQuestions =
                        rawQuestions.map<Map<String, dynamic>>((item) {
                          final opts =
                              item["options"] as Map<String, dynamic>? ?? {};

                          return {
                            "question": item["question"] ?? "",
                            "correct": item["correct"] ?? "A",
                            "description": item["description"] ?? "",
                            "options": [
                              (opts["A"] ?? "").toString(),
                              (opts["B"] ?? "").toString(),
                              (opts["C"] ?? "").toString(),
                              (opts["D"] ?? "").toString(),
                            ],
                          };
                        }).toList();

                    context.pushNamed(
                      'adminEditQuiz',
                      pathParameters: {
                        'courseId': widget.courseId,
                        'quizId': q['id'],
                      },
                      extra: {
                        "quizId": q['id'],
                        "courseId": widget.courseId,
                        "questions": parsedQuestions,
                        "title": q["title"] ?? "",
                        "description": q["description"] ?? "",
                        "time": q["time"] ?? 0,
                      },
                    );
                  },

                  onDelete: () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => CommonConfirmDialog(
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
                onPressed:
                    hasChanges
                        ? () async {
                          await _updateStatus(
                            courseStatus,
                            reason: rejectionReason,
                          );

                          showDialog(
                            context: context,
                            builder:
                                (_) => ActionSuccessDialog(
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
