import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class TopTeacherCard extends StatefulWidget {
  const TopTeacherCard({super.key});

  @override
  State<TopTeacherCard> createState() => _TopTeacherCardState();
}

class _TopTeacherCardState extends State<TopTeacherCard> {
  int _currentIndex = 0;
  bool _loading = true;

  List<Map<String, dynamic>> topTeachers = [];

  @override
  void initState() {
    super.initState();
    _loadTopTeachers();
  }

  Future<void> _loadTopTeachers() async {
    final firestore = FirebaseFirestore.instance;

    final teacherDocs =
        await firestore
            .collection("users")
            .where("role", isEqualTo: "teacher")
            .get();

    List<Map<String, dynamic>> results = [];

    for (var t in teacherDocs.docs) {
      final data = t.data();
      final teacherId = t.id;

      final courseDocs =
          await firestore
              .collection("courses")
              .where("teacherId", isEqualTo: teacherId)
              .get();

      int totalCourses = courseDocs.docs.length;
      int totalSold = 0;

      for (var c in courseDocs.docs) {
        final soldValue = c.data()["sold"] ?? 0;

        totalSold +=
            (soldValue is int)
                ? soldValue
                : (soldValue as num).toDouble().toInt();
      }

      results.add({
        "name": "${data['firstName']} ${data['lastName']}",
        "avatar": data["profileImage"] ?? "",
        "level": data["level"]?.toString() ?? "01",
        "courses": totalCourses,
        "sold": totalSold,
        "growth": "12%",
      });
    }

    results.sort((a, b) => b["sold"].compareTo(a["sold"]));

    setState(() {
      topTeachers = results.take(3).toList();
      _loading = false;
    });
  }

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

          if (_loading)
            const SizedBox(
              height: 250,
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primaryLight),
              ),
            )
          else
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
                backgroundColor: Colors.grey.shade300,
                child: ClipOval(child: _buildAvatar(teacher['avatar'])),
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
                    context.pushNamed(
                      'user-details',
                      pathParameters: {'role': 'Teacher'},
                      extra: teacher['email'],
                    );
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

  Widget _buildAvatar(String? url) {
    if (url == null || url.isEmpty) {
      return const Icon(Icons.person, size: 30, color: AppColors.textPrimary);
    }

    if (url.startsWith("http")) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder:
            (_, __, ___) => const Icon(
              Icons.person,
              size: 30,
              color: AppColors.textPrimary,
            ),
      );
    }

    return Image.asset(
      url,
      fit: BoxFit.cover,
      errorBuilder:
          (_, __, ___) =>
              const Icon(Icons.person, size: 30, color: AppColors.textPrimary),
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
