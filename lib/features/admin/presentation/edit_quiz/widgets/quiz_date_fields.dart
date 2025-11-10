import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class QuizDateFields extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final ValueChanged<DateTime> onStartChanged;
  final ValueChanged<DateTime> onEndChanged;

  const QuizDateFields({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onStartChanged,
    required this.onEndChanged,
  });

  Future<void> _pickDate(
    BuildContext context,
    DateTime initialDate,
    ValueChanged<DateTime> onDatePicked,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      builder:
          (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: AppColors.secondaryDark,
                surface: AppColors.primaryLight,
              ),
            ),
            child: child!,
          ),
    );
    if (picked != null) onDatePicked(picked);
  }

  @override
  Widget build(BuildContext context) {
    String format(DateTime d) => "${d.day} ${_month(d.month)} ${d.year}";

    return Column(
      children: [
        GestureDetector(
          onTap: () => _pickDate(context, startDate, onStartChanged),
          child: _dateTile(format(startDate)),
        ),
        GestureDetector(
          onTap: () => _pickDate(context, endDate, onEndChanged),
          child: _dateTile(format(endDate)),
        ),
      ],
    );
  }

  Widget _dateTile(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
              fontFamily: AppTypography.family,
            ),
          ),
          const Icon(CupertinoIcons.calendar, color: Colors.white70),
        ],
      ),
    );
  }

  String _month(int m) =>
      [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec",
      ][m - 1];
}
