import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class QuizDateFilter extends StatelessWidget {
  final String dateFilter;
  final ValueChanged<String> onFilterChange;

  const QuizDateFilter({
    super.key,
    required this.dateFilter,
    required this.onFilterChange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          dateFilter,
          style: const TextStyle(
            fontFamily: AppTypography.family,
            color: Colors.white70,
            fontSize: 15,
          ),
        ),
        IconButton(
          onPressed:
              () => onFilterChange(dateFilter == "All" ? "Today" : "All"),
          icon: const Icon(
            CupertinoIcons.slider_horizontal_3,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}
