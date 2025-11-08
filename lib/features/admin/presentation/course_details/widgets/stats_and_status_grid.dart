import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class StatsAndStatusGrid extends StatefulWidget {
  final int quizzes, enrolled, sold;
  final int price, total;
  final int discountPercent;
  final String durationText;
  final String teacherName;
  final String? teacherImage;
  final String initialStatus;
  final String? initialRejection;
  final VoidCallback onDeleteCourse;
  final VoidCallback onEditCourse;
  final void Function(String status, {String? reason}) onStatusChanged;

  const StatsAndStatusGrid({
    super.key,
    required this.quizzes,
    required this.enrolled,
    required this.sold,
    required this.price,
    required this.discountPercent,
    required this.total,
    required this.durationText,
    required this.teacherName,
    this.teacherImage,
    required this.initialStatus,
    this.initialRejection,
    required this.onDeleteCourse,
    required this.onEditCourse,
    required this.onStatusChanged,
  });

  @override
  State<StatsAndStatusGrid> createState() => _StatsAndStatusGridState();
}

class _StatsAndStatusGridState extends State<StatsAndStatusGrid>
    with SingleTickerProviderStateMixin {
  late String status;
  String? rejection;
  late AnimationController _clockController;

  @override
  void initState() {
    super.initState();
    status = widget.initialStatus;
    rejection = widget.initialRejection;

    _clockController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _clockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _firstThreeCards()),
            const SizedBox(width: 12),
            Expanded(child: _teacherStatusCard()),
          ],
        ),
      ],
    );
  }

  Widget _firstThreeCards() {
    return Column(
      children: [
        _buildSmallCard(
          fixedHeight: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _labelValue('Quizzes', '${widget.quizzes}'),
              _labelValue('Enrolled', '${widget.enrolled}'),
              _labelValue('Sold', '${widget.sold}'),
            ],
          ),
        ),
        const SizedBox(height: 14),

        _buildSmallCard(
          fixedHeight: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _labelValue('Price', '৳ ${widget.price}/-'),
              _labelValue('Discount', '${widget.discountPercent}%'),
              _labelValue('Total', '৳ ${widget.total}/-'),
            ],
          ),
        ),
        const SizedBox(height: 14),

        _buildSmallCard(
          fixedHeight: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _clockController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _clockController.value * 2 * math.pi,
                    child: const Icon(
                      CupertinoIcons.clock_fill,
                      color: AppColors.cardOthers,
                      size: 48,
                    ),
                  );
                },
              ),
              const SizedBox(height: 6),
              Text(
                widget.durationText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSmallCard({required Widget child, double fixedHeight = 90}) {
    return Container(
      width: double.infinity,
      height: fixedHeight,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  Widget _teacherStatusCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.white,
            backgroundImage:
                widget.teacherImage != null
                    ? NetworkImage(widget.teacherImage!)
                    : null,
            child:
                widget.teacherImage == null
                    ? const Icon(Icons.person, color: Colors.black)
                    : null,
          ),
          const SizedBox(height: 6),

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.teacherName,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryDark,
                ),
              ),
              const SizedBox(height: 2),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'View Profile',
                  style: TextStyle(
                    fontFamily: AppTypography.family,
                    color: AppColors.chip2,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          const Divider(color: Colors.black26),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _radio('Pending'),
              _radio('Approved'),
              _radio('Rejected'),
            ],
          ),
          const SizedBox(height: 6),

          IgnorePointer(
            ignoring: status != 'Rejected',
            child: Opacity(
              opacity: status == 'Rejected' ? 1 : 0.5,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: rejection,
                    hint: const Text(
                      'Suggestion',
                      style: TextStyle(
                        fontFamily: AppTypography.family,
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Quiz issue',
                        child: Text('Quiz issue'),
                      ),
                      DropdownMenuItem(
                        value: 'Content quality',
                        child: Text('Content quality'),
                      ),
                      DropdownMenuItem(
                        value: 'Policy violation',
                        child: Text('Policy violation'),
                      ),
                    ],
                    onChanged: (v) {
                      setState(() => rejection = v);
                      widget.onStatusChanged(status, reason: rejection);
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: widget.onEditCourse,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryDark,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Edit',
                    style: TextStyle(
                      fontFamily: AppTypography.family,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: widget.onDeleteCourse,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                      fontFamily: AppTypography.family,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _labelValue(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: AppTypography.family,
              color: Colors.white,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: AppTypography.family,
              color: AppColors.secondaryDark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _radio(String value) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: status,
          onChanged: (v) {
            setState(() {
              status = v!;
              if (status != 'Rejected') rejection = null;
            });
            widget.onStatusChanged(status, reason: rejection);
          },
          activeColor: AppColors.secondaryDark,
          fillColor: WidgetStateProperty.resolveWith<Color>(
            (states) =>
                states.contains(WidgetState.selected)
                    ? AppColors.secondaryDark
                    : Colors.white,
          ),
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: AppTypography.family,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }
}
