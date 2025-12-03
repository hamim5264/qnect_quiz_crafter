import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
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
  final String teacherId;
  final String courseId;   // <-- ADD THIS


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
    required this.teacherId,
    required this.courseId,



  });

  @override
  State<StatsAndStatusGrid> createState() => _StatsAndStatusGridState();
}

class _StatsAndStatusGridState extends State<StatsAndStatusGrid>
    with SingleTickerProviderStateMixin {
  late String status;
  String? rejection;
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    status = widget.initialStatus;
    rejection = widget.initialRejection;
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
          fixedHeight: 110,
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
        const SizedBox(height: 7),

        _buildSmallCard(
          fixedHeight: 110,
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
        const SizedBox(height: 7),

        _buildSmallCard(
          fixedHeight: 130,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 60,
                width: 60,
                child: Lottie.asset(
                  'assets/icons/calendar.json',
                  repeat: true,
                  animate: true,
                ),
              ),
              const SizedBox(height: 4),
              Column(
                children: [
                  const Text(
                    "The course will end in",
                    style: TextStyle(
                      fontFamily: AppTypography.family,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.durationText,        // <-- Now it shows “20 D 5 H”
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      color: AppColors.secondaryDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _calculateDuration(dynamic start, dynamic end) {
    // Convert Firestore Timestamp → DateTime
    DateTime startDate;
    DateTime endDate;

    if (start is Timestamp) {
      startDate = start.toDate();
    } else if (start is String) {
      startDate = DateTime.tryParse(start) ?? DateTime.now();
    } else {
      startDate = DateTime.now();
    }

    if (end is Timestamp) {
      endDate = end.toDate();
    } else if (end is String) {
      endDate = DateTime.tryParse(end) ??
          DateTime.now().add(const Duration(days: 30));
    } else {
      endDate = DateTime.now().add(const Duration(days: 30));
    }

    final diff = endDate.difference(startDate);

    final days = diff.inDays;
    final hours = diff.inHours % 24;

    return "$days D $hours H";
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
          // CircleAvatar(
          //   radius: 28,
          //   backgroundColor: AppColors.white,
          //   backgroundImage:
          //       widget.teacherImage != null
          //           ? NetworkImage(widget.teacherImage!)
          //           : null,
          //   child:
          //       widget.teacherImage == null
          //           ? const Icon(Icons.person, color: Colors.black)
          //           : null,
          // ),
          // const SizedBox(height: 6),

          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     // 🔥 TEACHER IMAGE
          //     CircleAvatar(
          //       radius: 28,
          //       backgroundColor: AppColors.white,
          //       backgroundImage: widget.teacherImage != null && widget.teacherImage!.isNotEmpty
          //           ? NetworkImage(widget.teacherImage!)
          //           : null,
          //       child: (widget.teacherImage == null || widget.teacherImage!.isEmpty)
          //           ? const Icon(Icons.person, color: Colors.black, size: 28)
          //           : null,
          //     ),
          //
          //     const SizedBox(height: 6),
          //
          //     // 🔥 TEACHER NAME
          //     Text(
          //       widget.teacherName,
          //       overflow: TextOverflow.ellipsis,
          //       textAlign: TextAlign.center,
          //       style: const TextStyle(
          //         fontFamily: AppTypography.family,
          //         fontWeight: FontWeight.bold,
          //         color: AppColors.white,
          //       ),
          //     ),
          //
          //     const SizedBox(height: 2),
          //
          //     // 🔥 VIEW PROFILE BUTTON
          //     GestureDetector(
          //       onTap: () {
          //         /// YOU MUST PASS TEACHER ID
          //         context.push(
          //           '/user-details/${widget.teacherId}',   // <--- USE REAL TEACHER ID
          //         );
          //       },
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           const Text(
          //             'View Profile',
          //             style: TextStyle(
          //               fontFamily: AppTypography.family,
          //               color: AppColors.secondaryDark,
          //             ),
          //           ),
          //           const SizedBox(width: 4),
          //           const Icon(
          //             CupertinoIcons.arrow_up_right_square_fill,
          //             size: 16,
          //             color: AppColors.secondaryDark,
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🔥 TEACHER IMAGE
              CircleAvatar(
                radius: 32,
                backgroundColor: AppColors.white,
                backgroundImage: widget.teacherImage != null &&
                    widget.teacherImage!.isNotEmpty
                    ? NetworkImage(widget.teacherImage!)
                    : null,
                child: (widget.teacherImage == null ||
                    widget.teacherImage!.isEmpty)
                    ? const Icon(Icons.person, color: Colors.black, size: 32)
                    : null,
              ),

              const SizedBox(height: 4),
              Text("Course Created by",),

              // 🔥 TEACHER NAME
              Text(
                widget.teacherName,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 10),

              const Divider(color: Colors.black26),
            ],
          ),


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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() => _showSuggestions = !_showSuggestions);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              rejection ?? 'Suggestion',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: AppTypography.family,
                                fontSize: 13,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          Icon(
                            _showSuggestions
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 250),
                    crossFadeState:
                        _showSuggestions
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                    firstChild: _buildSuggestionCard(),
                    secondChild: const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.pushNamed(
                      'adminEditCourse',
                      pathParameters: {'courseId': widget.courseId},
                    );
                  },
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
              color: AppColors.white,
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

  Widget _buildSuggestionCard() {
    final Map<String, List<String>> sections = {
      'Content & Syllabus': [
        '[C01] Not aligned with syllabus',
        '[C02] Incomplete content',
        '[C03] Outdated/incorrect facts',
        '[C04] Low originality',
        '[C05] Wrong language/terminology',
      ],
      'Assessment': [
        '[A01] Ambiguous questions/options',
        '[A02] Incorrect answer keys',
        '[A03] Difficulty imbalance',
        '[A04] Duplicated items',
        '[A05] Missing solutions/rationales',
      ],
      'Structure & Formatting': [
        '[S01] Missing objectives/prereqs',
        '[S02] Disorganized flow',
        '[S03] Inconsistent formatting',
        '[S04] Excessive typos/grammar',
      ],
      'Media & Assets': [
        '[M01] Unlicensed/uncited media',
        '[M02] Low-quality images/audio',
        '[M03] Accessibility gaps',
        '[M04] Heavy files/slow load',
      ],
      'Technical': [
        '[T01] Broken links/resources',
        '[T02] Mobile/responsive issues',
        '[T03] Embedded items not loading',
      ],
      'Policy & Compliance': [
        '[P01] Copyright concerns',
        '[P02] Inappropriate content',
        '[P03] Personal data/shared contacts',
        '[P04] External advertising',
      ],
      'Pricing & Metadata': [
        '[R01] Price/content mismatch',
        '[R02] Wrong category/group',
        '[R03] Duplicate course',
      ],
    };

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Column(
          children:
              sections.entries.map((entry) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 0,
                    ),
                    collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    iconColor: Colors.white,
                    collapsedIconColor: Colors.white54,
                    title: Text(
                      entry.key,
                      style: const TextStyle(
                        fontFamily: AppTypography.family,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                    childrenPadding: const EdgeInsets.only(
                      left: 14,
                      right: 12,
                      bottom: 6,
                    ),
                    children:
                        entry.value.map((reason) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                rejection = reason;
                                _showSuggestions = false;
                              });
                              widget.onStatusChanged(status, reason: rejection);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: [
                                  const Text(
                                    '• ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      reason,
                                      style: const TextStyle(
                                        fontFamily: AppTypography.family,
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
