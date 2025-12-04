// FILE: student_buy_course_screen.dart
// PATH: lib/features/student/paid_courses/presentation/screens/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:qnect_quiz_crafter/common/widgets/app_loader.dart';
import 'package:qnect_quiz_crafter/common/widgets/common_rounded_app_bar.dart';

import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class StudentBuyCourseScreen extends StatefulWidget {
  final Map<String, dynamic> course;

  const StudentBuyCourseScreen({super.key, required this.course});

  @override
  State<StudentBuyCourseScreen> createState() => _StudentBuyCourseScreenState();
}

class _StudentBuyCourseScreenState extends State<StudentBuyCourseScreen> {
  bool loading = false;

  // ----------------------------------------------------------------
  // START PAYMENT
  // ----------------------------------------------------------------
  Future<void> _startPayment() async {
    setState(() => loading = true);

    final course = widget.course;
    final price = (course["price"] ?? 0).toInt();
    final discount = (course["discountPercent"] ?? 0).toInt();
    final applyDiscount = course["applyDiscount"] ?? false;

    final finalPrice = applyDiscount
        ? price - ((price * discount ~/ 100))
        : price;

    final tranId = DateTime.now().millisecondsSinceEpoch.toString();

    Sslcommerz sslcommerz = Sslcommerz(
      initializer: SSLCommerzInitialization(
        store_id: "deven680f75b061425",
        store_passwd: "devEngine@hamim2025",
        total_amount: finalPrice.toDouble(),
        currency: SSLCurrencyType.BDT,
        tran_id: tranId,
        product_category: "Course",
        sdkType: SSLCSdkType.TESTBOX,
      ),
    );

    var result = await sslcommerz.payNow();

    if (result is PlatformException) {
      setState(() => loading = false);
      _showError();
      return;
    }

    // Success
    await _enrollStudent(finalPrice, tranId);
    _showSuccess();
  }

  // ----------------------------------------------------------------
  // SAVE PURCHASE + NOTIFICATIONS + RECEIPT
  // ----------------------------------------------------------------
  // Future<void> _enrollStudent(int paidAmount, String tranId) async {
  //   final db = FirebaseFirestore.instance;
  //   final usr = FirebaseAuth.instance.currentUser!;
  //   final courseId = widget.course["id"];
  //   final teacherId = widget.course["teacherId"];
  //
  //   // 1) Save Payment Receipt
  //   await db
  //       .collection("users")
  //       .doc(usr.uid)
  //       .collection("paymentHistory")
  //       .doc(tranId)
  //       .set({
  //     "transactionId": tranId,
  //     "courseId": courseId,
  //     "courseTitle": widget.course["title"],
  //     "paidAmount": paidAmount,
  //     "timestamp": FieldValue.serverTimestamp(),
  //     "status": "success",
  //   });
  //
  //   // 2) Add to myCourses
  //   await db
  //       .collection("users")
  //       .doc(usr.uid)
  //       .collection("myCourses")
  //       .doc(courseId)
  //       .set({
  //     "courseId": courseId,
  //     "boughtAt": FieldValue.serverTimestamp(),
  //     "paidAmount": paidAmount,
  //     "tranId": tranId,
  //   });
  //
  //   // 3) Update course counters
  //   await db.collection("courses").doc(courseId).update({
  //     "enrolledCount": FieldValue.increment(1),
  //     "sold": FieldValue.increment(1),
  //   });
  //
  //   // 4) Notify Teacher
  //   await db
  //       .collection("notifications")
  //       .doc(teacherId)
  //       .collection("items")
  //       .add({
  //     "type": "course_sold",
  //     "courseId": courseId,
  //     "studentId": usr.uid,
  //     "amount": paidAmount,
  //     "timestamp": FieldValue.serverTimestamp(),
  //     "isRead": false,
  //   });
  //
  //   // 5) Notify Admin
  //   await db
  //       .collection("notifications")
  //       .doc("admin-panel")
  //       .collection("items")
  //       .add({
  //     "type": "course_sold_admin",
  //     "courseId": courseId,
  //     "teacherId": teacherId,
  //     "studentId": usr.uid,
  //     "amount": paidAmount,
  //     "timestamp": FieldValue.serverTimestamp(),
  //     "isRead": false,
  //   });
  //
  //   // 6) Give XP / Level
  //   await db.collection("users").doc(usr.uid).update({
  //     "xp": FieldValue.increment(10),
  //     "level": FieldValue.increment(1),
  //   });
  //
  //   setState(() => loading = false);
  // }
  Future<void> _enrollStudent(int paidAmount, String tranId) async {
    final db = FirebaseFirestore.instance;
    final usr = FirebaseAuth.instance.currentUser!;
    final courseId = widget.course["id"];
    final teacherId = widget.course["teacherId"];

    // SAVE PAYMENT RECEIPT
    await db
        .collection("users")
        .doc(usr.uid)
        .collection("paymentHistory")
        .doc(tranId)
        .set({
      "transactionId": tranId,
      "courseId": courseId,
      "courseTitle": widget.course["title"],
      "paidAmount": paidAmount,
      "timestamp": FieldValue.serverTimestamp(),
      "status": "success",
    });

    // ADD TO MY COURSES + INITIAL PROGRESS
    await db
        .collection("users")
        .doc(usr.uid)
        .collection("myCourses")
        .doc(courseId)
        .set({
      "courseId": courseId,
      "boughtAt": FieldValue.serverTimestamp(),
      "paidAmount": paidAmount,
      "tranId": tranId,
      "totalQuizzes": widget.course["quizCount"] ?? 0,
      "completedQuizzes": 0,
    });

    // UPDATE COURSE ENROLL COUNT
    await db.collection("courses").doc(courseId).update({
      "enrolledCount": FieldValue.increment(1),
      "sold": FieldValue.increment(1),
    });

    // SEND NOTIFICATION TO TEACHER
    await db
        .collection("notifications")
        .doc(teacherId)
        .collection("items")
        .add({
      "type": "course_sold",
      "courseId": courseId,
      "studentId": usr.uid,
      "amount": paidAmount,
      "timestamp": FieldValue.serverTimestamp(),
      "isRead": false,
    });

    // SEND NOTIFICATION TO ADMIN
    await db
        .collection("notifications")
        .doc("admin-panel")
        .collection("items")
        .add({
      "type": "course_sold_admin",
      "courseId": courseId,
      "teacherId": teacherId,
      "studentId": usr.uid,
      "amount": paidAmount,
      "timestamp": FieldValue.serverTimestamp(),
      "isRead": false,
    });

    // GIVE USER XP
    await db.collection("users").doc(usr.uid).update({
      "xp": FieldValue.increment(10),
    });

    setState(() => loading = false);
  }



