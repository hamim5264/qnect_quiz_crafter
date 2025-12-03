import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qnect_quiz_crafter/common/widgets/app_loader.dart';

import '../../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

import '../../../course_management/providers/teacher_course_form_providers.dart';
import 'widgets/add_course_field.dart';
import 'widgets/add_course_dropdown.dart';
import 'widgets/add_course_date_picker.dart';
import 'widgets/add_course_icon_picker.dart';
import 'widgets/add_course_price_card.dart';

class TeacherAddCourseScreen extends ConsumerWidget {
  const TeacherAddCourseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(teacherCourseFormControllerProvider);
    final controller = ref.read(teacherCourseFormControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.primaryDark,

      appBar: const CommonRoundedAppBar(title: "Add New Course"),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AddCourseField(
              hint: "Course Title",
              onChanged: controller.updateTitle,
            ),

            AddCourseField(
              hint: "Course Description",
              maxLines: 2,
              onChanged: controller.updateDescription,
            ),

            AddCourseField(
              hint: "Price (BDT)",
              keyboardType: TextInputType.number,
              onChanged: controller.updatePrice,
            ),

            AddCourseDropdown(
              hint: "Group",
              value: state.group,
              items: const ["Science", "Arts", "Commerce"],
              onChanged: controller.updateGroup,
            ),

            AddCourseDropdown(
              hint: "Level",
              value: state.level,
              items: const ["HSC", "SSC", "Admission"],
              onChanged: controller.updateLevel,
            ),

            AddCourseIconPicker(
              selectedIcon: state.iconPath,
              onSelect: controller.updateIcon,
            ),

            AddCourseDatePicker(
              hint: "Start Date",
              date: state.startDate,
              onSelect: controller.updateStartDate,
            ),

            AddCourseDatePicker(
              hint: "End Date",
              date: state.endDate,
              onSelect: controller.updateEndDate,
            ),

            const SizedBox(height: 12),

            AddCoursePriceCard(
              originalPrice: state.price,
              applyDiscount: state.applyDiscount,
              discountPercent: state.discountPercent,
            ),

            const SizedBox(height: 22),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    state.isSubmitting
                        ? null
                        : () async {
                          await controller.submit();
                          if (context.mounted) {
                            context.pop();
                          }
                        },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryLight,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child:
                    state.isSubmitting
                        ? AppLoader(size: 28)
                        : const Text(
                          "Create Course",
                          style: TextStyle(
                            fontFamily: AppTypography.family,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
