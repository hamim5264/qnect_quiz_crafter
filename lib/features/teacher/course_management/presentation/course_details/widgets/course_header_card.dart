// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import '../../../../../../ui/design_system/tokens/colors.dart';
// import '../../../../../../ui/design_system/tokens/typography.dart';
// import '../../../models/teacher_course_model.dart';
//
// class CourseDetailsHeader extends StatelessWidget {
//   final TeacherCourseModel course;
//   final VoidCallback onEdit;
//   final VoidCallback onDelete;
//
//   const CourseDetailsHeader({
//     super.key,
//     required this.course,
//     required this.onEdit,
//     required this.onDelete,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final statusColor = {
//       CourseStatus.draft: Colors.grey,
//       CourseStatus.pending: Colors.blue,
//       CourseStatus.approved: Colors.green,
//       CourseStatus.rejected: Colors.red,
//     }[course.status]!;
//
//     return Stack(
//       clipBehavior: Clip.none,
//       children: [
//         // MAIN CARD
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
//           decoration: BoxDecoration(
//             color: AppColors.white.withValues(alpha: 0.2),
//             borderRadius: BorderRadius.circular(26),
//             border: Border.all(color: Colors.white24)
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Icon
//               Container(
//                 padding: const EdgeInsets.all(18),
//                 decoration: BoxDecoration(
//                   color: AppColors.white.withValues(alpha: 0.3),
//                   shape: BoxShape.circle,
//                     border: Border.all(color: Colors.white24)
//                 ),
//                 child: Image.asset(
//                   course.iconPath,
//                   height: 58,
//                   width: 58,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//
//               const SizedBox(height: 10),
//
//               Text(
//                 "Title: ${course.title}",
//                 style: const TextStyle(
//                   fontFamily: AppTypography.family,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.white,
//                 ),
//               ),
//               const SizedBox(height: 4),
//
//               Text(
//                 "Description: ${course.description}",
//                 style: const TextStyle(
//                   fontFamily: AppTypography.family,
//                   fontSize: 14,
//                   color: Colors.white70,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 6),
//
//               Text(
//                 "Created at: ${course.createdAt}",
//                 style: const TextStyle(
//                   fontFamily: AppTypography.family,
//                   fontSize: 13,
//                   color: Colors.white70,
//                 ),
//               ),
//
//               const SizedBox(height: 18),
//
//               // --------------------------
//               // ROW 1
//               // --------------------------
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   _chip(course.level, Colors.orange),
//                   const SizedBox(width: 10),
//                   _chip(course.group, Colors.blue),
//                   const SizedBox(width: 10),
//                   _chip("${course.quizCount} Quizzes", Colors.green),
//                 ],
//               ),
//
//               const SizedBox(height: 14),
//
//               // --------------------------
//               // ROW 2                  <==== EXACT FIGMA REQUIREMENT
//               // --------------------------
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   _chip(course.status.name, statusColor),
//                   const SizedBox(width: 12),
//
//                   _chip("${course.price} BDT", Colors.amber.shade600),
//                   //const SizedBox(width: 16),
//
//                   // Edit
//                   // GestureDetector(
//                   //   onTap: onEdit,
//                   //   child: const Icon(CupertinoIcons.pencil_ellipsis_rectangle, color: Colors.white, size: 26),
//                   // ),
//                   const SizedBox(width: 18),
//
//                   // Delete
//                   GestureDetector(
//                     onTap: onDelete,
//                     child:
//                     const Icon(CupertinoIcons.delete, color: Colors.red, size: 26),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 40),
//             ],
//           ),
//         ),
//
//         // FLOATING ADD BUTTON (HALF INSIDE / HALF OUTSIDE)
//         Positioned(
//           bottom: -28,
//           left: 0,
//           right: 0,
//           child: Center(
//             child: GestureDetector(
//               onTap: () {
//                 context.pushNamed(
//                   "teacherAddQuiz",
//                   extra: course,
//                 );
//               },
//               child: Container(
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: AppColors.chip3,
//                 ),
//                 height: 58,
//                 width: 58,
//                 child: const Icon(Icons.add, color: Colors.white, size: 32),
//               ),
//             ),
//           ),
//         )
//       ],
//     );
//   }
//
//   // 🔹 Reusable Chip Widget
//   Widget _chip(String text, Color bgColor) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: bgColor.withOpacity(0.35),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           fontFamily: AppTypography.family,
//           fontWeight: FontWeight.w600,
//           color: bgColor,
//           fontSize: 13,
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../common/widgets/action_success_dialog.dart';
import '../../../../../../common/widgets/common_confirm_dialog.dart';
import '../../../../../../common/widgets/success_failure_dialog.dart';
import '../../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../../ui/design_system/tokens/typography.dart';
import '../../../models/teacher_course_model.dart';

