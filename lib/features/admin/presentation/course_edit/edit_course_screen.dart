import 'package:flutter/material.dart';
import 'package:qnect_quiz_crafter/common/widgets/action_success_dialog.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/course_edit/widgets/edit_course_icon_picker.dart';
import '../../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import 'widgets/edit_course_fields.dart';
import 'widgets/edit_course_dropdowns.dart';
import 'widgets/edit_course_price_card.dart';
import 'widgets/edit_course_switch.dart';
import 'widgets/edit_course_update_button.dart';

class EditCourseScreen extends StatefulWidget {
  const EditCourseScreen({super.key});

  @override
  State<EditCourseScreen> createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  final titleController = TextEditingController(text: 'English');
  final subtitleController = TextEditingController(
    text: 'Language, Grammar, Literature, Writing',
  );
  final priceController = TextEditingController(text: '750');

  String selectedGroup = 'Science';
  String selectedLevel = 'HSC';
  String selectedIcon = 'Select Course Icon';
  DateTime startDate = DateTime(2025, 10, 10);
  DateTime endDate = DateTime(2025, 12, 10);
  String selectedDiscount = '10%';
  bool applyDiscount = true;
  bool hasChanged = false;

  double get totalPrice {
    final price = double.tryParse(priceController.text) ?? 0;
    final discount = int.tryParse(selectedDiscount.replaceAll('%', '')) ?? 0;
    return applyDiscount ? (price - (price * discount / 100)) : price;
  }

  void markChanged() => setState(() => hasChanged = true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: 'Edit Course'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              EditCourseField(
                hint: 'Title',
                controller: titleController,
                onChanged: markChanged,
              ),
              EditCourseField(
                hint: 'Subtitle',
                controller: subtitleController,
                onChanged: markChanged,
                maxLines: 2,
              ),
              EditCourseField(
                hint: 'Price (BDT)',
                controller: priceController,
                onChanged: markChanged,
              ),
              EditCourseDropdown(
                hint: 'Group',
                value: selectedGroup,
                items: const ['Science', 'Arts', 'Commerce'],
                onChanged:
                    (v) => setState(() {
                      selectedGroup = v!;
                      markChanged();
                    }),
              ),
              EditCourseDropdown(
                hint: 'Level',
                value: selectedLevel,
                items: const ['HSC', 'SSC', 'Admission'],
                onChanged:
                    (v) => setState(() {
                      selectedLevel = v!;
                      markChanged();
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: EditCourseIconPicker(
                  selectedIcon: selectedIcon,
                  onIconSelected:
                      (v) => setState(() {
                        selectedIcon = v;
                        markChanged();
                      }),
                ),
              ),
              EditCourseDatePicker(
                hint: 'Start Date',
                initialDate: DateTime.now(),
                onDateSelected: (date) {
                  setState(() {
                    startDate = date;
                    hasChanged = true;
                  });
                },
              ),
              EditCourseDatePicker(
                hint: 'End Date',
                initialDate: DateTime.now().add(const Duration(days: 60)),
                onDateSelected: (date) {
                  setState(() {
                    endDate = date;
                    hasChanged = true;
                  });
                },
              ),

              EditCourseDropdown(
                hint: 'Discount',
                value: selectedDiscount,
                items: const [
                  '0%',
                  '10%',
                  '20%',
                  '30%',
                  '40%',
                  '50%',
                  '60%',
                  '70%',
                  '80%',
                  '90%',
                  'Free',
                ],
                onChanged:
                    (v) => setState(() {
                      selectedDiscount = v!;
                      markChanged();
                    }),
              ),
              EditCourseSwitch(
                value: applyDiscount,
                onChanged:
                    (v) => setState(() {
                      applyDiscount = v;
                      markChanged();
                    }),
              ),
              const SizedBox(height: 10),
              EditCoursePriceCard(
                totalPrice: totalPrice,
                originalPrice: double.tryParse(priceController.text) ?? 0,
              ),
              const SizedBox(height: 20),
              EditCourseUpdateButton(
                isActive: hasChanged,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (_) => ActionSuccessDialog(
                          title: 'Success',
                          message: 'The course has been updated successfully.',
                          onConfirm: () {
                            Navigator.pop(context);
                            setState(() => hasChanged = false);
                          },
                        ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
