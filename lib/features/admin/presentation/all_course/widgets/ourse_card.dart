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
  final String iconPath;   // NEW
  final VoidCallback onView;   // ⭐ NEW


  const CourseCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.discount,
    required this.status,
    required this.iconPath,    // NEW
    required this.onView,       // ⭐ NE
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
                        child: Center(
                          child: Image.asset(
                            iconPath,
                            height: 28,
                            width: 28,
                            fit: BoxFit.contain,
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
                      onPressed: onView,
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
