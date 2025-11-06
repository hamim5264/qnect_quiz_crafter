import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class MessageSearchBar extends StatelessWidget {
  const MessageSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Row(
            children: [
              Icon(Icons.search, color: Colors.white70),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  cursorColor: AppColors.secondaryDark,
                  textInputAction: TextInputAction.search,
                  style: TextStyle(
                    fontFamily: AppTypography.family,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    fillColor: Colors.transparent,
                    filled: false,
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      fontFamily: AppTypography.family,
                      color: Colors.white54,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
