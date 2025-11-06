import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class PulseBoardGrid extends StatelessWidget {
  const PulseBoardGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'QuizCrafter Pulseboard',
            style: TextStyle(
              fontFamily: AppTypography.family,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),

          Row(
            children: const [
              Expanded(
                child: _PulseCard(
                  title: 'Pending Courses',
                  value: '29',
                  percentage: '8.13%',
                  subtitle: 'Awaiting review',
                  buttonText: 'Review Now',
                  icon: LucideIcons.clock,
                  iconColor: AppColors.primaryLight,
                  valueColor: AppColors.chip1,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _PulseCard(
                  title: 'Approved Courses',
                  value: '38',
                  percentage: '4.07%',
                  subtitle: 'Ready for students',
                  buttonText: 'View Approved',
                  icon: LucideIcons.checkCircle2,
                  iconColor: AppColors.secondaryDark,
                  valueColor: AppColors.chip2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          const _PulseCardWide(),
        ],
      ),
    );
  }
}

class _PulseCard extends StatelessWidget {
  final String title, value, percentage, subtitle, buttonText;
  final IconData icon;
  final Color iconColor;
  final Color valueColor;

  const _PulseCard({
    required this.title,
    required this.value,
    required this.percentage,
    required this.subtitle,
    required this.buttonText,
    required this.icon,
    required this.iconColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: AppTypography.family,
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),

          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontFamily: AppTypography.family,
                  fontWeight: FontWeight.w900,
                  fontSize: 32,
                  color: valueColor,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primaryDark,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  percentage,
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    fontSize: 12,
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Icon(LucideIcons.trendingUp, size: 28, color: AppColors.chip1),
            ],
          ),

          const SizedBox(height: 2),

          Text(
            subtitle,
            style: const TextStyle(
              fontFamily: AppTypography.family,
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 8),

          SizedBox(
            width: double.infinity,
            height: 36,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryLight,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: AppTypography.family,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PulseCardWide extends StatelessWidget {
  const _PulseCardWide();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Sold',
                style: TextStyle(
                  fontFamily: AppTypography.family,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: const [
                    Icon(
                      LucideIcons.trendingUp,
                      size: 14,
                      color: AppColors.secondaryDark,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '9.21%',
                      style: TextStyle(
                        fontFamily: AppTypography.family,
                        fontSize: 12,
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '107',
                style: TextStyle(
                  fontFamily: AppTypography.family,
                  fontWeight: FontWeight.w900,
                  fontSize: 36,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 16),

              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    _BulletColumn(
                      color: AppColors.primaryLight,
                      label: 'Science',
                      value: '3.15%',
                    ),
                    _BulletColumn(
                      color: AppColors.cardOthers,
                      label: 'Arts',
                      value: '2.28%',
                    ),
                    _BulletColumn(
                      color: AppColors.chip1,
                      label: 'Commerce',
                      value: '4.96%',
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          const Text(
            'Units sold',
            style: TextStyle(
              fontFamily: AppTypography.family,
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.pushNamed('sellsReport');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryLight,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'Sales Report',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: AppTypography.family,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletColumn extends StatelessWidget {
  final Color color;
  final String label;
  final String value;

  const _BulletColumn({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontFamily: AppTypography.family,
                fontSize: 14,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontFamily: AppTypography.family,
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  final String label, value;

  const _Legend({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$label $value',
      style: const TextStyle(
        fontFamily: AppTypography.family,
        fontSize: 12,
        color: AppColors.textSecondary,
      ),
    );
  }
}
