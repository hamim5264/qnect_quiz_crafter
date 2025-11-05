import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class FeedbackSearchBar extends StatelessWidget {
  const FeedbackSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 45,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            children: [
              Icon(Icons.search, color: Colors.white70),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  style: TextStyle(
                    fontFamily: AppTypography.family,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    filled: false,
                    enabledBorder: InputBorder.none,
                    fillColor: Colors.transparent,
                    focusedBorder: InputBorder.none,
                    border: InputBorder.none,
                    hintText: 'Search Course',
                    hintStyle: TextStyle(
                      color: Colors.white54,
                      fontFamily: AppTypography.family,
                    ),
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
