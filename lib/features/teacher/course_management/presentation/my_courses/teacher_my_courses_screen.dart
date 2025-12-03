import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../../common/widgets/app_loader.dart';

import '../../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

import '../../../../course_management/data/models/course_model.dart';
import '../../../course_management/providers/teacher_course_providers.dart';

import '../../providers/my_courses_filters.dart';
import 'widgets/teacher_course_card.dart';

class TeacherMyCoursesScreen extends ConsumerWidget {
  const TeacherMyCoursesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchText = ref.watch(courseSearchProvider);
    final statusFilter = ref.watch(courseStatusFilterProvider);
    final publishFilter = ref.watch(publishFilterProvider);

    final data = ref.watch(teacherCoursesStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: "My Courses"),

      body: Column(
        children: [
          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged:
                  (v) => ref.read(courseSearchProvider.notifier).state = v,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search course...",
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.white12,
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _filterChip(ref, "All", statusFilter),
                _filterChip(ref, "draft", statusFilter),
                _filterChip(ref, "pending", statusFilter),
                _filterChip(ref, "approved", statusFilter),
                _filterChip(ref, "rejected", statusFilter),
              ],
            ),
          ),

          const SizedBox(height: 6),

          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _publishChip(ref, "All", publishFilter),
                _publishChip(ref, "published", publishFilter),
                _publishChip(ref, "unpublished", publishFilter),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: data.when(
              loading: () => const Center(child: AppLoader()),

              error:
                  (e, _) => Center(
                    child: Text(
                      "Error loading courses: $e",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),

              data: (courses) {
                final filtered =
                    courses.where((c) {
                      final matchSearch = c.title.toLowerCase().contains(
                        searchText.toLowerCase(),
                      );

                      final matchStatus =
                          (statusFilter == "All") ||
                          (c.status.name == statusFilter);

                      final isPublished = c.status == CourseStatus.approved;

                      final matchPublish =
                          publishFilter == "All" ||
                          (publishFilter == "published" && isPublished) ||
                          (publishFilter == "unpublished" && !isPublished);

                      return matchSearch && matchStatus && matchPublish;
                    }).toList();

                if (filtered.isEmpty) {
                  return const Center(
                    child: Text(
                      "No courses found",
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.52,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) {
                    return TeacherCourseCard(
                      course: filtered[i],
                      onPublish: () async {
                        final db = FirebaseFirestore.instance;

                        await db
                            .collection("courses")
                            .doc(filtered[i].id)
                            .update({
                              "status": "pending",
                              "updatedAt": FieldValue.serverTimestamp(),
                            });

                        await db
                            .collection("notifications")
                            .doc("admin-panel")
                            .collection("items")
                            .add({
                              "type": "course_publish_request",
                              "courseId": filtered[i].id,
                              "teacherId": filtered[i].teacherId,
                              "title": filtered[i].title,
                              "timestamp": FieldValue.serverTimestamp(),
                              "isRead": false,
                            });
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.secondaryDark,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () => context.pushNamed("teacherAddCourse"),
      ),
    );
  }

  Widget _filterChip(WidgetRef ref, String label, String selected) {
    final isSelected = label == selected;

    return GestureDetector(
      onTap: () => ref.read(courseStatusFilterProvider.notifier).state = label,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondaryDark : Colors.white12,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white70,
            fontFamily: AppTypography.family,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _publishChip(WidgetRef ref, String label, String selected) {
    final isSelected = label == selected;

    return GestureDetector(
      onTap: () => ref.read(publishFilterProvider.notifier).state = label,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.chip2 : Colors.white12,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white70,
            fontFamily: AppTypography.family,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
