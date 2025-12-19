import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/common_rounded_app_bar.dart';
import '../../../ui/design_system/tokens/colors.dart';

import '../data/classroom_providers.dart';
import '../widgets/classroom_counter_row.dart';
import '../widgets/classroom_filter_switch.dart';
import '../widgets/classroom_shimmer.dart';
import '../widgets/classroom_user_card.dart';

enum ClassroomFilter { teachers, students, enrolled }

class ClassroomScreen extends ConsumerStatefulWidget {
  const ClassroomScreen({super.key});

  @override
  ConsumerState<ClassroomScreen> createState() => _ClassroomScreenState();
}

class _ClassroomScreenState extends ConsumerState<ClassroomScreen> {
  ClassroomFilter filter = ClassroomFilter.teachers;

  @override
  Widget build(BuildContext context) {
    final roleAsync = ref.watch(classroomRoleProvider);

    final teachersAsync = ref.watch(classroomTeachersProvider);
    final studentsAsync = ref.watch(classroomStudentsProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(
        title: "Classroom",
        subtitle: "Your Academic Space",
      ),
      body: roleAsync.when(
        loading: () => const ClassroomShimmer(),
        error: (_, __) => const SizedBox(),
        data: (role) {
          final isTeacher = role == 'teacher';

          final enrolledCountAsync =
              isTeacher ? ref.watch(classroomEnrolledCountProvider) : null;

          final enrolledStudentsAsync =
              isTeacher ? ref.watch(classroomEnrolledStudentsProvider) : null;

          if (!isTeacher && filter == ClassroomFilter.enrolled) {
            filter = ClassroomFilter.teachers;
          }

          return Column(
            children: [
              ClassroomCounterRow(
                teachers: teachersAsync.value?.length ?? 0,
                students: studentsAsync.value?.length ?? 0,
                enrolled: isTeacher ? enrolledCountAsync?.value ?? 0 : null,
              ),

              const SizedBox(height: 12),

              ClassroomFilterSwitch(
                value: filter,
                showEnrolled: isTeacher,
                onChanged: (v) => setState(() => filter = v),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: Builder(
                  builder: (_) {
                    switch (filter) {
                      case ClassroomFilter.teachers:
                        return _buildList(teachersAsync);

                      case ClassroomFilter.students:
                        return _buildList(studentsAsync);

                      case ClassroomFilter.enrolled:
                        return _buildList(enrolledStudentsAsync!);
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildList(AsyncValue<List<Map<String, dynamic>>> async) {
    return async.when(
      loading: () => const ClassroomShimmer(),
      error: (_, __) => const SizedBox(),
      data: (list) {
        if (list.isEmpty) {
          return const Center(
            child: Text(
              "No data found",
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (_, i) {
            return ClassroomUserCard(user: list[i]);
          },
        );
      },
    );
  }
}
