import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class TopTeacherCard extends StatefulWidget {
  const TopTeacherCard({super.key});

  @override
  State<TopTeacherCard> createState() => _TopTeacherCardState();
}

class _TopTeacherCardState extends State<TopTeacherCard> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> topTeachers = [
    {
      'name': 'Mst. Hasna Hena',
      'level': '06',
      'likes': 405,
      'courses': 35,
      'sold': 21,
      'growth': '12%',
      'avatar': 'assets/images/admin/sample_teacher.png',
    },
    {
      'name': 'Shahina Akter',
      'level': '07',
      'likes': 368,
      'courses': 28,
      'sold': 19,
      'growth': '9%',
      'avatar': 'assets/images/admin/sample_teacher2.png',
    },
    {
      'name': 'Tasnim Jui',
      'level': '08',
      'likes': 498,
      'courses': 41,
      'sold': 27,
      'growth': '15%',
      'avatar': 'assets/images/admin/sample_teacher3.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Teachers',
            style: TextStyle(
              fontFamily: AppTypography.family,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          CarouselSlider.builder(
            itemCount: topTeachers.length,
            itemBuilder: (context, index, realIdx) {
              final teacher = topTeachers[index];
              return _TeacherCardItem(
                teacher: teacher,
                isActive: _currentIndex == index,
              );
            },
            options: CarouselOptions(
              height: 250,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
              onPageChanged:
                  (index, _) => setState(() => _currentIndex = index),
            ),
          ),
        ],
      ),
    );
  }
}

class _TeacherCardItem extends StatelessWidget {
  final Map<String, dynamic> teacher;
  final bool isActive;

  const _TeacherCardItem({required this.teacher, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundImage: AssetImage(teacher['avatar']),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '⭐ Level ${teacher['level']}',
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      color: Colors.orange,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          LucideIcons.trendingUp,
                          color: AppColors.primaryDark,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          teacher['growth'],
                          style: const TextStyle(
                            fontFamily: AppTypography.family,
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              _BulletWithValue(
                label: 'Likes',
                valueKey: 'likes',
                color: AppColors.chip2,
              ),
              _BulletWithValue(
                label: 'Courses',
                valueKey: 'courses',
                color: AppColors.primaryLight,
              ),
              _BulletWithValue(
                label: 'Course Sold',
                valueKey: 'sold',
                color: Colors.red,
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.cardSecondary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    teacher['name'],
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.push('/user-details/Teacher');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.chip3,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Open Profile',
                    style: TextStyle(
                      fontFamily: AppTypography.family,
                      fontSize: 14,
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color:
                      isActive && index == 0
                          ? AppColors.primaryLight
                          : AppColors.secondaryLight,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletWithValue extends StatelessWidget {
  final String label;
  final String valueKey;
  final Color color;

  const _BulletWithValue({
    required this.label,
    required this.valueKey,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final teacher =
        (context.findAncestorWidgetOfExactType<_TeacherCardItem>()!).teacher;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.textPrimary.withValues(alpha: 0.3),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(
                fontFamily: AppTypography.family,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${teacher[valueKey]}',
          style: const TextStyle(
            fontFamily: AppTypography.family,
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
