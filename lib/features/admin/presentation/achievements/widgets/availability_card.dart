// import 'package:flutter/material.dart';
// import '../../../../../ui/design_system/tokens/colors.dart';
// import '../../../../../ui/design_system/tokens/typography.dart';
// import 'user_list_dialog.dart';
//
// class AvailabilityCard extends StatelessWidget {
//   const AvailabilityCard({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.white.withValues(alpha: 0.1),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Availability',
//             style: TextStyle(
//               fontFamily: AppTypography.family,
//               fontWeight: FontWeight.bold,
//               fontSize: 18,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               _AvailabilityItem(
//                 title: 'Teacher Badges',
//                 count: 10,
//                 onTap:
//                     () => showDialog(
//                       context: context,
//                       builder: (_) => const UserListDialog(role: 'Teacher'),
//                     ),
//               ),
//               const SizedBox(width: 14),
//               _AvailabilityItem(
//                 title: 'Student Badges',
//                 count: 10,
//                 onTap:
//                     () => showDialog(
//                       context: context,
//                       builder: (_) => const UserListDialog(role: 'Student'),
//                     ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _AvailabilityItem extends StatelessWidget {
//   final String title;
//   final int count;
//   final VoidCallback onTap;
//
//   const _AvailabilityItem({
//     required this.title,
//     required this.count,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: AppColors.primaryLight.withValues(alpha: 0.7),
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Column(
//           children: [
//             Text(
//               '$count',
//               style: const TextStyle(
//                 fontFamily: AppTypography.family,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 28,
//                 color: AppColors.secondaryDark,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               title,
//               style: const TextStyle(
//                 fontFamily: AppTypography.family,
//                 fontSize: 13,
//                 color: Colors.white70,
//               ),
//             ),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: onTap,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.white,
//                 foregroundColor: AppColors.textPrimary,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 8,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//               ),
//               child: const Text(
//                 "View",
//                 style: TextStyle(
//                   fontFamily: AppTypography.family,
//                   fontWeight: FontWeight.w600,
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
import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import 'user_list_dialog.dart';

class AvailabilityCard extends StatelessWidget {
  const AvailabilityCard({super.key});

  Future<int> _countEligibleTeachers() async {
    final snap = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'teacher')
        .get();

    int count = 0;
    for (var doc in snap.docs) {
      final level = (doc.data()['level'] ?? 0).toInt();

      // Level >= 1 qualifies for at least one badge
      if (level >= 1) count++;
    }
    return count;
  }

  Future<int> _countEligibleStudents() async {
    final snap = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'student')
        .get();

    int count = 0;
    for (var doc in snap.docs) {
      final xp = (doc.data()['xp'] ?? 0).toInt();

      // XP >= 0 qualifies for basic badge
      if (xp >= 0) count++;
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Availability',
            style: TextStyle(
              fontFamily: AppTypography.family,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              // TEACHER CARD
              Expanded(
                child: FutureBuilder<int>(
                  future: _countEligibleTeachers(),
                  builder: (context, snap) {
                    final value = snap.data ?? 0;

                    return _AvailabilityItem(
                      title: 'Teacher Badges',
                      count: value,
                      onTap: () => showDialog(
                        context: context,
                        builder: (_) => const UserListDialog(role: 'Teacher'),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 14),

              // STUDENT CARD
              Expanded(
                child: FutureBuilder<int>(
                  future: _countEligibleStudents(),
                  builder: (context, snap) {
                    final value = snap.data ?? 0;

                    return _AvailabilityItem(
                      title: 'Student Badges',
                      count: value,
                      onTap: () => showDialog(
                        context: context,
                        builder: (_) => const UserListDialog(role: 'Student'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AvailabilityItem extends StatelessWidget {
  final String title;
  final int count;
  final VoidCallback onTap;

  const _AvailabilityItem({
    required this.title,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            '$count',
            style: const TextStyle(
              fontFamily: AppTypography.family,
              fontWeight: FontWeight.bold,
              fontSize: 28,
              color: AppColors.secondaryDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontFamily: AppTypography.family,
              fontSize: 13,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.textPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              "View",
              style: TextStyle(
                fontFamily: AppTypography.family,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
