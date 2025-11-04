import 'package:flutter/material.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/teacher_sells_report/widgets/teacher_sells_report.dart';
import '../../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class TeacherSellsReportScreen extends StatefulWidget {
  const TeacherSellsReportScreen({super.key});

  @override
  State<TeacherSellsReportScreen> createState() =>
      _TeacherSellsReportScreenState();
}

class _TeacherSellsReportScreenState extends State<TeacherSellsReportScreen> {
  String selectedGroup = 'Science';
  String selectedType = 'Sold';

  final List<Map<String, dynamic>> soldCourses = [
    {
      'name': 'Basic English',
      'soldBy': 'Mst. Hasna Hena',
      'date': '14 September 2025',
      'price': '750 BDT',
      'refunded': false,
    },
    {
      'name': 'Advanced Grammar',
      'soldBy': 'Arpita Ghose',
      'date': '10 September 2025',
      'price': '1,050 BDT',
      'refunded': false,
    },
  ];

  final List<Map<String, dynamic>> refundedCourses = [
    {
      'name': 'Basic English',
      'soldBy': 'Mst. Hasna Hena',
      'date': '14 September 2025',
      'price': '750 BDT',
      'refunded': true,
    },
    {
      'name': 'Basic English II',
      'soldBy': 'Arpita Ghose',
      'date': '11 September 2025',
      'price': '930 BDT',
      'refunded': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final displayedList =
        selectedType == 'Sold' ? soldCourses : refundedCourses;

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: 'Teacher Sells Report'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CourseSoldBlurSearchBar(),
              const SizedBox(height: 16),

              const TeacherInfoCard(
                name: 'Arpita Ghose Tushi',
                imageUrl: 'https://i.pravatar.cc/150?img=5',
                totalSold: 47,
                refunded: 3,
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Monthly Growth Rate',
                    style: TextStyle(
                      fontFamily: AppTypography.family,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const Text(
                    '1.09%',
                    style: TextStyle(
                      fontFamily: AppTypography.family,
                      color: AppColors.secondaryDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              GroupFilterChips(
                selected: selectedGroup,
                onSelected: (v) => setState(() => selectedGroup = v),
              ),
              const SizedBox(height: 12),

              SalesTypeTabs(
                selected: selectedType,
                onSelected: (v) => setState(() => selectedType = v),
              ),
              const SizedBox(height: 12),

              for (final item in displayedList) ...[
                CourseCard(
                  courseName: item['name'],
                  soldBy: item['soldBy'],
                  date: item['date'],
                  price: item['price'],
                  refunded: item['refunded'],
                ),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
