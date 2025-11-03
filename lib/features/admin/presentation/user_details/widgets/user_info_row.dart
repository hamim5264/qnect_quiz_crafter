import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class UserInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool hasDropdown;
  final bool hasSwitch;
  final List<String>? dropdownItems;
  final String? selectedValue;
  final Function(String)? onChanged;
  final bool? switchValue;
  final Function(bool)? onSwitchChanged;

  const UserInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.hasDropdown = false,
    this.hasSwitch = false,
    this.dropdownItems,
    this.selectedValue,
    this.onChanged,
    this.switchValue,
    this.onSwitchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.secondaryDark.withValues(alpha: 0.30),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 110,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            decoration: BoxDecoration(
              color: AppColors.secondaryDark,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppTypography.family,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 13.5,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      color: AppColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                ),

                if (hasDropdown && dropdownItems != null && onChanged != null)
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedValue ?? value,
                      icon: const Icon(
                        LucideIcons.chevronDown,
                        size: 18,
                        color: AppColors.textPrimary,
                      ),
                      dropdownColor: AppColors.primaryDark,
                      borderRadius: BorderRadius.circular(8),
                      style: const TextStyle(
                        fontFamily: AppTypography.family,
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      items:
                          dropdownItems!
                              .map(
                                (item) => DropdownMenuItem(
                                  value: item,
                                  child: Text(item),
                                ),
                              )
                              .toList(),
                      onChanged: (val) {
                        if (val != null) onChanged!(val);
                      },
                    ),
                  ),

                if (hasSwitch && switchValue != null && onSwitchChanged != null)
                  Switch(
                    value: switchValue!,
                    onChanged: onSwitchChanged,
                    activeColor: AppColors.chip3,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
