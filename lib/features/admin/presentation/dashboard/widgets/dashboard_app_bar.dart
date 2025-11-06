import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class DashboardAppBar extends StatelessWidget {
  const DashboardAppBar({super.key});

  List<Map<String, dynamic>> _generateSalesData() {
    final now = DateTime.now();
    final startDate = now.subtract(const Duration(days: 9));

    return List.generate(10, (i) {
      final date = startDate.add(Duration(days: i));
      final sales = (10 + (i * 3) + (i.isEven ? 4 : 0)).toDouble();
      return {'date': date, 'sales': sales, 'isToday': date.day == now.day};
    });
  }

  @override
  Widget build(BuildContext context) {
    final salesData = _generateSalesData();

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.pushNamed('adminProfile');
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              height: 65,
                              width: 65,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  'https://i.pravatar.cc/150?img=12',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            Positioned(
                              bottom: -4,
                              right: -4,
                              child: Container(
                                height: 28,
                                width: 28,
                                decoration: BoxDecoration(
                                  color: AppColors.chip3,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.edit_rounded,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'GOOD AFTERNOON',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppTypography.family,
                            ),
                          ),
                          Text(
                            'Admin',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppTypography.family,
                            ),
                          ),
                          Text(
                            'Guard the standard. Grow the platform.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontFamily: AppTypography.family,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          context.pushNamed('notification');
                        },
                        icon: const Icon(
                          CupertinoIcons.bell_fill,
                          color: Colors.white,
                          size: 22,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(height: 8),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          CupertinoIcons.ellipses_bubble,
                          color: Colors.white,
                          size: 22,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 4),

              const Padding(
                padding: EdgeInsets.only(left: 6.0),
                child: Text(
                  'DAILY SALES CHART',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppTypography.family,
                  ),
                ),
              ),
              const SizedBox(height: 4),

              SizedBox(
                height: 80,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:
                      salesData.map((day) {
                        final double maxHeight = 60;
                        final barHeight = (day['sales'] / 40) * maxHeight;
                        final isToday = day['isToday'] as bool;

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                              width: 10,
                              height: barHeight.clamp(10, maxHeight),
                              decoration: BoxDecoration(
                                color:
                                    isToday
                                        ? AppColors.secondaryDark
                                        : Colors.white.withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              DateFormat('dd').format(day['date']),
                              style: TextStyle(
                                fontSize: 10,
                                color:
                                    isToday
                                        ? AppColors.secondaryDark
                                        : Colors.white70,
                                fontFamily: AppTypography.family,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                ),
              ),

              const SizedBox(height: 16),

              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    DateFormat(
                      'dd MMMM yyyy',
                    ).format(DateTime.now()).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: AppTypography.family,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