  // ----------------------------------------------------------------
  // SUCCESS DIALOG
  // ----------------------------------------------------------------
  void _showSuccess() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Payment Successful 🎉"),
        content: const Text(
            "Your payment is successful.\nYour course has been added to your library."),
        actions: [
          TextButton(
            onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------
  // ERROR DIALOG
  // ----------------------------------------------------------------
  void _showError() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Payment Failed ❌"),
        content: const Text(
            "Your payment could not be completed.\nPlease try again.\nIf money is deducted, contact support."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------
  // BUILD UI
  // ----------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final c = widget.course;
    final price = (c["price"] ?? 0).toInt();
    final discount = (c["discountPercent"] ?? 0).toInt();
    final finalPrice = price - ((price * discount) ~/ 100);

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: CommonRoundedAppBar(
          title: "Confirm Purchase"
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: loading
            ? const Center(child: AppLoader())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // COURSE BOX
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c["title"] ?? "Course",
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Text(
                        "৳ $finalPrice",
                        style: const TextStyle(
                          fontFamily: AppTypography.family,
                          color: Colors.greenAccent,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "৳ $price",
                        style: const TextStyle(
                          color: Colors.redAccent,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "-$discount%",
                        style: const TextStyle(
                          color: Colors.yellowAccent,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.warning_amber_rounded,
                          color: Colors.orangeAccent, size: 22),
                      SizedBox(width: 8),
                      Text(
                        "Important Guidelines",
                        style: TextStyle(
                          fontFamily: AppTypography.family,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("•  ", style: TextStyle(color: Colors.white70)),
                      Expanded(
                        child: Text(
                          "This purchase is non-refundable.",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("•  ", style: TextStyle(color: Colors.white70)),
                      Expanded(
                        child: Text(
                          "If payment fails but money is deducted, contact support.",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("•  ", style: TextStyle(color: Colors.white70)),
                      Expanded(
                        child: Text(
                          "Course will be permanently added to your account after payment.",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    "Support: devenginesoftsolution@gmail.com",
                    style: TextStyle(
                      color: Colors.lightBlueAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _startPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Pay Now",
                  style: TextStyle(
                    fontFamily: AppTypography.family,
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
