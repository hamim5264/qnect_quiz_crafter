import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import '../../../../../common/widgets/common_confirm_dialog.dart';
import '../../../../../common/widgets/action_feedback_dialog.dart';

class TeacherRequestActions extends StatefulWidget {
  final String currentStatus;
  final int remainingRequests;
  final ValueChanged<String> onStatusChanged;
  final VoidCallback onRejectAttempt;

  const TeacherRequestActions({
    super.key,
    required this.currentStatus,
    required this.remainingRequests,
    required this.onStatusChanged,
    required this.onRejectAttempt,
  });

  @override
  State<TeacherRequestActions> createState() => _TeacherRequestActionsState();
}

class _TeacherRequestActionsState extends State<TeacherRequestActions> {
  bool get _isActionDisabled => widget.currentStatus != 'Pending';

  void _showFeedback(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    showDialog(
      context: context,
      builder:
          (_) => ActionFeedbackDialog(
            icon: icon,
            title: title,
            subtitle: subtitle,
            buttonText: 'Close',
            onPressed: () => Navigator.pop(context),
          ),
    );
  }

  void _handleApprove() {
    showDialog(
      context: context,
      builder:
          (_) => CommonConfirmDialog(
            title: 'Approve Request?',
            message: 'Do you want to approve this teacher?',
            icon: LucideIcons.checkCircle,
            iconColor: Colors.greenAccent,
            confirmColor: Colors.green,
            onConfirm: () {
              widget.onStatusChanged('Approved');
              _showFeedback(
                context,
                LucideIcons.badgeCheck,
                'Approved!',
                'The teacher has been approved successfully.',
                Colors.green,
              );
            },
          ),
    );
  }

  void _handleReject() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.primaryLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      isScrollControlled: true,
      builder: (_) => const _NeedsImprovementSheet(),
    ).then((_) {
      widget.onStatusChanged('Rejected');
      widget.onRejectAttempt();
    });
  }

  void _handleBlock() {
    showDialog(
      context: context,
      builder:
          (_) => CommonConfirmDialog(
            title: 'Block User?',
            message: 'This teacher will be permanently blocked.',
            icon: LucideIcons.userX,
            iconColor: Colors.redAccent,
            confirmColor: Colors.red,
            onConfirm: () {
              widget.onStatusChanged('Blocked');
              _showFeedback(
                context,
                LucideIcons.shield,
                'Blocked!',
                'This user has been permanently blocked.',
                Colors.redAccent,
              );
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final greyBtn = ElevatedButton.styleFrom(
      backgroundColor: Colors.grey,
      padding: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );

    Widget buildButton(String text, Color color, VoidCallback onTap) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isActionDisabled ? null : onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isActionDisabled ? Colors.grey : color,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: AppTypography.family,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        buildButton('Approve', AppColors.chip2, _handleApprove),
        const SizedBox(height: 10),
        buildButton('Reject', Colors.orange, _handleReject),
        const SizedBox(height: 10),
        buildButton('Block', Colors.red, _handleBlock),
      ],
    );
  }
}

class _NeedsImprovementSheet extends StatefulWidget {
  const _NeedsImprovementSheet();

  @override
  State<_NeedsImprovementSheet> createState() => _NeedsImprovementSheetState();
}

class _NeedsImprovementSheetState extends State<_NeedsImprovementSheet> {
  final List<String> _reasons = [
    'Incomplete Profile',
    'Invalid Resume',
    'Incorrect Information',
    'Poor Communication',
  ];
  String? _selectedReason;
  final TextEditingController _comment = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Needs Improvement',
              style: TextStyle(
                fontFamily: AppTypography.family,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            ..._reasons.map((r) {
              return RadioListTile<String>(
                activeColor: AppColors.secondaryDark,
                title: Text(
                  r,
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    color: Colors.white,
                  ),
                ),
                value: r,
                groupValue: _selectedReason,
                onChanged: (v) => setState(() => _selectedReason = v),
              );
            }),
            const SizedBox(height: 10),
            TextField(
              controller: _comment,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Optional comment...',
                hintStyle: const TextStyle(
                  fontFamily: AppTypography.family,
                  color: Colors.white60,
                ),
                filled: true,
                fillColor: AppColors.primaryDark.withValues(alpha: 0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(
                fontFamily: AppTypography.family,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryDark,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    fontFamily: AppTypography.family,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
