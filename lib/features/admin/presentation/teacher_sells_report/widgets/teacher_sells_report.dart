import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class CourseSoldBlurSearchBar extends StatelessWidget {
  const CourseSoldBlurSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const TextField(
            textInputAction: TextInputAction.search,
            cursorColor: AppColors.secondaryDark,
            style: TextStyle(
              color: Colors.white,
              fontFamily: AppTypography.family,
            ),
            decoration: InputDecoration(
              fillColor: Colors.transparent,
              filled: false,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              border: InputBorder.none,
              hintText: 'Search course by name',
              hintStyle: TextStyle(color: Colors.white54),
              prefixIcon: Icon(Icons.search, color: Colors.white54),
            ),
          ),
        ),
      ),
    );
  }
}

class TeacherInfoCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final int totalSold;
  final int refunded;

  const TeacherInfoCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.totalSold,
    required this.refunded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 24, backgroundImage: NetworkImage(imageUrl)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    fontWeight: FontWeight.bold,
                    color: AppColors.chip1,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Sold',
                          style: TextStyle(
                            fontFamily: AppTypography.family,
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$totalSold',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(width: 24),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Refunded',
                          style: TextStyle(
                            fontFamily: AppTypography.family,
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$refunded',
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GroupFilterChips extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const GroupFilterChips({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final options = ['Science', 'Arts', 'Commerce'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:
          options.map((e) {
            final bool isSelected = e == selected;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: isSelected ? 10 : 0,
                      sigmaY: isSelected ? 10 : 0,
                    ),
                    child: GestureDetector(
                      onTap: () => onSelected(e),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? Colors.white.withValues(alpha: 0.15)
                                  : Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            e,
                            style: TextStyle(
                              fontFamily: AppTypography.family,
                              color: Colors.white,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}

class SalesTypeTabs extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const SalesTypeTabs({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          selected,
          style: const TextStyle(
            fontFamily: AppTypography.family,
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),

        IconButton(
          icon: const Icon(Icons.filter_list_rounded, color: Colors.white70),
          onPressed: () => _showFilterOptions(context),
        ),
      ],
    );
  }

  void _showFilterOptions(BuildContext context) {
    final options = ['Sold', 'Refunded'];

    showModalBottomSheet(
      backgroundColor: AppColors.primaryLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter by',
                style: TextStyle(
                  fontFamily: AppTypography.family,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              for (final option in options) ...[
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    option,
                    style: TextStyle(
                      fontFamily: AppTypography.family,
                      color: option == selected ? Colors.white : Colors.white70,
                      fontWeight:
                          option == selected
                              ? FontWeight.bold
                              : FontWeight.w400,
                    ),
                  ),
                  trailing:
                      option == selected
                          ? const Icon(Icons.check, color: Colors.greenAccent)
                          : null,
                  onTap: () {
                    Navigator.pop(context);
                    onSelected(option);
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class CourseCard extends StatelessWidget {
  final String courseName;
  final String soldBy;
  final String date;
  final String price;
  final bool refunded;

  const CourseCard({
    super.key,
    required this.courseName,
    required this.soldBy,
    required this.date,
    required this.price,
    this.refunded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.secondaryDark, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    '• ',
                    style: TextStyle(
                      color: AppColors.secondaryDark,
                      fontSize: 18,
                      height: 1,
                    ),
                  ),
                  Text(
                    courseName,
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Text(
                price,
                style: TextStyle(
                  fontFamily: AppTypography.family,
                  color: refunded ? Colors.white54 : Colors.white,
                  fontWeight: FontWeight.bold,
                  decoration:
                      refunded
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Sold by: $soldBy',
            style: const TextStyle(
              fontFamily: AppTypography.family,
              color: Colors.white60,
              fontSize: 13,
            ),
          ),
          Text(
            'Date: $date',
            style: const TextStyle(
              fontFamily: AppTypography.family,
              color: Colors.white60,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
