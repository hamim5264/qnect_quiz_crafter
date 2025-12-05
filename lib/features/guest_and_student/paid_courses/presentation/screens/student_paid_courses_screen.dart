// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:qnect_quiz_crafter/common/widgets/app_loader.dart';
// import 'package:qnect_quiz_crafter/common/widgets/common_rounded_app_bar.dart';
// import '../../../../../ui/design_system/tokens/colors.dart';
// import '../../../../../ui/design_system/tokens/typography.dart';
//
// class StudentPaidCoursesScreen extends StatelessWidget {
//   const StudentPaidCoursesScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.primaryDark,
//
//       appBar: CommonRoundedAppBar(
//           title: "App Paid Courses"
//       ),
//
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection("courses")
//             .where("status", isEqualTo: "Approved")
//             .snapshots(),
//
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(
//               child: AppLoader(),
//             );
//           }
//
//           final docs = snapshot.data!.docs;
//
//           if (docs.isEmpty) {
//             return const Center(
//               child: Text(
//                 "No paid courses available",
//                 style: TextStyle(
//                   fontFamily: AppTypography.family,
//                   color: Colors.white70,
//                 ),
//               ),
//             );
//           }
//
//           return ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: docs.length,
//             itemBuilder: (_, i) {
//               final c = docs[i].data() as Map<String, dynamic>;
//               final id = docs[i].id;
//
//               // Calculate discounted price
//               final price = (c["price"] ?? 0).toInt();
//               final discount = (c["discountPercent"] ?? 0).toInt();
//               final finalPrice = discount > 0
//                   ? price - ((price * discount) ~/ 100)
//                   : price;
//
//               return _courseCard(
//                 context,
//                 id,
//                 c,
//                 price,
//                 finalPrice,
//                 discount,
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   // ---------------------------------------------------------------------------
//   // BEAUTIFUL COURSE CARD UI
//   // ---------------------------------------------------------------------------
//
//   Widget _courseCard(
//       BuildContext context,
//       String courseId,
//       Map<String, dynamic> c,
//       int price,
//       int finalPrice,
//       int discount,
//       ) {
//     final iconPath = c["iconPath"] ?? "assets/icons/default.png";
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(16),
//
//       decoration: BoxDecoration(
//         color: const Color(0xFF123334),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.primaryLight.withValues(alpha: 0.95),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           )
//         ],
//       ),
//
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ------------------- TOP ROW (ICON + TITLE) --------------------
//           Row(
//             children: [
//               Container(
//                 height: 52,
//                 width: 52,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 padding: const EdgeInsets.all(6),
//                 child: Image.asset(iconPath, fit: BoxFit.contain),
//               ),
//
//               const SizedBox(width: 12),
//
//               Expanded(
//                 child: Text(
//                   c["title"] ?? "",
//                   style: const TextStyle(
//                     fontFamily: AppTypography.family,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                     fontSize: 18,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 8),
//
//           // ------------------- DESCRIPTION --------------------
//           Text(
//             c["description"] ?? "",
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(
//               fontFamily: AppTypography.family,
//               color: Colors.white70,
//               fontSize: 13,
//             ),
//           ),
//
//           const SizedBox(height: 12),
//
//           // ------------------- GROUP & LEVEL TAGS --------------------
//           Row(
//             children: [
//               _pill("${c["group"]}", Colors.blueAccent),
//               const SizedBox(width: 6),
//               _pill("${c["level"]}", Colors.orangeAccent),
//             ],
//           ),
//
//           const SizedBox(height: 16),
//
//           // ------------------- PRICE ROW --------------------
//           // ------------------- PRICE ROW --------------------
//           Row(
//             children: [
//               // FINAL PRICE ALWAYS CALCULATED FROM discountPercent
//               Text(
//                 "৳ $finalPrice",
//                 style: const TextStyle(
//                   fontFamily: AppTypography.family,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.greenAccent,
//                   fontSize: 20,
//                 ),
//               ),
//
//               if (discount > 0) ...[
//                 const SizedBox(width: 8),
//
//                 // ORIGINAL PRICE
//                 Text(
//                   "৳ $price",
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: Colors.redAccent,
//                     decoration: TextDecoration.lineThrough,
//                   ),
//                 ),
//
//                 const SizedBox(width: 6),
//
//                 // DISCOUNT LABEL
//                 Text(
//                   "-$discount% Off",
//                   style: const TextStyle(
//                     fontFamily: AppTypography.family,
//                     color: Colors.orangeAccent,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ],
//           ),
//
//
//           const SizedBox(height: 18),
//
//           // ------------------- BUY NOW BUTTON --------------------
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.secondaryDark,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//               ),
//
//               onPressed: () {
//                 final studentGroup = "Science"; // get later from user profile
//                 final studentLevel = "HSC";     // get later from user profile
//
//                 if (c["group"] != studentGroup || c["level"] != studentLevel) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text(
//                         "You can only buy courses from your Group & Level!",
//                       ),
//                     ),
//                   );
//                   return;
//                 }
//
//                 context.pushNamed(
//                   "studentBuyCourse",
//                   extra: {
//                     "id": courseId,
//                     ...c,
//                   },
//                 );
//               },
//
//               child: const Text(
//                 "Buy Now",
//                 style: TextStyle(
//                   fontFamily: AppTypography.family,
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   // --------------------- SMALL PILL TAG ---------------------
//   Widget _pill(String text, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.25),
//         borderRadius: BorderRadius.circular(30),
//         border: Border.all(color: color.withOpacity(0.7)),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           fontFamily: AppTypography.family,
//           color: color,
//           fontWeight: FontWeight.bold,
//           fontSize: 12,
//         ),
//       ),
//     );
//   }
// }


// FILE: lib/features/guest_and_student/paid_courses/presentation/screens/student_paid_courses_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/app_loader.dart';
import '../../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import '../widgets/paid_course_card.dart';

class StudentPaidCoursesScreen extends StatefulWidget {
  const StudentPaidCoursesScreen({super.key});

  @override
  State<StudentPaidCoursesScreen> createState() =>
      _StudentPaidCoursesScreenState();
}

class _StudentPaidCoursesScreenState extends State<StudentPaidCoursesScreen> {
  String searchQuery = '';
  String selectedFilter = 'All'; // All | New | HSC | SSC

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  // Safe converter for Timestamp / String / null
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

  Future<Map<String, dynamic>> _loadExtraData({
    required String teacherId,
    required String uid,
    required String courseId,
  }) async {
    String teacherName = 'Course Teacher';
    bool alreadyBought = false;

    // 🔹 Teacher name
    if (teacherId.isNotEmpty) {
      final tSnap =
      await _db.collection('users').doc(teacherId).get();
      final tData = tSnap.data();
      if (tData != null) {
        teacherName = (tData['firstName'] ?? teacherName) as String;
      }
    }

    // 🔹 Already bought check
    final myCourseSnap = await _db
        .collection('users')
        .doc(uid)
        .collection('myCourses')
        .doc(courseId)
        .get();

    alreadyBought = myCourseSnap.exists;

    return {
      'teacherName': teacherName,
      'alreadyBought': alreadyBought,
    };
  }

  @override
  Widget build(BuildContext context) {
    final uid = _auth.currentUser!.uid;

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(
        title: "App Paid Courses",
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),

          // 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.trim().toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: "Search courses...",
                hintStyle: const TextStyle(
                  fontFamily: AppTypography.family,
                  color: Colors.white70,
                  fontSize: 13,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withOpacity(0.08),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 0, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(
                fontFamily: AppTypography.family,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // 🔘 FILTER ROW
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _filterChip('All'),
                const SizedBox(width: 8),
                _filterChip('New'),
                const SizedBox(width: 8),
                _filterChip('HSC'),
                const SizedBox(width: 8),
                _filterChip('SSC'),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // 📄 COURSE LIST
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _db
                  .collection("courses")
                  .where("status", isEqualTo: "Approved")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: AppLoader());
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
                    final data =
                    docs[i].data() as Map<String, dynamic>;
                    final courseId = docs[i].id;

                    final title =
                    (data['title'] ?? '').toString().toLowerCase();
                    final level =
                    (data['level'] ?? '').toString();
                    final createdAt = _toDate(data['createdAt']);

                    // 🔍 Search filter
                    final matchesSearch = title.contains(searchQuery);

                    // 🎯 Filter logic
                    final bool matchesFilter =
                        selectedFilter == "All" ||
                            selectedFilter == level ||
                            (selectedFilter == "New" &&
                                createdAt.isAfter(DateTime.now()
                                    .subtract(const Duration(days: 30))));

                    if (!matchesSearch || !matchesFilter) {
                      return const SizedBox.shrink();
                    }

                    final teacherId =
                    (data['teacherId'] ?? '').toString();

                    return FutureBuilder<Map<String, dynamic>>(
                      future: _loadExtraData(
                        teacherId: teacherId,
                        uid: uid,
                        courseId: courseId,
                      ),
                      builder: (context, extraSnap) {
                        if (!extraSnap.hasData) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          );
                        }

                        final extra = extraSnap.data!;

                        final mergedCourse = {
                          ...data,
                          'id': courseId,
                          'teacherName': extra['teacherName'],
                          'alreadyBought': extra['alreadyBought'],
                        };

                        return PaidCourseCard(
                          course: mergedCourse,
                          onBuy: () {
                            // TODO: Replace with real student group/level later
                            final studentGroup = "Science";
                            final studentLevel = "HSC";

                            if (mergedCourse["group"] != studentGroup ||
                                mergedCourse["level"] != studentLevel) {
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
                                ...data,
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ------------------- FILTER CHIP WIDGET -------------------
  Widget _filterChip(String label) {
    final bool selected = selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.secondaryDark
              : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.secondaryDark : Colors.white24,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: AppTypography.family,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.black : Colors.white70,
          ),
        ),
      ),
    );
  }
}

