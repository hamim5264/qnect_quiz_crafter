import 'package:flutter/material.dart';
import '../../../../common/widgets/common_date_picker.dart';
import '../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../ui/design_system/tokens/colors.dart';
import '../../../../ui/design_system/tokens/typography.dart';
import 'widgets/sales_percentage_card.dart';
import 'widgets/sales_group_filter.dart';
import 'widgets/sales_course_card.dart';

class SalesReportScreen extends StatefulWidget {
  const SalesReportScreen({super.key});

  @override
  State<SalesReportScreen> createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {
  DateTime selectedDate = DateTime.now();
  String selectedGroup = 'Science';
  String selectedFilter = 'Sold';

  final allCourses = [
    {
      'course': 'Basic English',
      'soldBy': 'Mst. Hasna Hena',
      'date': '14 September 2025',
      'amount': 750,
      'isRefunded': false,
      'group': 'Science',
    },
    {
      'course': 'Basic English II',
      'soldBy': 'Arpita Ghose',
      'date': '11 September 2025',
      'amount': 930,
      'isRefunded': true,
      'group': 'Science',
    },
    {
      'course': 'Modern Arts',
      'soldBy': 'Hasna Hena',
      'date': '09 September 2025',
      'amount': 500,
      'isRefunded': false,
      'group': 'Arts',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredCourses =
        allCourses.where((c) {
          final matchesGroup = c['group'] == selectedGroup;
          final matchesRefund =
              selectedFilter == 'Sold'
                  ? c['isRefunded'] == false
                  : c['isRefunded'] == true;
          return matchesGroup && matchesRefund;
        }).toList();

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: 'Sells Report'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CommonDatePicker(
                selectedDate: selectedDate,
                onDateSelected: (date) {
                  setState(() => selectedDate = date);
                },
              ),
              const SizedBox(height: 14),

              const SellsPercentageCard(),
              const SizedBox(height: 18),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Overall Income',
                    style: TextStyle(
                      fontFamily: AppTypography.family,
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '10,526 BDT',
                    style: TextStyle(
                      fontFamily: AppTypography.family,
                      color: AppColors.secondaryDark,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              SellsGroupFilter(
                selected: selectedGroup,
                onSelected: (v) => setState(() => selectedGroup = v),
              ),

              const SizedBox(height: 18),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Showing $selectedFilter Items',
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                  PopupMenuButton<String>(
                    color: AppColors.primaryLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    icon: const Icon(Icons.filter_list, color: Colors.white),
                    onSelected: (v) => setState(() => selectedFilter = v),
                    itemBuilder:
                        (_) => const [
                          PopupMenuItem(
                            value: 'Sold',
                            child: Text(
                              'Sold',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          PopupMenuItem(
                            value: 'Refunded',
                            child: Text(
                              'Refunded',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              for (final c in filteredCourses)
                SellsCourseCard(
                  course: c['course'] as String,
                  soldBy: c['soldBy'] as String,
                  date: c['date'] as String,
                  amount: c['amount'] as int,
                  isRefunded: c['isRefunded'] as bool,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
