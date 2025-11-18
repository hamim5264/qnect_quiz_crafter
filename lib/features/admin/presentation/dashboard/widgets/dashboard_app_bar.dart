import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class DashboardAppBar extends StatelessWidget {
  final String? adminName;
  final String? adminImageUrl;

  const DashboardAppBar({
    super.key,
    required this.adminName,
    required this.adminImageUrl,
  });

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "GOOD MORNING";
    if (hour < 17) return "GOOD AFTERNOON";
    return "GOOD EVENING";
  }

  List<Map<String, dynamic>> _generateSalesData() {
    final now = DateTime.now();
    final startDate = now.subtract(const Duration(days: 9));
    return List.generate(10, (i) {
      final date = startDate.add(Duration(days: i));
      final sales = (10 + (i * 3) + (i.isEven ? 4 : 0)).toDouble();
      return {'date': date, 'sales': sales, 'isToday': date.day == now.day};
    });
  }

  Widget _buildProfileImage() {
    if (adminImageUrl == null || adminImageUrl!.isEmpty) {
      return Container(
        color: Colors.white12,
        child: const Icon(Icons.person, color: Colors.white70, size: 40),
      );
    }
    return Image.network(adminImageUrl!, fit: BoxFit.cover);
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
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pushNamed('adminProfile'),
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
                                child: _buildProfileImage(),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _greeting(),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppTypography.family,
                            ),
                          ),
                          Text(
                            adminName?.toUpperCase() ?? "ADMIN",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppTypography.family,
                            ),
                          ),
                          const Text(
                            "Guard the standard. Grow the platform.",
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
                    children: [
                      IconButton(
                        onPressed: () => context.pushNamed('notification'),
                        icon: const Icon(
                          CupertinoIcons.bell_fill,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      IconButton(
                        onPressed:
                            () => context.pushNamed('messages', extra: 'admin'),
                        icon: const Icon(
                          CupertinoIcons.ellipses_bubble,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 4),

              const Padding(
                padding: EdgeInsets.only(left: 6),
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
                        final isToday = day['isToday'];

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
