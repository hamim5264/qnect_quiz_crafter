// // FILE: paid_course_card.dart
// // PATH: lib/features/student/paid_courses/presentation/widgets/
//
// import 'package:flutter/material.dart';
// import '../../../../../ui/design_system/tokens/colors.dart';
// import '../../../../../ui/design_system/tokens/typography.dart';
//
// class PaidCourseCard extends StatelessWidget {
//   final Map<String, dynamic> course;
//   final VoidCallback onBuy;
//
//   const PaidCourseCard({
//     super.key,
//     required this.course,
//     required this.onBuy,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final int price = (course["price"] ?? 0).toInt();
//     final int discount = (course["discountPercent"] ?? 0).toInt();
//     final bool applyDiscount = course["applyDiscount"] ?? false;
//
//     // ⭐ CALCULATE TOTAL PRICE MANUALLY
//     final int finalPrice =
//     applyDiscount ? price - ((price * discount) ~/ 100) : price;
//
//     final String iconPath = course["iconPath"] ?? "assets/icons/default.png";
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF9E9E9),
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.white.withValues(alpha: 0.2),
//             blurRadius: 10,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ------------------------ ICON + TITLE ------------------------
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Icon
//               Container(
//                 height: 48,
//                 width: 48,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.black12),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(6),
//                   child: Image.asset(iconPath, fit: BoxFit.contain),
//                 ),
//               ),
//
//               const SizedBox(width: 12),
//
//               // Texts
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       course["title"],
//                       style: const TextStyle(
//                         fontFamily: AppTypography.family,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                         color: Colors.black87,
//                       ),
//                     ),
//
//                     const SizedBox(height: 4),
//
//                     Text(
//                       course["description"],
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                         fontFamily: AppTypography.family,
//                         color: Colors.black54,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 14),
//
//           // ------------------------ PRICE ROW ------------------------
//           Row(
//             children: [
//               // FINAL PRICE BUBBLE
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 14,
//                   vertical: 6,
//                 ),
//                 decoration: BoxDecoration(
//                   color: AppColors.primaryLight,
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: Text(
//                   "৳ $finalPrice",
//                   style: const TextStyle(
//                     fontFamily: AppTypography.family,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//
//               const SizedBox(width: 10),
//
//               // Original price crossed out
//               if (applyDiscount)
//                 Text(
//                   "৳ $price",
//                   style: const TextStyle(
//                     fontFamily: AppTypography.family,
//                     fontSize: 12,
//                     color: Colors.redAccent,
//                     decoration: TextDecoration.lineThrough,
//                   ),
//                 ),
//
//               const SizedBox(width: 8),
//
//               // % OFF TEXT
//               if (applyDiscount)
//                 Text(
//                   "-$discount% Off",
//                   style: const TextStyle(
//                     fontFamily: AppTypography.family,
//                     fontSize: 12,
//                     color: Colors.green,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//             ],
//           ),
//
//           const SizedBox(height: 16),
//
//           // ------------------------ BUY NOW ------------------------
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: onBuy,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.redAccent,
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//               ),
//               child: const Text(
//                 "Buy Now",
//                 style: TextStyle(
//                   fontFamily: AppTypography.family,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 15,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// FILE: paid_course_card.dart
// PATH: lib/features/student/paid_courses/presentation/widgets/

// FILE: lib/features/student/paid_courses/presentation/widgets/paid_course_card.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class PaidCourseCard extends StatelessWidget {
  final Map<String, dynamic> course;
  final VoidCallback onBuy;

  const PaidCourseCard({
    super.key,
    required this.course,
    required this.onBuy,
  });

  // 🔹 Safe converter for Timestamp / String / null
  DateTime _toDate(dynamic v) {
    if (v == null) return DateTime.now();
    if (v is Timestamp) return v.toDate();
    if (v is String) {
      try {
        return DateTime.parse(v);
      } catch (_) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final int price = (course["price"] ?? 0).toInt();
    final int discount = (course["discountPercent"] ?? 0).toInt();
    final bool applyDiscount = course["applyDiscount"] ?? false;

    // ⭐ FINAL PRICE
    final int finalPrice =
    applyDiscount ? price - ((price * discount) ~/ 100) : price;

    final String iconPath =
        course["iconPath"] ?? "assets/icons/default.png";

    // 📅 ENROLLMENT WINDOW:
    // startDate .. startDate + 10 days (inclusive)
    final DateTime startDate = _toDate(course["startDate"]);
    final DateTime enrollmentEnd =
    startDate.add(const Duration(days: 10));
    final DateTime now = DateTime.now();

    final bool enrollmentClosed = now.isAfter(enrollmentEnd);

    int daysLeft = 0;
    if (!enrollmentClosed) {
      daysLeft = enrollmentEnd.difference(now).inDays + 1;
      if (daysLeft < 0) daysLeft = 0;
    }

    // 🧾 ALREADY BOUGHT
    final bool alreadyBought = course["alreadyBought"] == true;

    // Disable when closed or already bought
    final bool disableBuyButton = enrollmentClosed || alreadyBought;

    final String teacherName =
    (course["teacherName"] ?? "Course Teacher").toString();
    final int enrolledCount =
    (course["enrolledCount"] ?? 0) as int;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9E9E9),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.white.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ------------------------ ICON + TITLE ------------------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Image.asset(iconPath, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(width: 12),

              // Texts
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course["title"] ?? "",
                      style: const TextStyle(
                        fontFamily: AppTypography.family,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      course["description"] ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: AppTypography.family,
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ------------------------ TEACHER + ENROLLED ------------------------
          Row(
            children: [
              const Icon(Icons.person, size: 16, color: Colors.black54),
              const SizedBox(width: 6),
              Text(
                "Teacher: $teacherName",
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
              const Spacer(),
              const Icon(Icons.group, size: 16, color: Colors.black54),
              const SizedBox(width: 6),
              Text(
                "$enrolledCount Enrolled",
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ------------------------ PRICE + ENROLLMENT LEFT ------------------------
          Row(
            children: [
              // FINAL PRICE BUBBLE
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "৳ $finalPrice",
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // Original price crossed out
              if (applyDiscount)
                Text(
                  "৳ $price",
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    fontSize: 12,
                    color: Colors.redAccent,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),

              const SizedBox(width: 8),

              // % OFF TEXT
              if (applyDiscount)
                Text(
                  "-$discount% Off",
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    fontSize: 12,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              const Spacer(),

              // 📅 Enrollment left
              Text(
                enrollmentClosed
                    ? "Enrollment closed"
                    : "$daysLeft days left",
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  fontSize: 11,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ------------------------ BUY NOW ------------------------
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: disableBuyButton
                  ? () {
                if (alreadyBought) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "You already purchased this course.",
                      ),
                    ),
                  );
                } else if (enrollmentClosed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Enrollment period has ended.",
                      ),
                    ),
                  );
                }
              }
                  : onBuy,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                disableBuyButton ? Colors.grey : Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                alreadyBought
                    ? "Purchased"
                    : enrollmentClosed
                    ? "Enrollment Closed"
                    : "Buy Now",
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


