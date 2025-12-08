// import 'package:flutter/material.dart';
// import '../../../../../ui/design_system/tokens/colors.dart';
// import '../../../../../ui/design_system/tokens/typography.dart';
//
// class UserListDialog extends StatelessWidget {
//   final String role;
//
//   const UserListDialog({super.key, required this.role});
//
//   @override
//   Widget build(BuildContext context) {
//     final users =
//         role == 'Teacher'
//             ? ['Mr. Anik', 'Ms. Runa', 'Dr. Hasan', 'Prof. Rubel']
//             : ['Hamim', 'Rafiul', 'Araf', 'Sadia'];
//
//     return Dialog(
//       backgroundColor: AppColors.primaryLight,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(18),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               "$role Users",
//               style: const TextStyle(
//                 fontFamily: AppTypography.family,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//                 color: Colors.white,
//               ),
//             ),
//             const SizedBox(height: 12),
//             SizedBox(
//               height: 220,
//               child: ListView.builder(
//                 itemCount: users.length,
//                 itemBuilder: (context, i) {
//                   return ListTile(
//                     title: Text(
//                       users[i],
//                       style: const TextStyle(
//                         fontFamily: AppTypography.family,
//                         color: Colors.white,
//                       ),
//                     ),
//                     onTap: () => Navigator.pop(context, users[i]),
//                   );
//                 },
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
import 'package:qnect_quiz_crafter/common/widgets/app_loader.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class UserListDialog extends StatelessWidget {
  final String role;

  const UserListDialog({super.key, required this.role});

  Future<List<Map<String, dynamic>>> _fetchUsers() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: role.toLowerCase())
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();

        // 🔥 Name handling (STUDENT root + TEACHER nested “feedback”)
        String firstName = "";
        String lastName = "";

        if (data['firstName'] != null) {
          // Student / normal case
          firstName = data['firstName'];
          lastName = data['lastName'] ?? "";
        } else if (data['feedback'] != null) {
          // Teacher case
          firstName = data['feedback']['firstName'] ?? "";
          lastName = data['feedback']['lastName'] ?? "";
        }

        final fullName = "$firstName $lastName".trim();

        return {
          "uid": doc.id,
          "name": fullName.isEmpty ? "Unnamed User" : fullName,
          "level": data['level'] ?? 1,
          "xp": data['xp'] ?? 0,
        };
      }).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.primaryLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "$role Users",
              style: const TextStyle(
                fontFamily: AppTypography.family,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 230,
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: AppLoader(size: 32,),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "No users available",
                        style: TextStyle(
                          fontFamily: AppTypography.family,
                          color: Colors.white70,
                        ),
                      ),
                    );
                  }

                  final users = snapshot.data!;

                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, i) {
                      final user = users[i];

                      return ListTile(
                        title: Text(
                          user["name"],
                          style: const TextStyle(
                            fontFamily: AppTypography.family,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          "Level ${user['level']} | XP ${user['xp']}",
                          style: const TextStyle(
                            fontFamily: AppTypography.family,
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                        onTap: () => Navigator.pop(context, user),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
