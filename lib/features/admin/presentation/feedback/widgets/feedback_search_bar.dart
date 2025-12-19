import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class FeedbackSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const FeedbackSearchBar({super.key, this.onChanged});

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
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.white70),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  onChanged: onChanged,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    filled: false,
                    enabledBorder: InputBorder.none,
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
