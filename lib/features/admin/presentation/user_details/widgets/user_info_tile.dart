import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class UserInfoTile extends StatelessWidget {
  final String label;
  final String value;
  final bool hasDropdown;
  final bool hasSwitch;
  final List<String>? dropdownItems;
  final Function(String)? onChanged;
  final bool? switchValue;
  final Function(bool)? onSwitchChanged;

  const UserInfoTile({
    super.key,
    required this.label,
    required this.value,
    this.hasDropdown = false,
    this.hasSwitch = false,
    this.dropdownItems,
    this.onChanged,
    this.switchValue,
    this.onSwitchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.chip3,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: 50,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.chip3,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.5,
                ),
              ),
            ),
          ),

          Expanded(
            flex: 3,
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      value,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: AppTypography.family,
                        fontSize: 12.5,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),

                  if (hasDropdown && dropdownItems != null && onChanged != null)
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: value,
                        selectedItemBuilder:
                            (context) =>
                                dropdownItems!
                                    .map((_) => const SizedBox.shrink())
                                    .toList(),
                        icon: const Icon(
                          LucideIcons.chevronDown,
                          color: AppColors.textPrimary,
                          size: 20,
                        ),
                        dropdownColor: AppColors.primaryLight,
                        menuWidth: 120,

                        borderRadius: BorderRadius.circular(8),
                        style: const TextStyle(
                          fontFamily: AppTypography.family,
                          color: Colors.white,
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

                  if (hasSwitch &&
                      switchValue != null &&
                      onSwitchChanged != null)
                    Switch(
                      value: switchValue!,
                      onChanged: onSwitchChanged,
                      activeColor: AppColors.chip3,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
