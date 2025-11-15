import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widgets/quiz_card.dart';
import 'widgets/quiz_date_filter.dart';
import 'widgets/quiz_filter_bar.dart';

import '../../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../common/widgets/action_success_dialog.dart';
import '../../../../../common/widgets/app_skeleton.dart';
import '../../../../../common/widgets/common_confirm_dialog.dart';
import '../../../../../common/widgets/success_failure_dialog.dart';

class PracticeQuizzesScreen extends StatefulWidget {
  /// For now you'll pass "admin" here from Admin route.
  /// Later you can reuse this screen for teacher: role = "teacher"
  final String role;

  const PracticeQuizzesScreen({super.key, required this.role});

  @override
  State<PracticeQuizzesScreen> createState() => _PracticeQuizzesScreenState();
}

class _PracticeQuizzesScreenState extends State<PracticeQuizzesScreen> {
  String selectedFilter = "Admin’s";
  String dateFilter = "All";

  Stream<QuerySnapshot<Map<String, dynamic>>> _practiceQuizzesStream() {
    return FirebaseFirestore.instance
        .collection('practice_quizzes')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  void _showConfirmDialog({
    required String title,
    required String message,
    required IconData icon,
    required Color iconColor,
    required Color confirmColor,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder:
          (_) => CommonConfirmDialog(
            title: title,
            message: message,
            icon: icon,
            iconColor: iconColor,
            confirmColor: confirmColor,
            onConfirm: onConfirm,
          ),
    );
  }

  void _showSuccessDialog(String title, String message) {
    showDialog(
      context: context,
      builder:
          (_) => ActionSuccessDialog(
            title: title,
            message: message,
            onConfirm: () => Navigator.pop(context),
          ),
    );
  }

  void _showFailureDialog(String title, String message) {
    showDialog(
      context: context,
      builder:
          (_) => SuccessFailureDialog(
            icon: Icons.error_outline,
            title: title,
            subtitle: message,
            buttonText: "Okay",
            onPressed: () => Navigator.pop(context),
          ),
    );
  }

  bool _isToday(Timestamp? ts) {
    if (ts == null) return false;
    final date = ts.toDate();
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = widget.role.toLowerCase() == 'admin';
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: "Practice Quizzes"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              QuizFilterBar(
                selectedFilter: selectedFilter,
                onChanged: (v) => setState(() => selectedFilter = v),
              ),
              const SizedBox(height: 12),

              QuizDateFilter(
                dateFilter: dateFilter,
                onFilterChange: (v) => setState(() => dateFilter = v),
              ),
              const SizedBox(height: 16),

              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: _practiceQuizzesStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return GridView.builder(
                        itemCount: 6,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.72,
                            ),
                        itemBuilder: (_, __) {
                          return Container(
                            decoration: BoxDecoration(
                              color: AppColors.cardSecondary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                AppSkeleton(
                                  width: 44,
                                  height: 44,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(22),
                                  ),
                                ),
                                SizedBox(height: 10),
                                AppSkeleton(height: 14),
                                SizedBox(height: 6),
                                AppSkeleton(width: 80, height: 12),
                                SizedBox(height: 14),
                                AppSkeleton(height: 32),
                              ],
                            ),
                          );
                        },
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                CupertinoIcons.cube_box,
                                color: Colors.white70,
                                size: 42,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "No practice quiz found",
                              style: TextStyle(
                                fontFamily: "Barlow",
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 6),

                            const Text(
                              "Create a new quiz to get started.",
                              style: TextStyle(
                                fontFamily: "Barlow",
                                fontSize: 13,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final docs =
                        snapshot.data!.docs.where((doc) {
                          final data = doc.data();

                          final role = (data['role'] as String?) ?? 'teacher';
                          final creatorId = data['creatorId'] as String?;
                          final createdAt = data['createdAt'] as Timestamp?;

                          if (!isAdmin) {
                            if (creatorId == null ||
                                creatorId != currentUserId) {
                              return false;
                            }
                          }

                          if (selectedFilter == "Admin’s" &&
                              role.toLowerCase() != 'admin') {
                            return false;
                          }
                          if (selectedFilter == "Teacher’s" &&
                              role.toLowerCase() != 'teacher') {
                            return false;
                          }

                          if (dateFilter == "Today" && !_isToday(createdAt)) {
                            return false;
                          }

                          return true;
                        }).toList();

                    if (docs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                CupertinoIcons.cube_box,
                                color: Colors.white70,
                                size: 42,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "No practice quiz found",
                              style: TextStyle(
                                fontFamily: "Barlow",
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 6),

                            const Text(
                              "Create a new quiz to get started.",
                              style: TextStyle(
                                fontFamily: "Barlow",
                                fontSize: 13,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return GridView.builder(
                      itemCount: docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.72,
                          ),
                      itemBuilder: (context, index) {
                        final doc = docs[index];
                        final data = doc.data();
                        final docId = doc.id;

                        final title =
                            data['title'] as String? ?? 'Untitled Quiz';
                        final group =
                            (data['group'] as String? ?? '').toUpperCase();
                        final levelRaw = (data['level'] as String? ?? '');
                        final published = data['published'] as bool? ?? false;

                        final level =
                            levelRaw.isEmpty
                                ? ''
                                : levelRaw[0].toUpperCase() +
                                    levelRaw.substring(1).toLowerCase();

                        return QuizCard(
                          title: title,
                          groupLabel: group,
                          levelLabel: level,
                          isPublished: published,
                          onPublish: () {
                            final willPublish = !published;
                            _showConfirmDialog(
                              title:
                                  willPublish
                                      ? "Publish Quiz"
                                      : "Unpublish Quiz",
                              message:
                                  willPublish
                                      ? "Are you sure you want to publish this quiz for learners?"
                                      : "Are you sure you want to unpublish this quiz?",
                              icon:
                                  willPublish
                                      ? CupertinoIcons.paperplane_fill
                                      : Icons.cloud_off_rounded,
                              iconColor:
                                  willPublish
                                      ? Colors.white
                                      : Colors.orangeAccent,
                              confirmColor:
                                  willPublish
                                      ? AppColors.chip2
                                      : Colors.orangeAccent,
                              onConfirm: () async {
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('practice_quizzes')
                                      .doc(docId)
                                      .update({'published': willPublish});

                                  _showSuccessDialog(
                                    willPublish
                                        ? "Published Successfully"
                                        : "Unpublished Successfully",
                                    willPublish
                                        ? "This quiz is now available for learners."
                                        : "This quiz is no longer visible to learners.",
                                  );
                                } catch (e) {
                                  _showFailureDialog(
                                    "Action Failed",
                                    "Could not update quiz status. Please try again.",
                                  );
                                }
                              },
                            );
                          },
                          onDelete: () {
                            _showConfirmDialog(
                              title: "Delete Quiz",
                              message:
                                  "Are you sure you want to delete this quiz permanently?",
                              icon: CupertinoIcons.trash,
                              iconColor: Colors.redAccent,
                              confirmColor: Colors.redAccent,
                              onConfirm: () async {
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('practice_quizzes')
                                      .doc(docId)
                                      .delete();

                                  _showSuccessDialog(
                                    "Quiz Deleted",
                                    "The quiz has been deleted successfully.",
                                  );
                                } catch (e) {
                                  _showFailureDialog(
                                    "Deletion Failed",
                                    "Could not delete quiz. Please try again.",
                                  );
                                }
                              },
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
        ),
      ),
    );
  }
}
