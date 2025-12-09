import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = "All";
  late Future<Set<String>> _purchasedCourseIdsFuture;

  @override
  void initState() {
    super.initState();
    _purchasedCourseIdsFuture = _fetchPurchasedCourseIds();

    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<Set<String>> _fetchPurchasedCourseIds() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {};

    final snap =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('myCourses')
            .get();

    final ids = <String>{};
    for (final doc in snap.docs) {
      final data = doc.data();
      final cid = (data['courseId'] as String?) ?? doc.id;
      ids.add(cid);
    }
    return ids;
  }

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
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: "App Paid Courses"),
      body: FutureBuilder<Set<String>>(
        future: _purchasedCourseIdsFuture,
        builder: (context, purchasedSnap) {
          if (purchasedSnap.connectionState == ConnectionState.waiting) {
            return const Center(child: AppLoader());
          }

          final purchasedIds = purchasedSnap.data ?? <String>{};

          return Column(
            children: [
              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF073131),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.white70, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(
                            fontFamily: AppTypography.family,
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search courses...",
                            filled: false,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintStyle: TextStyle(
                              fontFamily: AppTypography.family,
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildFilterChip("All"),
                    const SizedBox(width: 8),
                    _buildFilterChip("New"),
                    const SizedBox(width: 8),
                    _buildFilterChip("HSC"),
                    const SizedBox(width: 8),
                    _buildFilterChip("SSC"),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.doc_text_fill, size: 60, color: Colors.white70,),
                            Text(
                              "No paid courses available",
                              style: TextStyle(
                                fontFamily: AppTypography.family,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final searchText =
                        _searchController.text.trim().toLowerCase();

                    final filteredDocs =
                        docs.where((doc) {
                          final data =
                              doc.data() as Map<String, dynamic>? ?? {};

                          final title = (data["title"] ?? "") as String;
                          final level = (data["level"] ?? "") as String;

                          final createdAt = _toDate(data["createdAt"]);

                          final matchesSearch = title.toLowerCase().contains(
                            searchText,
                          );

                          final matchesFilter =
                              _selectedFilter == "All" ||
                              _selectedFilter == level ||
                              (_selectedFilter == "New" &&
                                  createdAt.isAfter(
                                    DateTime.now().subtract(
                                      const Duration(days: 30),
                                    ),
                                  ));

                          return matchesSearch && matchesFilter;
                        }).toList();

                    if (filteredDocs.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.doc_text_fill, size: 60, color: Colors.white70,),
                            Text(
                              "No courses found",
                              style: TextStyle(
                                fontFamily: AppTypography.family,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredDocs.length,
                      itemBuilder: (_, i) {
                        final doc = filteredDocs[i];
                        final data = doc.data() as Map<String, dynamic>? ?? {};

                        final courseId = doc.id;

                        final bool alreadyBought = purchasedIds.contains(
                          courseId,
                        );

                        final courseMap = <String, dynamic>{
                          ...data,
                          "id": courseId,
                          "teacherName": data["teacherName"] ?? "Teacher",
                          "enrolledCount": data["enrolledCount"] ?? 0,
                          "alreadyBought": alreadyBought,
                        };

                        return PaidCourseCard(
                          course: courseMap,
                          // onBuy: () {
                          //   const studentGroup = "Science";
                          //   const studentLevel = "HSC";
                          //
                          //   final group = data["group"];
                          //   final level = data["level"];
                          //
                          //   if (group != studentGroup ||
                          //       level != studentLevel) {
                          //     ScaffoldMessenger.of(context).showSnackBar(
                          //       const SnackBar(
                          //         content: Text(
                          //           "You can only buy courses from your Group & Level!",
                          //         ),
                          //       ),
                          //     );
                          //     return;
                          //   }
                          //
                          //   context.pushNamed(
                          //     "studentBuyCourse",
                          //     extra: {"id": courseId, ...data},
                          //   );
                          // },
                          onBuy: () {
                            final user = FirebaseAuth.instance.currentUser;
                            if (user == null) return;

                            // READ ROLE SAFELY
                            FirebaseFirestore.instance.collection('users').doc(user.uid).get().then((snap) {
                              final role = snap.data()?['role'] ?? 'student';

                              if (role != "student") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.redAccent,
                                    content: Text("Only students can buy courses.", style: TextStyle(color: Colors.white,),),
                                  ),
                                );
                                return;
                              }

                              // Existing student validation ↓
                              const studentGroup = "Science";
                              const studentLevel = "HSC";

                              final group = data["group"];
                              final level = data["level"];

                              if (group != studentGroup || level != studentLevel) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.redAccent,
                                    content: Text("You can only buy courses from your Group & Level!"),
                                  ),
                                );
                                return;
                              }

                              context.pushNamed(
                                "studentBuyCourse",
                                extra: {"id": courseId, ...data},
                              );
                            });
                          },

                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final bool selected = _selectedFilter == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.secondaryDark : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? AppColors.secondaryDark : Colors.white30,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: AppTypography.family,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}
