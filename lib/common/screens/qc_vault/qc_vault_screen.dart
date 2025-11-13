import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../ui/design_system/tokens/colors.dart';
import '../../../common/widgets/common_rounded_app_bar.dart';
import 'controller/qc_vault_controller.dart';
import 'widgets/qc_vault_filter_bar.dart';
import 'widgets/qc_vault_course_card.dart';
import '../../../common/widgets/skeleton/qc_vault_course_skeleton.dart';

class QCVaultScreen extends ConsumerStatefulWidget {
  const QCVaultScreen({super.key});

  @override
  ConsumerState<QCVaultScreen> createState() => _QCVaultScreenState();
}

class _QCVaultScreenState extends ConsumerState<QCVaultScreen> {
  String selectedGroup = "HSC";
  String selectedLevel = "Science";

  @override
  Widget build(BuildContext context) {
    final filter = QCVaultFilter(group: selectedGroup, level: selectedLevel);

    final coursesAsync = ref.watch(qcVaultCoursesProvider(filter));

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: 'QC Vault'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              QCVaultFilterBar(
                selectedGroup: selectedGroup,
                selectedLevel: selectedLevel,
                onGroupChanged: (value) {
                  setState(() => selectedGroup = value);
                },
                onLevelChanged: (value) {
                  setState(() => selectedLevel = value);
                },
              ),
              const SizedBox(height: 14),

              Expanded(
                child: coursesAsync.when(
                  data: (courses) {
                    if (courses.isEmpty) {
                      return const Center(
                        child: Text(
                          'No courses found',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    return GridView.builder(
                      itemCount: courses.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            childAspectRatio: 0.70,
                          ),
                      itemBuilder: (context, index) {
                        final course = courses[index];
                        return QCVaultCourseCard(
                          icon: Icons.menu_book_rounded,
                          title: course.title,
                          questions: course.totalQuestions,
                          onView: () {
                            context.push(
                              '/qc-vault-view/${course.id}/${course.title}',
                            );
                          },
                          onAdd: () {
                            context.push(
                              '/qc-vault-add-question/${course.id}/${course.title}',
                            );
                          },
                        );
                      },
                    );
                  },

                  loading:
                      () => GridView.builder(
                        itemCount: 6,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                              childAspectRatio: 0.70,
                            ),
                        itemBuilder: (_, __) => const QCVaultCourseSkeleton(),
                      ),

                  error:
                      (e, st) => Center(
                        child: Text(
                          'Error: $e',
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
