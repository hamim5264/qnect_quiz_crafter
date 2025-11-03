import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class ManageUserFilterTabs extends StatefulWidget {
  final Function(String) onFilterChanged;
  final String selectedFilter;

  const ManageUserFilterTabs({
    super.key,
    required this.onFilterChanged,
    required this.selectedFilter,
  });

  @override
  State<ManageUserFilterTabs> createState() => _ManageUserFilterTabsState();
}

class _ManageUserFilterTabsState extends State<ManageUserFilterTabs> {
  final tabs = ['Teacher', 'Student', 'Blocked'];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isActive = widget.selectedFilter == tabs[index];
          return Expanded(
            child: GestureDetector(
              onTap: () => widget.onFilterChanged(tabs[index]),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color:
                      isActive ? AppColors.secondaryDark : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      fontFamily: AppTypography.family,
                      color: isActive ? Colors.black : Colors.white70,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
