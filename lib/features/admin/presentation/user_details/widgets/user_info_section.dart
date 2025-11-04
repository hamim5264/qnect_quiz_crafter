import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../common/widgets/common_confirm_dialog.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import 'user_info_tile.dart';

class UserInfoSection extends StatefulWidget {
  final String role;
  final String selectedStatus;
  final bool accessControl;
  final bool hasChanged;
  final Function(String) onStatusChanged;
  final Function(bool) onAccessChanged;
  final VoidCallback onUpdated;

  const UserInfoSection({
    super.key,
    required this.role,
    required this.selectedStatus,
    required this.accessControl,
    required this.hasChanged,
    required this.onStatusChanged,
    required this.onAccessChanged,
    required this.onUpdated,
  });

  @override
  State<UserInfoSection> createState() => _UserInfoSectionState();
}

class _UserInfoSectionState extends State<UserInfoSection> {
  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder:
          (_) => CommonConfirmDialog(
            title: "Delete!",
            message: "Are you sure you want to delete this user permanently?",
            icon: CupertinoIcons.delete,
            iconColor: Colors.white,
            confirmColor: Colors.redAccent,
            onConfirm: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "User deleted successfully",
                    style: TextStyle(fontFamily: AppTypography.family),
                  ),
                ),
              );
            },
          ),
    );
  }

  void _showAccessDialog(bool newValue) {
    showDialog(
      context: context,
      builder:
          (_) => CommonConfirmDialog(
            title: newValue ? "Unblock User!" : "Block User!",
            message:
                newValue
                    ? "Are you sure you want to unblock this user?"
                    : "Are you sure you want to block this user?",
            icon: CupertinoIcons.person_badge_minus,
            iconColor: Colors.white,
            confirmColor: newValue ? Colors.redAccent : Colors.redAccent,
            onConfirm: () => widget.onAccessChanged(newValue),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTeacher = widget.role == "Teacher";

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              height: 3.5,
              width: 120,
              decoration: BoxDecoration(
                color: AppColors.chip3,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),

          const SizedBox(height: 14),

          const UserInfoTile(
            label: "Email",
            value: "hena.quizcrafter@gmail.com",
          ),
          const UserInfoTile(label: "Phone", value: "+880 17** - XXXXXX"),
          const UserInfoTile(
            label: "Address",
            value: "Uttara, Sector-10, Dhaka",
          ),
          if (isTeacher)
            const UserInfoTile(
              label: "Resume Link",
              value: "https://www.resumefinder.hasna",
            ),
          if (!isTeacher)
            const UserInfoTile(label: "Resume Link", value: "None"),
          const UserInfoTile(label: "Level", value: "6"),
          const UserInfoTile(label: "Certificate", value: "2"),
          const UserInfoTile(label: "Badges", value: "4"),

          UserInfoTile(
            label: "Status",
            value: widget.selectedStatus,
            hasDropdown: true,
            dropdownItems: const ["Approved", "Pending", "Rejected"],
            onChanged: widget.onStatusChanged,
          ),

          UserInfoTile(
            label: "Access",
            value: widget.accessControl ? "Unblocked" : "Blocked",
            hasSwitch: true,
            switchValue: widget.accessControl,
            onSwitchChanged: (value) => _showAccessDialog(value),
          ),

          const SizedBox(height: 22),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  widget.hasChanged
                      ? () {
                        widget.onUpdated();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "User updated successfully",
                              style: TextStyle(
                                fontFamily: AppTypography.family,
                              ),
                            ),
                          ),
                        );
                      }
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    widget.hasChanged
                        ? AppColors.primaryLight
                        : Colors.transparent,
                elevation: widget.hasChanged ? 2 : 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color:
                        widget.hasChanged
                            ? AppColors.primaryLight
                            : Colors.white.withValues(alpha: 0.3),
                  ),
                ),
              ),
              child: Text(
                "Update",
                style: TextStyle(
                  fontFamily: AppTypography.family,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color:
                      widget.hasChanged
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.3),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _showDeleteDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Delete",
                style: TextStyle(
                  fontFamily: AppTypography.family,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
