import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class QuizIconDropdown extends StatefulWidget {
  final IconData selectedIcon;
  final ValueChanged<IconData> onSelect;

  const QuizIconDropdown({
    super.key,
    required this.selectedIcon,
    required this.onSelect,
  });

  @override
  State<QuizIconDropdown> createState() => _QuizIconDropdownState();
}

class _QuizIconDropdownState extends State<QuizIconDropdown> {
  bool _showIcons = false;

  final List<IconData> quizIcons = const [
    LucideIcons.bookOpen,
    LucideIcons.brain,
    LucideIcons.target,
    LucideIcons.timer,
    LucideIcons.penTool,
    LucideIcons.messageCircle,
    LucideIcons.star,
    LucideIcons.checkCircle2,
    LucideIcons.activity,
    LucideIcons.lightbulb,
    LucideIcons.school,
    LucideIcons.clipboardList,
    LucideIcons.trophy,
    LucideIcons.flag,
    LucideIcons.puzzle,
    LucideIcons.play,
    LucideIcons.user,
    LucideIcons.microscope,
    LucideIcons.calculator,
    LucideIcons.globe,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _showIcons = !_showIcons),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(widget.selectedIcon, color: Colors.white, size: 22),
                    const SizedBox(width: 8),
                    const Text(
                      "Select Quiz Icon",
                      style: TextStyle(
                        fontFamily: AppTypography.family,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                Icon(
                  _showIcons
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: Colors.white70,
                ),
              ],
            ),
          ),
        ),

        if (_showIcons)
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: quizIcons.length,
              itemBuilder: (context, index) {
                final icon = quizIcons[index];
                final isSelected = widget.selectedIcon == icon;
                return GestureDetector(
                  onTap: () {
                    widget.onSelect(icon);
                    setState(() => _showIcons = false);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? AppColors.secondaryDark
                              : Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: isSelected ? Colors.black : Colors.white,
                      size: 24,
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
