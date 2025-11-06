import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../ui/design_system/tokens/colors.dart';
import '../../ui/design_system/tokens/typography.dart';

class CommonDatePicker extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final String? label;

  const CommonDatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.label,
  });

  Future<void> _pickDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.secondaryDark,
              onPrimary: Colors.black,
              surface: AppColors.primaryLight,
              onSurface: Colors.white,
              secondary: Colors.white,
            ),
            textTheme: Theme.of(context).textTheme.copyWith(
              titleLarge: const TextStyle(
                fontFamily: AppTypography.family,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              bodyLarge: const TextStyle(
                fontFamily: AppTypography.family,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: AppColors.primaryDark,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: child!,
          ),
        );
      },
    );

    if (date != null) onDateSelected(date);
  }

  @override
  Widget build(BuildContext context) {
    final formatted =
        '${selectedDate.day} ${_month(selectedDate.month)} ${selectedDate.year}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(left: 6, bottom: 6),
            child: Text(
              label!,
              style: const TextStyle(
                fontFamily: AppTypography.family,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatted,
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _pickDate(context),
                    child: const Icon(
                      CupertinoIcons.calendar,
                      color: Colors.white70,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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
