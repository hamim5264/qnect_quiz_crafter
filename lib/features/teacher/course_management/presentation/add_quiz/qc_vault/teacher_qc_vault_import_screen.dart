import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qnect_quiz_crafter/common/widgets/app_loader.dart';

import 'package:qnect_quiz_crafter/common/widgets/common_rounded_app_bar.dart';
import 'package:qnect_quiz_crafter/ui/design_system/tokens/colors.dart';
import 'package:qnect_quiz_crafter/ui/design_system/tokens/typography.dart';

import '../../../../../../common/screens/qc_vault/controller/qc_vault_controller.dart';
import '../../../../../../common/screens/qc_vault/data/qc_vault_models.dart';

class TeacherQCVaultImportScreen extends ConsumerStatefulWidget {
  const TeacherQCVaultImportScreen({super.key});

  @override
  ConsumerState<TeacherQCVaultImportScreen> createState() =>
      _TeacherQCVaultImportScreenState();
}

class _TeacherQCVaultImportScreenState
    extends ConsumerState<TeacherQCVaultImportScreen> {
  static const _groups = ['HSC', 'SSC'];
  static const _levels = ['Science', 'Commerce', 'Arts', 'All'];

  String _selectedGroup = 'HSC';
  String _selectedLevel = 'Science';

  @override
  Widget build(BuildContext context) {
    final filter = QCVaultFilter(group: _selectedGroup, level: _selectedLevel);

    final coursesAsync = ref.watch(qcVaultCoursesProvider(filter));

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: 'Import From QC Vault'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _filterDropdown(
                      label: 'Group',
                      value: _selectedGroup,
                      items: _groups,
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() => _selectedGroup = v);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _filterDropdown(
                      label: 'Level',
                      value: _selectedLevel,
                      items: _levels,
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() => _selectedLevel = v);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Expanded(
                child: coursesAsync.when(
                  loading: () => const Center(child: AppLoader(size: 32)),
                  error:
                      (e, _) => Center(
                        child: Text(
                          'Failed to load QC Vault courses\n$e',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: AppTypography.family,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                  data: (courses) {
                    if (courses.isEmpty) {
                      return const Center(
                        child: Text(
                          'No QC Vault courses found\nfor this group & level.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppTypography.family,
                            color: Colors.white70,
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: courses.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final course = courses[index];
                        return _QCVaultCourseCard(
                          course: course,
                          onTap: () async {
                            final selected = await context.pushNamed(
                              'teacherQcVaultQuestions',
                              extra: course,
                            );

                            if (selected != null) {
                              context.pop(selected);
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white54, width: 1.4),
        color: Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    fontSize: 11,
                    color: Colors.white60,
                  ),
                ),
                const SizedBox(height: 2),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isDense: true,
                    isExpanded: true,
                    value: value,
                    dropdownColor: AppColors.primaryLight,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white70,
                    ),
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    items:
                        items
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                    onChanged: onChanged,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QCVaultCourseCard extends StatelessWidget {
  final QCVaultCourse course;
  final VoidCallback onTap;

  const _QCVaultCourseCard({required this.course, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                course.title.isNotEmpty ? course.title[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${course.group} • ${course.level}',
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.chip3.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${course.totalQuestions} Qs',
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.chip3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
