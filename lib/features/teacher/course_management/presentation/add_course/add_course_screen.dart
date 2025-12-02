import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

      appBar: const CommonRoundedAppBar(
        title: "Add New Course",
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // TITLE
            AddCourseField(
              hint: "Course Title",
              onChanged: controller.updateTitle,
            ),

            AddCourseField(
              hint: "Course Description",
              maxLines: 2,
              onChanged: controller.updateDescription,
            ),

            // PRICE FIELD
            AddCourseField(
              hint: "Price (BDT)",
              keyboardType: TextInputType.number,
              onChanged: controller.updatePrice,
            ),

            // GROUP
            AddCourseDropdown(
              hint: "Group",
              value: state.group,
              items: const ["Science", "Arts", "Commerce"],
              onChanged: controller.updateGroup,
            ),

            // LEVEL
            AddCourseDropdown(
              hint: "Level",
              value: state.level,
              items: const ["HSC", "SSC", "Admission"],
              onChanged: controller.updateLevel,
            ),

            // ICON PICKER
            AddCourseIconPicker(
              selectedIcon: state.iconPath,
              onSelect: controller.updateIcon,
            ),

            // START DATE
            AddCourseDatePicker(
              hint: "Start Date",
              date: state.startDate,
              onSelect: controller.updateStartDate,
            ),

            // END DATE
            AddCourseDatePicker(
              hint: "End Date",
              date: state.endDate,
              onSelect: controller.updateEndDate,
            ),

            const SizedBox(height: 12),

            // PRICE SUMMARY
            AddCoursePriceCard(
              originalPrice: state.price,
              applyDiscount: state.applyDiscount,
              discountPercent: state.discountPercent,
            ),

            const SizedBox(height: 22),

            // SUBMIT BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: state.isSubmitting
                    ? null
                    : () async {
                  await controller.submit();
                  if (context.mounted) {
                    context.pop(); // go back to My Courses
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryDark,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: state.isSubmitting
                    ? const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.black,
                )
                    : const Text(
                  "Create Course",
                  style: TextStyle(
                    fontFamily: AppTypography.family,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
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
