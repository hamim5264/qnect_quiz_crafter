import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import '../../../../../common/widgets/common_confirm_dialog.dart';
import '../../../../../common/widgets/action_feedback_dialog.dart';
import '../../../../../common/widgets/action_error_dialog.dart';

class TeacherRequestActions extends StatefulWidget {
  final String teacherId;
  final String teacherName;
  final String teacherEmail;

  final String currentStatus;
  final int remainingRequests;
  final ValueChanged<String> onStatusChanged;
  final VoidCallback onRejectAttempt;

  const TeacherRequestActions({
    super.key,
    required this.teacherId,
    required this.teacherName,
    required this.teacherEmail,
    required this.currentStatus,
    required this.remainingRequests,
    required this.onStatusChanged,
    required this.onRejectAttempt,
  });

  @override
  State<TeacherRequestActions> createState() => _TeacherRequestActionsState();
}

class _TeacherRequestActionsState extends State<TeacherRequestActions> {
  final _db = FirebaseFirestore.instance;

  bool get _isActionDisabled => widget.currentStatus.toLowerCase() != 'pending';

  void _showFeedback(
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

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (_) => ActionErrorDialog(message: message),
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
            onConfirm: () async {
              Navigator.pop(context);

              try {
                await _db.collection('users').doc(widget.teacherId).update({
                  'accountStatus': 'approved',
                  'rejectionTitle': null,
                  'rejectionMessage': null,
                  'feedback': [],
                });

                await _db
                    .collection("teacher_status_lookup")
                    .doc(widget.teacherEmail)
                    .set({
                      "accountStatus": "approved",
                      "email": widget.teacherEmail,
                      "uid": widget.teacherId,
                      "name": widget.teacherName,
                    }, SetOptions(merge: true));

                await _db
                    .collection("notifications")
                    .doc("admin-panel")
                    .collection("items")
                    .add({
                      "type": "teacher_approved",
                      "email": widget.teacherEmail,
                      "name": widget.teacherName,
                      "timestamp": DateTime.now().toIso8601String(),
                      "status": "unread",
                    });

                widget.onStatusChanged("approved");

                if (!mounted) return;
                _showFeedback(
                  LucideIcons.badgeCheck,
                  "Approved!",
                  "The teacher has been approved successfully.",
                  Colors.green,
                );
              } catch (e) {
                if (!mounted) return;
                _showError("Failed to approve teacher. Please try again.");
              }
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
      builder:
          (_) => _NeedsImprovementSheet(
            onSubmit: (reason, comment) async {
              Navigator.pop(context);

              try {
                await _db.collection("users").doc(widget.teacherId).update({
                  "accountStatus": "rejected",
                  "attemptCount": FieldValue.increment(1),
                  "rejectionTitle": reason,
                  "rejectionMessage": comment,
                  "feedback": FieldValue.arrayUnion([
                    comment.isNotEmpty ? "$reason: $comment" : reason,
                  ]),
                });

                await _db
                    .collection("teacher_status_lookup")
                    .doc(widget.teacherEmail)
                    .set({
                      "accountStatus": "rejected",
                      "email": widget.teacherEmail,
                      "uid": widget.teacherId,
                      "name": widget.teacherName,
                      "rejectionTitle": reason,
                      "rejectionMessage": comment,
                    }, SetOptions(merge: true));

                await _db
                    .collection("notifications")
                    .doc("admin-panel")
                    .collection("items")
                    .add({
                      "type": "teacher_rejected",
                      "email": widget.teacherEmail,
                      "name": widget.teacherName,
                      "reason": reason,
                      "timestamp": DateTime.now().toIso8601String(),
                      "status": "unread",
                    });

                widget.onStatusChanged("rejected");
                widget.onRejectAttempt();

                if (!mounted) return;
                _showFeedback(
                  LucideIcons.alertTriangle,
                  "Rejected",
                  "The teacher request has been rejected.",
                  Colors.orange,
                );
              } catch (e) {
                if (!mounted) return;
                _showError("Failed to reject teacher. Please try again.");
              }
            },
          ),
    );
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
            onConfirm: () async {
              Navigator.pop(context);

              try {
                await _db.collection("users").doc(widget.teacherId).update({
                  "accountStatus": "blocked",
                });

                await _db
                    .collection("teacher_status_lookup")
                    .doc(widget.teacherEmail)
                    .set({
                      "accountStatus": "blocked",
                      "email": widget.teacherEmail,
                      "uid": widget.teacherId,
                      "name": widget.teacherName,
                    }, SetOptions(merge: true));

                await _db
                    .collection("notifications")
                    .doc("admin-panel")
                    .collection("items")
                    .add({
                      "type": "teacher_blocked",
                      "email": widget.teacherEmail,
                      "name": widget.teacherName,
                      "timestamp": DateTime.now().toIso8601String(),
                      "status": "unread",
                    });

                widget.onStatusChanged("blocked");

                if (!mounted) return;
                _showFeedback(
                  LucideIcons.shield,
                  "Blocked!",
                  "This user has been permanently blocked.",
                  Colors.redAccent,
                );
              } catch (e) {
                if (!mounted) return;
                _showError("Failed to block teacher. Please try again.");
              }
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
  final void Function(String reason, String comment) onSubmit;

  const _NeedsImprovementSheet({required this.onSubmit});

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
                onPressed: () {
                  if (_selectedReason == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select a reason.')),
                    );
                    return;
                  }
                  widget.onSubmit(_selectedReason!, _comment.text.trim());
                },
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
