import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class EditCourseField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final int maxLines;
  final VoidCallback onChanged;

  const EditCourseField({
    super.key,
    required this.hint,
    required this.controller,
    required this.onChanged,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        onChanged: (_) => onChanged(),
        maxLines: maxLines,
        style: const TextStyle(
          fontFamily: AppTypography.family,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontFamily: AppTypography.family,
            color: Colors.white70,
          ),
          filled: true,
          fillColor: AppColors.white.withValues(alpha: 0.1),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class EditCourseDatePicker extends StatefulWidget {
  final String hint;
  final DateTime? initialDate;
  final ValueChanged<DateTime> onDateSelected;

  const EditCourseDatePicker({
    super.key,
    required this.hint,
    this.initialDate,
    required this.onDateSelected,
  });

  @override
  State<EditCourseDatePicker> createState() => _EditCourseDatePickerState();
}

class _EditCourseDatePickerState extends State<EditCourseDatePicker> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate ?? DateTime.now();
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.secondaryDark,
              onPrimary: Colors.black,
              surface: AppColors.primaryLight,
              onSurface: Colors.white,
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: AppColors.primaryDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
      widget.onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatted =
        '${selectedDate.day} ${_month(selectedDate.month)} ${selectedDate.year}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => _pickDate(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatted.isEmpty ? widget.hint : formatted,
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  color: Colors.white70,
                ),
              ),
              const Icon(
                CupertinoIcons.calendar,
                color: Colors.white70,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _month(int m) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[m - 1];
  }
}
