import 'package:flutter/material.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/all_course/widgets/ourse_card.dart';
import '../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../common/widgets/common_search_bar.dart';
import '../../../../ui/design_system/tokens/colors.dart';
import 'widgets/course_filter_card.dart';

class AllCourseScreen extends StatefulWidget {
  const AllCourseScreen({super.key});

  @override
  State<AllCourseScreen> createState() => _AllCourseScreenState();
}

class _AllCourseScreenState extends State<AllCourseScreen> {
  String group = "All";
  String level = "All";
  String status = "All";

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: 'All Course'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CommonSearchBar(
                controller: searchController,
                hintText: 'Search course',
                onChanged: (value) {},
              ),
              const SizedBox(height: 14),

              CourseFilterCard(
                selectedGroup: group,
                selectedLevel: level,
                selectedStatus: status,
                onChanged: (g, l, s) {
                  setState(() {
                    group = g;
                    level = l;
                    status = s;
                  });
                },
              ),
              const SizedBox(height: 16),

              Expanded(
                child: GridView.builder(
                  itemCount: 6,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder:
                      (_, i) => CourseCard(
                        title: 'Basic English',
                        subtitle: 'Sentence, literature, parts of...',
                        price: 899,
                        discount: 122,
                        status:
                            i == 0
                                ? 'Pending'
                                : i == 1
                                ? 'Approved'
                                : 'Rejected',
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
