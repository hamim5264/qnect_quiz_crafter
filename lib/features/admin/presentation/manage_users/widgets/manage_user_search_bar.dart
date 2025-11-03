import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class ManageUserSearchBar extends StatelessWidget {
  const ManageUserSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: const [
            Icon(LucideIcons.search, color: Colors.white70, size: 20),
            SizedBox(width: 8),
            Expanded(
              child: TextField(
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: AppTypography.family,
                ),
                cursorColor: Colors.white70,
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  hintText: 'Search user by name',
                  hintStyle: TextStyle(
                    color: Colors.white60,
                    fontFamily: AppTypography.family,
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
