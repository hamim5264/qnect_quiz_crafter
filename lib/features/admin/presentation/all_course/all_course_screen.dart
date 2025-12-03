// import 'package:flutter/material.dart';
// import 'package:qnect_quiz_crafter/features/admin/presentation/all_course/widgets/ourse_card.dart';
// import '../../../../common/widgets/common_rounded_app_bar.dart';
// import '../../../../common/widgets/common_search_bar.dart';
// import '../../../../ui/design_system/tokens/colors.dart';
// import 'widgets/course_filter_card.dart';
//
// class AllCourseScreen extends StatefulWidget {
//   const AllCourseScreen({super.key});
//
//   @override
//   State<AllCourseScreen> createState() => _AllCourseScreenState();
// }
//
// class _AllCourseScreenState extends State<AllCourseScreen> {
//   String group = "All";
//   String level = "All";
//   String status = "All";
//
//   final TextEditingController searchController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.primaryDark,
//       appBar: const CommonRoundedAppBar(title: 'All Course'),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               CommonSearchBar(
//                 controller: searchController,
//                 hintText: 'Search course',
//                 onChanged: (value) {},
//               ),
//               const SizedBox(height: 14),
//
//               CourseFilterCard(
//                 selectedGroup: group,
//                 selectedLevel: level,
//                 selectedStatus: status,
//                 onChanged: (g, l, s) {
//                   setState(() {
//                     group = g;
//                     level = l;
//                     status = s;
//                   });
//                 },
//               ),
//               const SizedBox(height: 16),
//
//               Expanded(
//                 child: GridView.builder(
//                   itemCount: 6,
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 14,
//                     mainAxisSpacing: 14,
//                     childAspectRatio: 0.85,
//                   ),
//                   itemBuilder:
//                       (_, i) => CourseCard(
//                         title: 'Basic English',
//                         subtitle: 'Sentence, literature, parts of...',
//                         price: 899,
//                         discount: 122,
//                         status:
//                             i == 0
//                                 ? 'Pending'
//                                 : i == 1
//                                 ? 'Approved'
//                                 : 'Rejected',
//                       ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qnect_quiz_crafter/common/widgets/app_loader.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/all_course/widgets/ourse_card.dart';
import '../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../common/widgets/common_search_bar.dart';
import '../../../../ui/design_system/tokens/colors.dart';
import 'widgets/course_filter_card.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class AllCourseScreen extends ConsumerStatefulWidget {
  const AllCourseScreen({super.key});

  @override
  ConsumerState<AllCourseScreen> createState() => _AllCourseScreenState();
}

class _AllCourseScreenState extends ConsumerState<AllCourseScreen> {
  String group = "All";
  String level = "All";
  String status = "All";

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: 'All Course'),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CommonSearchBar(
                controller: searchController,
                hintText: 'Search course',
                onChanged: (_) => setState(() {}),
              ),
            ),

            const SizedBox(height: 14),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CourseFilterCard(
                selectedGroup: group,
                selectedLevel: level,
                selectedStatus: status,
                onChanged: (g, l, s) {
                  setState(() {
                    group = g;
                    level = l;
                    status = s;
                  });
                },
              ),
            ),

            const SizedBox(height: 14),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("courses")
                    .orderBy("createdAt", descending: true)
                    .snapshots(),
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return const Center(
                      child: AppLoader(size: 32,),
                    );
                  }

                  final docs = snap.data!.docs;

                  // FILTER
                  final filtered = docs.where((d) {
                    final data = d.data() as Map<String, dynamic>;
                    final title = (data["title"] ?? "").toString().toLowerCase();

                    final matchSearch = title.contains(
                      searchController.text.toLowerCase(),
                    );

                    final matchGroup =
                        group == "All" || data["group"] == group;

                    final matchLevel =
                        level == "All" || data["level"] == level;

                    final matchStatus =
                        status == "All" ||
                            (data["status"] ?? "draft")
                                .toString()
                                .toLowerCase() ==
                                status.toLowerCase();

                    return matchSearch && matchGroup && matchLevel && matchStatus;
                  }).toList();

                  // GRID UI
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      itemCount: filtered.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.85,
                      ),
                      itemBuilder: (_, i) {
                        final course = filtered[i].data() as Map<String, dynamic>;
                        final courseId = filtered[i].id;

                        return CourseCard(
                          title: course["title"] ?? "",
                          subtitle: course["description"] ?? "",
                          price: (course["price"] ?? 0).toInt(),
                          discount: course["discountPercent"] ?? 0,
                          iconPath: course["iconPath"] ?? "",
                          status:
                          (course["status"] ?? "draft").toString().capitalize(),
                          onView: () => context.pushNamed(
                            "adminCourseDetails",
                            extra: courseId,
                          ),
                        );
                      },
                    ),
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

extension CapExtension on String {
  String capitalize() =>
      isEmpty ? this : "${this[0].toUpperCase()}${substring(1)}";
}

