// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import '../../../../../ui/design_system/tokens/colors.dart';
// import '../../../../../ui/design_system/tokens/typography.dart';
//
// class QuizQuestionsHeader extends StatelessWidget {
//   const QuizQuestionsHeader({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           GestureDetector(
//             onTap: () => Navigator.pop(context),
//             child: const CircleAvatar(
//               backgroundColor: AppColors.primaryDark,
//               radius: 22,
//               child: Icon(CupertinoIcons.back, color: Colors.white),
//             ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               const Text(
//                 "General Knowledge",
//                 style: TextStyle(
//                   fontFamily: AppTypography.family,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                   fontSize: 18,
//                 ),
//               ),
//               const SizedBox(height: 6),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 18,
//                   vertical: 6,
//                 ),
//                 decoration: BoxDecoration(
//                   color: AppColors.white,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Row(
//                   children: [
//                     SizedBox(
//                       height: 28,
//                       width: 28,
//                       child: Lottie.asset(
//                         'assets/icons/quiz_time.json',
//                         repeat: true,
//                         animate: true,
//                       ),
//                     ),
//                     SizedBox(width: 4),
//                     Text(
//                       "15 min",
//                       style: TextStyle(
//                         fontFamily: AppTypography.family,
//                         color: AppColors.textPrimary,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 13,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class QuizQuestionsHeader extends StatelessWidget {
  final String quizTitle;
  final Duration quizDuration;

  const QuizQuestionsHeader({
    super.key,
    required this.quizTitle,
    required this.quizDuration,
  });

  String formatDuration(Duration d) {
    if (d.inMinutes < 1) return "${d.inSeconds}s";
    return "${d.inMinutes} min";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const CircleAvatar(
              backgroundColor: AppColors.primaryDark,
              radius: 22,
              child: Icon(CupertinoIcons.back, color: Colors.white),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                quizTitle, // 🔥 Real title
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
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
                      formatDuration(quizDuration), // 🔥 Real quiz time
                      style: const TextStyle(
                        fontFamily: AppTypography.family,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

