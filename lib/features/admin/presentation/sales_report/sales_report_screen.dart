import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qnect_quiz_crafter/common/widgets/app_loader.dart';
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

  bool loading = true;
  List<Map<String, dynamic>> allSales = [];

  @override
  void initState() {
    super.initState();
    loadSales();
  }

  Future<void> loadSales() async {
    setState(() => loading = true);

    final courseSnap =
        await FirebaseFirestore.instance.collection("courses").get();

    List<Map<String, dynamic>> loadedSales = [];

    for (var courseDoc in courseSnap.docs) {
      final data = courseDoc.data();

      final String courseName = data["title"] ?? "";

      final int price =
          (data["price"] is int)
              ? data["price"]
              : (data["price"] is double)
              ? (data["price"] as double).toInt()
              : int.tryParse(data["price"].toString()) ?? 0;

      final int sold =
          (data["sold"] is int)
              ? data["sold"]
              : (data["sold"] is double)
              ? (data["sold"] as double).toInt()
              : int.tryParse(data["sold"].toString()) ?? 0;

      final String group = data["group"] ?? "";
      final String teacherId = data["teacherId"] ?? "";

      String teacherName = "Unknown Teacher";

      if (teacherId.isNotEmpty) {
        final teacherSnap =
            await FirebaseFirestore.instance
                .collection("users")
                .doc(teacherId)
                .get();

        if (teacherSnap.exists) {
          final t = teacherSnap.data()!;
          final firstName = t["firstName"] ?? "";
          final lastName = t["lastName"] ?? "";
          teacherName = "$firstName $lastName".trim();
        }
      }

      DateTime saleDate = DateTime.now();
      try {
        if (data["updatedAt"] != null) {
          saleDate = DateTime.parse(data["updatedAt"]);
        } else if (data["startDate"] != null) {
          saleDate = DateTime.parse(data["startDate"]);
        }
      } catch (_) {}

      for (int i = 0; i < sold; i++) {
        loadedSales.add({
          "course": courseName,
          "soldBy": teacherName,
          "date": saleDate,
          "amount": price,
          "isRefunded": false,
          "group": group,
        });
      }
    }

    allSales = loadedSales;
    setState(() => loading = false);
  }

  String _formatDate(DateTime d) {
    return "${d.day} ${_monthName(d.month)} ${d.year}";
  }

  String _monthName(int m) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[m - 1];
  }

  int _totalIncome() {
    return allSales
        .where((c) => c["isRefunded"] == false)
        .fold(0, (sum, c) => sum + (c["amount"] as int));
  }

  int _groupTotal(String groupName) {
    return allSales
        .where((c) => c["group"] == groupName && c["isRefunded"] == false)
        .fold(0, (sum, c) => sum + (c["amount"] as int));
  }

  @override
  Widget build(BuildContext context) {
    final filteredCourses =
        allSales.where((c) {
          final matchesGroup = c["group"] == selectedGroup;
          final matchesRefund =
              selectedFilter == "Sold"
                  ? c["isRefunded"] == false
                  : c["isRefunded"] == true;

          return matchesGroup && matchesRefund;
        }).toList();

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: 'Sells Report'),
      body:
          loading
              ? const Center(
                child: AppLoader(),
              )
              : SafeArea(
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

                      SellsPercentageCard(
                        science: _groupTotal("Science"),
                        arts: _groupTotal("Arts"),
                        commerce: _groupTotal("Commerce"),
                      ),
                      const SizedBox(height: 18),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Overall Income',
                            style: TextStyle(
                              fontFamily: AppTypography.family,
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${_totalIncome()} BDT',
                            style: const TextStyle(
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
                            icon: const Icon(
                              Icons.filter_list,
                              color: Colors.white,
                            ),
                            onSelected:
                                (v) => setState(() => selectedFilter = v),
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
                          course: c['course'],
                          soldBy: c['soldBy'],
                          date: _formatDate(c['date']),
                          amount: c['amount'],
                          isRefunded: c['isRefunded'],
                        ),
                    ],
                  ),
                ),
              ),
    );
  }
}
