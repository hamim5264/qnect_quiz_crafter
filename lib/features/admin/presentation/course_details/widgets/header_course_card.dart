// import 'package:flutter/material.dart';
// import '../../../../../ui/design_system/tokens/colors.dart';
// import '../../../../../ui/design_system/tokens/typography.dart';
//
// class HeaderCourseCard extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String fullDescription;
//   final String createdAtText;
//   final int price;
//   final int discountPercent;
//   final String iconPath;   // instead of IconData icon
//
//
//   const HeaderCourseCard({
//     super.key,
//     required this.icon,
//     required this.title,
//     required this.fullDescription,
//     required this.createdAtText,
//     required this.price,
//     required this.discountPercent,
//     required this.iconPath,
//
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: AppColors.white.withValues(alpha: 0.3),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Row(
//         children: [
//           Container(
//             height: 48,
//             width: 48,
//             decoration: BoxDecoration(
//               color: AppColors.white,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Image.asset(
//               iconPath,
//               height: 26,
//               width: 26,
//               fit: BoxFit.contain,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(
//                     fontFamily: AppTypography.family,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   fullDescription,
//                   maxLines: 4,
//                   style: const TextStyle(
//                     fontFamily: AppTypography.family,
//                     color: Colors.white70,
//                     fontSize: 13,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   createdAtText,
//                   style: const TextStyle(
//                     fontFamily: AppTypography.family,
//                     color: Colors.white60,
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class HeaderCourseCard extends StatelessWidget {
  final String iconPath;        // 🔥 NOW string path
  final String title;
  final String fullDescription;
  final String createdAtText;
  final int price;
  final int discountPercent;

  const HeaderCourseCard({
    super.key,
    required this.iconPath,
    required this.title,
    required this.fullDescription,
    required this.createdAtText,
    required this.price,
    required this.discountPercent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(
              iconPath,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
              const Icon(Icons.menu_book_rounded, color: AppColors.chip3),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  fullDescription,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  createdAtText,
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
