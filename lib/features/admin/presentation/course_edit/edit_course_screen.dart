import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qnect_quiz_crafter/common/widgets/action_success_dialog.dart';
import 'package:qnect_quiz_crafter/common/widgets/app_loader.dart';
import '../../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../../ui/design_system/tokens/colors.dart';

import 'widgets/edit_course_fields.dart';
import 'widgets/edit_course_dropdowns.dart';
import 'widgets/edit_course_price_card.dart';
import 'widgets/edit_course_switch.dart';
import 'widgets/edit_course_update_button.dart';
import 'widgets/edit_course_icon_picker.dart';

class EditCourseScreen extends StatefulWidget {
  final String courseId;

  const EditCourseScreen({super.key, required this.courseId});

  @override
  State<EditCourseScreen> createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  final titleController = TextEditingController();
  final subtitleController = TextEditingController();
  final priceController = TextEditingController();

  String selectedGroup = "";
  String selectedLevel = "";
  String selectedIcon = "Select Course Icon";

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  String selectedDiscount = "0%";
  bool applyDiscount = false;
  bool hasChanged = false;

  Map<String, dynamic>? course;

  @override
  void initState() {
    super.initState();
    loadCourseData();
  }

  Future<void> loadCourseData() async {
    final doc =
        await FirebaseFirestore.instance
            .collection("courses")
            .doc(widget.courseId)
            .get();

    if (!doc.exists) return;

    course = doc.data();

    titleController.text = course?["title"] ?? "";
    subtitleController.text = course?["description"] ?? "";
    priceController.text = "${course?["price"] ?? 0}";

    selectedGroup = course?["group"] ?? "Science";
    selectedLevel = course?["level"] ?? "HSC";
    selectedIcon = course?["iconPath"] ?? "Select Course Icon";

    startDate = _convertDate(course?["startDate"]);
    endDate = _convertDate(course?["endDate"]);

    selectedDiscount = "${course?["discountPercent"] ?? 0}%";

    applyDiscount = (course?["discountPercent"] ?? 0) > 0;

    setState(() {});
  }

  DateTime _convertDate(dynamic dt) {
    if (dt == null) return DateTime.now();
    if (dt is Timestamp) return dt.toDate();
    if (dt is String) return DateTime.tryParse(dt) ?? DateTime.now();
    return DateTime.now();
  }

  double get totalPrice {
    final price = double.tryParse(priceController.text) ?? 0;
    final discount = int.tryParse(selectedDiscount.replaceAll('%', '')) ?? 0;
    return applyDiscount ? (price - (price * discount / 100)) : price;
  }

  void markChanged() => setState(() => hasChanged = true);

  Future<void> saveCourse() async {
    final price = double.tryParse(priceController.text) ?? 0;
    final discount = int.tryParse(selectedDiscount.replaceAll('%', '')) ?? 0;

    await FirebaseFirestore.instance
        .collection("courses")
        .doc(widget.courseId)
        .update({
          "title": titleController.text.trim(),
          "description": subtitleController.text.trim(),
          "price": price,
          "discountPercent": applyDiscount ? discount : 0,
          "group": selectedGroup,
          "level": selectedLevel,
          "iconPath": selectedIcon,
          "startDate": startDate.toIso8601String(),
          "endDate": endDate.toIso8601String(),
          "updatedAt": DateTime.now().toIso8601String(),
        });
  }

  @override
  Widget build(BuildContext context) {
    if (course == null) {
      return const Scaffold(
        backgroundColor: AppColors.primaryDark,
        body: Center(child: AppLoader()),
      );
    }

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
                onChanged: (v) {
                  selectedGroup = v!;
                  markChanged();
                },
              ),

              EditCourseDropdown(
                hint: 'Level',
                value: selectedLevel,
                items: const ['HSC', 'SSC', 'Admission'],
                onChanged: (v) {
                  selectedLevel = v!;
                  markChanged();
                },
              ),

              EditCourseIconPicker(
                selectedIcon: selectedIcon,
                onIconSelected: (v) {
                  selectedIcon = v;
                  markChanged();
                },
              ),
              const SizedBox(height: 10),

              EditCourseDatePicker(
                hint: 'Start Date',
                initialDate: startDate,
                onDateSelected: (date) {
                  startDate = date;
                  markChanged();
                },
              ),

              EditCourseDatePicker(
                hint: 'End Date',
                initialDate: endDate,
                onDateSelected: (date) {
                  endDate = date;
                  markChanged();
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
                onChanged: (v) {
                  selectedDiscount = v!;
                  markChanged();
                },
              ),

              EditCourseSwitch(
                value: applyDiscount,
                onChanged: (v) {
                  applyDiscount = v;
                  markChanged();
                },
              ),

              const SizedBox(height: 10),

              EditCoursePriceCard(
                totalPrice: totalPrice,
                originalPrice: double.tryParse(priceController.text) ?? 0,
              ),

              const SizedBox(height: 20),

              EditCourseUpdateButton(
                isActive: hasChanged,
                onPressed: () async {
                  await saveCourse();

                  showDialog(
                    context: context,
                    builder:
                        (_) => ActionSuccessDialog(
                          title: 'Success',
                          message: 'Course updated successfully.',
                          onConfirm: () => Navigator.pop(context),
                        ),
                  );

                  setState(() => hasChanged = false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
