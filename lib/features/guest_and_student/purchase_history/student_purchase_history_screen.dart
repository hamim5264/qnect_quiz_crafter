import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qnect_quiz_crafter/common/widgets/common_rounded_app_bar.dart';
import 'package:qnect_quiz_crafter/features/guest_and_student/purchase_history/widgets/purchase_card.dart';
import '../../../../ui/design_system/tokens/colors.dart';
import '../../../../ui/design_system/tokens/typography.dart';

class StudentPurchaseHistoryScreen extends StatelessWidget {
  const StudentPurchaseHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: CommonRoundedAppBar(title: "Purchase History",),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .collection("paymentHistory")
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CupertinoActivityIndicator(color: Colors.white),
            );
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                "No purchase history found.",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontFamily: AppTypography.family,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final docId = docs[index].id;

              return PurchaseCard(
                title: data["courseTitle"] ?? "",
                courseId: data["courseId"] ?? "",
                amount: data["paidAmount"] ?? 0,
                status: data["status"] ?? "Completed",
                date: data["timestamp"],
                onDelete: () {
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(uid)
                      .collection("paymentHistory")
                      .doc(docId)
                      .delete();
                },
              );
            },
          );
        },
      ),
    );
  }
}
