import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class MessageSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const MessageSearchBar({super.key, required this.onChanged});

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
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.white70),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  cursorColor: AppColors.secondaryDark,
                  textInputAction: TextInputAction.search,
                  onChanged: onChanged,
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    fillColor: Colors.transparent,
                    filled: false,
                    hintText: 'Search messages & people',
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
