import 'package:flutter/material.dart';

import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class GuestQuestionCard extends StatelessWidget {
  final int index;
  final int total;
  final String questionText;
  final Map<String, String> options;
  final int? selectedIndex;
  final ValueChanged<int> onSelect;

  const GuestQuestionCard({
    super.key,
    required this.index,
    required this.total,
    required this.questionText,
    required this.options,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    const labels = ["A", "B", "C", "D"];
    final orderedOptions = labels.map((k) => options[k] ?? "").toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Question ${index + 1} of $total",
            style: const TextStyle(
              fontFamily: AppTypography.family,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            questionText,
            style: const TextStyle(
              fontFamily: AppTypography.family,
              fontSize: 16,
              color: Colors.black87,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: ListView.separated(
              itemCount: orderedOptions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final isSelected = selectedIndex == i;

                return GestureDetector(
                  onTap: () => onSelect(i),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? AppColors.secondaryDark.withValues(alpha: 0.25)
                              : const Color(0xFFEDEFF2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color:
                            isSelected
                                ? AppColors.primaryLight
                                : Colors.transparent,
                        width: 1.4,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 32,
                          width: 32,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? AppColors.primaryLight
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            labels[i],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            orderedOptions[i],
                            style: const TextStyle(
                              fontFamily: AppTypography.family,
                              fontSize: 15,
                              color: Colors.black87,
                              height: 1.25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
