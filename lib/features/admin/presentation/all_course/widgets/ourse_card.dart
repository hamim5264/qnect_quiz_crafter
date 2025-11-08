import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int price;
  final int discount;
  final String status;

  const CourseCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.discount,
    required this.status,
  });

  Color get statusColor {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.menu_book_rounded,
                            color: AppColors.chip3,
                            size: 28,
                          ),
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '৳ $price/-',
                            style: const TextStyle(
                              fontFamily: AppTypography.family,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondaryDark,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '-$discount TK Off',
                            style: const TextStyle(
                              fontFamily: AppTypography.family,
                              color: Colors.white70,
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  Center(
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 28,
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontFamily: AppTypography.family,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.pushNamed(
                          'adminCourseDetails',
                          extra: {
                            'title': 'Basic English',
                            'description': 'Language, Grammar, Literature...',
                            'price': 899,
                            'discount': 0,
                            'total': 899,
                            'quizCount': 25,
                            'enrolled': 0,
                            'sold': 0,
                            'teacherName': 'Mst. Hasna Hena',
                            'teacherImage': null,
                            'duration': '60 Days 12 Min',
                            'createdAt': 'Aug 25 2025, 08:30 PM',
                            'quizzes': [
                              {
                                'icon': Icons.abc_rounded,
                                'title': 'Basic Grammar',
                                'desc':
                                    'Parts of speech, sentence structure...',
                                'points': 50,
                                'timeLeft': '50 h 10 m',
                              },
                              {
                                'icon': Icons.inventory_2_rounded,
                                'title': 'Advanced Grammar',
                                'desc':
                                    'Complex sentence structures, clauses...',
                                'points': 50,
                                'timeLeft': '10 h 12 m',
                              },
                            ],
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryLight,
                        minimumSize: const Size.fromHeight(30),
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'View Course',
                        style: TextStyle(
                          fontFamily: AppTypography.family,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
