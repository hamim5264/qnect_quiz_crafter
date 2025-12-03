// // lib/features/teacher/course_management/presentation/my_courses/widgets/teacher_course_card.dart
//
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import '../../../../../../ui/design_system/tokens/colors.dart';
// import '../../../../../../ui/design_system/tokens/typography.dart';
// import '../../../models/teacher_course_model.dart';
//
// class TeacherCourseCard extends StatelessWidget {
//   final TeacherCourseModel course;
//
//   const TeacherCourseCard({super.key, required this.course});
//
//   @override
//   Widget build(BuildContext context) {
//     final statusColor = {
//       CourseStatus.draft: Colors.orange,
//       CourseStatus.pending: Colors.blue,
//       CourseStatus.approved: Colors.green,
//       CourseStatus.rejected: Colors.red,
//     }[course.status]!;
//
//     final remainingDays = course.endDate
//         .difference(DateTime.now())
//         .inDays
//         .clamp(0, 999);
//
//     return GestureDetector(
//       onTap: () {
//         context.pushNamed(
//           'teacherCourseDetails',
//           extra: course,
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 16),
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: AppColors.white,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 46,
//               height: 46,
//               decoration: BoxDecoration(
//                 color: AppColors.primaryLight,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Image.asset(
//                 course.iconPath,
//                 fit: BoxFit.contain,
//               ),
//             ),
//             const SizedBox(width: 14),
//
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     course.title,
//                     style: const TextStyle(
//                       fontFamily: AppTypography.family,
//                       fontWeight: FontWeight.w700,
//                       fontSize: 16,
//                       color: AppColors.textPrimary,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     '${course.group} • ${course.level}',
//                     style: const TextStyle(
//                       fontFamily: AppTypography.family,
//                       color: Colors.black54,
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     'Remaining days: $remainingDays',
//                     style: const TextStyle(
//                       fontFamily: AppTypography.family,
//                       fontSize: 12,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 10,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: statusColor.withOpacity(0.15),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     course.status.name.toUpperCase(),
//                     style: TextStyle(
//                       color: statusColor,
//                       fontFamily: AppTypography.family,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   '${course.quizCount} Quizzes',
//                   style: const TextStyle(
//                     fontFamily: AppTypography.family,
//                     color: Colors.black,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// lib/features/teacher/course_management/presentation/my_courses/widgets/teacher_course_card.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../../ui/design_system/tokens/typography.dart';
import '../../../models/teacher_course_model.dart';

class TeacherCourseCard extends StatelessWidget {
  final TeacherCourseModel course;
  final VoidCallback onPublish;

  const TeacherCourseCard({
    super.key,
    required this.course,
    required this.onPublish,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = {
      CourseStatus.draft: Colors.orange,
      CourseStatus.pending: Colors.blue,
      CourseStatus.approved: Colors.green,
      CourseStatus.rejected: Colors.red,
    }[course.status]!;

    final quizCount = course.quizCount;
    final durationDays = course.endDate.difference(course.startDate).inDays;
    final enrolledCount = course.enrolledCount;
    final remainingDays =
    course.endDate.difference(DateTime.now()).inDays.clamp(0, 999);

    final publishEnabled = course.status == CourseStatus.draft ||
        course.status == CourseStatus.rejected;

    return SizedBox(
      width: 170,
      height: 255,              // ⭐ FIXED HEIGHT — prevents overflow
      child: GestureDetector(
        onTap: () {
          context.pushNamed(
            "teacherCourseDetails",
            extra: course,
          );
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Column(
            children: [
              // ICON
          Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.chip3,
            borderRadius: BorderRadius.circular(8),   // ⭐ instead of circle
          ),
          child: Image.asset(
            course.iconPath,
            height: 40,
            width: 40,
            fit: BoxFit.contain,
          ),
        ),

          const SizedBox(height: 10),

              // TITLE
              Text(
                course.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 6),

              // STATUS CHIP
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  course.status.name.toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontFamily: AppTypography.family,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // INFO LIST
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _info("Quizzes", "$quizCount", CupertinoIcons.book),
                    _info("Duration", "$durationDays days", CupertinoIcons.time),
                    _info(
                        "Enrollments", "$enrolledCount", CupertinoIcons.person_2),
                    _info(
                        "Remaining", "$remainingDays days", CupertinoIcons.calendar),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // PUBLISH BUTTON
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     onPressed: publishEnabled ? onPublish : null,
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor:
              //       publishEnabled ? AppColors.primaryLight : Colors.grey,
              //       padding: const EdgeInsets.symmetric(vertical: 10),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(14),
              //       ),
              //     ),
              //     child: Text(
              //       publishEnabled ? "Publish" : "Locked",
              //       style: TextStyle(
              //         fontFamily: AppTypography.family,
              //         color: publishEnabled ? Colors.white : Colors.black45,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ),
              // ),
              // PUBLISH BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // -------------------------------
                    // QUIZ COUNT VALIDATION (MUST >= 5)
                    // -------------------------------
                    if (quizCount < 5) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          backgroundColor: AppColors.primaryLight,
                          title: const Text(
                            "Not Enough Quizzes",
                            style: TextStyle(
                              fontFamily: AppTypography.family,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                            ),
                          ),
                          content: Text(
                            "To publish this course, you must add at least 5 quizzes.\n\n"
                                "Current quizzes: $quizCount",
                            style: const TextStyle(
                              fontFamily: AppTypography.family,
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("OK",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: AppTypography.family,
                                  )),
                            ),
                          ],
                        ),
                      );
                      return; // STOP EXECUTION
                    }

                    // -------------------------------------------------------
                    // QUIZ >= 5 → ALLOW PUBLISH
                    // -------------------------------------------------------
                    if (publishEnabled) {
                      onPublish();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: publishEnabled
                        ? AppColors.primaryLight
                        : Colors.grey.shade400,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    publishEnabled ? "Publish" : "Locked",
                    style: TextStyle(
                      color: publishEnabled ? Colors.white : Colors.black45,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppTypography.family,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _info(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14, color: AppColors.primaryLight),
          const SizedBox(width: 4),
          Text(
            "$label: ",
            style: const TextStyle(
              fontFamily: AppTypography.family,
              fontSize: 11,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: AppTypography.family,
              fontWeight: FontWeight.w700,
              fontSize: 11,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
