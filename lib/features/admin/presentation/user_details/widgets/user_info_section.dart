import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../common/widgets/common_confirm_dialog.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import 'user_info_tile.dart';

class UserInfoSection extends StatefulWidget {
  final String role;

  final String email;
  final String phone;
  final String address;
  final String? resumeLink;
  final String level;
  final String certificates;
  final String badges;

  final String selectedStatus;
  final bool accessControl;
  final bool hasChanged;

  final Function(String) onStatusChanged;
  final Function(bool) onAccessChanged;
  final VoidCallback onUpdated;
  final Future<void> Function() onSave;
  final Future<void> Function() onDelete;

  const UserInfoSection({
    super.key,
    required this.role,
    required this.email,
    required this.phone,
    required this.address,
    required this.resumeLink,
    required this.level,
    required this.certificates,
    required this.badges,
    required this.selectedStatus,
    required this.accessControl,
    required this.hasChanged,
    required this.onStatusChanged,
    required this.onAccessChanged,
    required this.onUpdated,
    required this.onSave,
    required this.onDelete,
  });

  @override
  State<UserInfoSection> createState() => _UserInfoSectionState();
}

class _UserInfoSectionState extends State<UserInfoSection> {
  bool _saving = false;
  bool _deleting = false;

  bool get _isTeacher => widget.role == "Teacher";

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
            onConfirm: () async {
              if (_deleting) return;
              setState(() => _deleting = true);

              await widget.onDelete();

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "User deleted successfully",
                      style: TextStyle(fontFamily: AppTypography.family),
                    ),
                  ),
                );
                Navigator.pop(context);
              }
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
            confirmColor: Colors.redAccent,
            onConfirm: () => widget.onAccessChanged(newValue),
          ),
    );
  }

  Future<void> _handleUpdate() async {
    if (!_saving && widget.hasChanged) {
      setState(() => _saving = true);
      await widget.onSave();
      if (mounted) {
        widget.onUpdated();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "User updated successfully",
              style: TextStyle(fontFamily: AppTypography.family),
            ),
          ),
        );
      }
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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

          UserInfoTile(label: "Email", value: widget.email),
          UserInfoTile(label: "Phone", value: widget.phone),
          UserInfoTile(label: "Address", value: widget.address),

          UserInfoTile(
            label: "Resume Link",
            value:
                _isTeacher && widget.resumeLink != null
                    ? widget.resumeLink!
                    : "None",
          ),

          UserInfoTile(label: "Level", value: widget.level),
          UserInfoTile(label: "Certificate", value: widget.certificates),
          UserInfoTile(label: "Badges", value: widget.badges),

          UserInfoTile(
            label: "Status",
            value: widget.selectedStatus,
            hasDropdown: _isTeacher,
            dropdownItems:
                _isTeacher ? const ["Approved", "Pending", "Rejected"] : null,
            onChanged: _isTeacher ? widget.onStatusChanged : null,
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
              onPressed: widget.hasChanged && !_saving ? _handleUpdate : null,
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
                _saving ? "Updating..." : "Update",
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
              onPressed: _deleting ? null : _showDeleteDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _deleting ? "Deleting..." : "Delete",
                style: const TextStyle(
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
