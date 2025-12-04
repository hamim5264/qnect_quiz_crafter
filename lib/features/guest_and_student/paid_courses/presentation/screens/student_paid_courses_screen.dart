import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qnect_quiz_crafter/common/widgets/app_loader.dart';
import 'package:qnect_quiz_crafter/common/widgets/common_rounded_app_bar.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class StudentPaidCoursesScreen extends StatelessWidget {
  const StudentPaidCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,

      appBar: CommonRoundedAppBar(
          title: "App Paid Courses"
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("courses")
            .where("status", isEqualTo: "Approved")
            .snapshots(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: AppLoader(),
            );
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                "No paid courses available",
                style: TextStyle(
                  fontFamily: AppTypography.family,
                  color: Colors.white70,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final c = docs[i].data() as Map<String, dynamic>;
              final id = docs[i].id;

              // Calculate discounted price
              final price = (c["price"] ?? 0).toInt();
              final discount = (c["discountPercent"] ?? 0).toInt();
              final finalPrice = discount > 0
                  ? price - ((price * discount) ~/ 100)
                  : price;

              return _courseCard(
                context,
                id,
                c,
                price,
                finalPrice,
                discount,
              );
            },
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BEAUTIFUL COURSE CARD UI
  // ---------------------------------------------------------------------------

  Widget _courseCard(
      BuildContext context,
      String courseId,
      Map<String, dynamic> c,
      int price,
      int finalPrice,
      int discount,
      ) {
    final iconPath = c["iconPath"] ?? "assets/icons/default.png";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: const Color(0xFF123334),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryLight.withValues(alpha: 0.95),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ------------------- TOP ROW (ICON + TITLE) --------------------
          Row(
            children: [
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.all(6),
                child: Image.asset(iconPath, fit: BoxFit.contain),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  c["title"] ?? "",
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // ------------------- DESCRIPTION --------------------
          Text(
            c["description"] ?? "",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: AppTypography.family,
              color: Colors.white70,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 12),

          // ------------------- GROUP & LEVEL TAGS --------------------
          Row(
            children: [
              _pill("${c["group"]}", Colors.blueAccent),
              const SizedBox(width: 6),
              _pill("${c["level"]}", Colors.orangeAccent),
            ],
          ),

          const SizedBox(height: 16),

          // ------------------- PRICE ROW --------------------
          // ------------------- PRICE ROW --------------------
          Row(
            children: [
              // FINAL PRICE ALWAYS CALCULATED FROM discountPercent
              Text(
                "৳ $finalPrice",
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,
                  fontSize: 20,
                ),
              ),

              if (discount > 0) ...[
                const SizedBox(width: 8),

                // ORIGINAL PRICE
                Text(
                  "৳ $price",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.redAccent,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),

                const SizedBox(width: 6),

                // DISCOUNT LABEL
                Text(
                  "-$discount% Off",
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ],
          ),


          const SizedBox(height: 18),

          // ------------------- BUY NOW BUTTON --------------------
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),

              onPressed: () {
                final studentGroup = "Science"; // get later from user profile
                final studentLevel = "HSC";     // get later from user profile

                if (c["group"] != studentGroup || c["level"] != studentLevel) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "You can only buy courses from your Group & Level!",
                      ),
                    ),
                  );
                  return;
                }

                context.pushNamed(
                  "studentBuyCourse",
                  extra: {
                    "id": courseId,
                    ...c,
                  },
                );
              },

              child: const Text(
                "Buy Now",
                style: TextStyle(
                  fontFamily: AppTypography.family,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // --------------------- SMALL PILL TAG ---------------------
  Widget _pill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.25),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withOpacity(0.7)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: AppTypography.family,
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
