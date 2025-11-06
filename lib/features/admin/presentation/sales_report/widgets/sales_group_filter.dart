import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class SellsGroupFilter extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const SellsGroupFilter({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final options = ['Science', 'Arts', 'Commerce'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:
          options.map((e) {
            final bool isSelected = e == selected;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: isSelected ? 10 : 0,
                      sigmaY: isSelected ? 10 : 0,
                    ),
                    child: GestureDetector(
                      onTap: () => onSelected(e),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? Colors.white.withValues(alpha: 0.15)
                                  : Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            e,
                            style: TextStyle(
                              fontFamily: AppTypography.family,
                              color: Colors.white,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}
