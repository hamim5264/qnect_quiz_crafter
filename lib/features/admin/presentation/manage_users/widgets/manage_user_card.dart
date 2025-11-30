import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class ManageUserCard extends StatelessWidget {
  final String name;
  final String email;
  final String? image;
  final String role;

  const ManageUserCard({
    super.key,
    required this.name,
    required this.email,
    required this.image,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.grey.shade300,
            backgroundImage:
                (image != null && image!.isNotEmpty)
                    ? NetworkImage(image!)
                    : null,
            child:
                (image == null || image!.isEmpty)
                    ? const Icon(Icons.person, size: 28, color: Colors.black54)
                    : null,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  email,
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final currentUid = FirebaseAuth.instance.currentUser!.uid;

                      final userSnap =
                          await FirebaseFirestore.instance
                              .collection("users")
                              .where("email", isEqualTo: email)
                              .limit(1)
                              .get();

                      if (userSnap.docs.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("User not found")),
                        );
                        return;
                      }

                      final peerDoc = userSnap.docs.first;
                      final peerUid = peerDoc.id;

                      final peerFirst = peerDoc["firstName"] ?? "";
                      final peerLast = peerDoc["lastName"] ?? "";
                      final peerFullName = "$peerFirst $peerLast".trim();

                      final chatId =
                          currentUid.compareTo(peerUid) < 0
                              ? '${currentUid}_$peerUid'
                              : '${peerUid}_$currentUid';

                      context.pushNamed(
                        'chat',
                        extra: {
                          'chatId': chatId,
                          'peerId': peerUid,
                          'name': peerFullName,
                          'avatar': peerDoc["profileImage"] ?? "",
                          'isActive': true,
                          'peerRole': role.toLowerCase(),
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryLight,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Send Message",
                      style: TextStyle(
                        fontFamily: AppTypography.family,
                        fontSize: 13.5,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          GestureDetector(
            onTap: () {
              context.push('/user-details/$role', extra: email);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryDark.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                LucideIcons.chevronRight,
                color: AppColors.textPrimary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