class CourseDetailsHeader extends StatelessWidget {
  final TeacherCourseModel course;
  final VoidCallback onEdit;

  /// DELETE MUST BE async → Future<void>
  final Future<void> Function() onDelete;

  const CourseDetailsHeader({
    super.key,
    required this.course,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = {
      CourseStatus.draft: Colors.grey,
      CourseStatus.pending: Colors.blue,
      CourseStatus.approved: Colors.green,
      CourseStatus.rejected: Colors.red,
    }[course.status]!;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // MAIN CARD
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: Colors.white24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24),
                ),
                child: Image.asset(
                  course.iconPath,
                  height: 58,
                  width: 58,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Title: ${course.title}",
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 4),

              Text(
                "Description: ${course.description}",
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  fontSize: 14,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),

              Text(
                "Created at: ${course.createdAt}",
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  fontSize: 13,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 18),

              // --------------------------
              // ROW 1
              // --------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _chip(course.level, Colors.orange),
                  const SizedBox(width: 10),
                  _chip(course.group, Colors.blue),
                  const SizedBox(width: 10),
                  _chip("${course.quizCount} Quizzes", Colors.green),
                ],
              ),

              const SizedBox(height: 14),

              // --------------------------
              // ROW 2
              // --------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _chip(course.status.name, statusColor),
                  const SizedBox(width: 12),

                  _chip("${course.price} BDT", Colors.amber.shade600),
                  const SizedBox(width: 18),

                  // DELETE COURSE (with confirm + success/failure)
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => CommonConfirmDialog(
                          title: "Delete Course?",
                          message:
                          "Deleting this course will also permanently delete all its quizzes.\nThis action cannot be undone.",
                          icon: CupertinoIcons.delete,
                          iconColor: Colors.redAccent,
                          confirmColor: Colors.redAccent,
                          onConfirm: () async {
                            try {
                              // Execute delete from parent widget
                              await onDelete();

                              // SUCCESS
                              showDialog(
                                context: context,
                                builder: (_) => ActionSuccessDialog(
                                  title: "Deleted",
                                  message:
                                  "Course and all quizzes were deleted successfully.",
                                  onConfirm: () {
                                    Navigator.pop(context); // close success
                                    Navigator.pop(context); // back to list
                                  },
                                ),
                              );
                            } catch (e) {
                              // FAILURE
                              showDialog(
                                context: context,
                                builder: (_) => SuccessFailureDialog(
                                  icon: Icons.error_outline_rounded,
                                  title: "Delete Failed",
                                  subtitle:
                                  "Something went wrong while deleting the course:\n${e.toString()}",
                                  buttonText: "Close",
                                  onPressed: () => Navigator.pop(context),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                    child: const Icon(
                      CupertinoIcons.delete,
                      color: Colors.red,
                      size: 26,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),

        // FLOATING ADD BUTTON
        Positioned(
          bottom: -28,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: () {
                context.pushNamed(
                  "teacherAddQuiz",
                  extra: course,
                );
              },
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.chip3,
                ),
                height: 58,
                width: 58,
                child: const Icon(Icons.add, color: Colors.white, size: 32),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 🔹 Reusable Chip Widget
  Widget _chip(String text, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.35),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: AppTypography.family,
          fontWeight: FontWeight.w600,
          color: bgColor,
          fontSize: 13,
        ),
      ),
    );
  }
}
