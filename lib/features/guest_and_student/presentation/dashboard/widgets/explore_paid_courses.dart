import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class ExplorePaidCourses extends StatelessWidget {
  final List<CourseItem> courses;
  final VoidCallback onSeeAll;
  final Function(CourseItem) onTapCourse;

  const ExplorePaidCourses({
    super.key,
    required this.courses,
    required this.onSeeAll,
    required this.onTapCourse,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Explore Paid Courses",
              style: TextStyle(
                fontFamily: AppTypography.family,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            GestureDetector(
              onTap: onSeeAll,
              child: const Text(
                "See All",
                style: TextStyle(
                  fontFamily: AppTypography.family,
                  fontSize: 14,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        CarouselSlider(
          options: CarouselOptions(
            height: 150,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.85,
          ),
          items:
              courses.map((item) {
                return GestureDetector(
                  onTap: () => onTapCourse(item),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white38,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            image: const DecorationImage(
                              image: NetworkImage(
                                "https://images.unsplash.com/photo-1543002588-bfa74002ed7e?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                item.title,
                                style: const TextStyle(
                                  fontFamily: AppTypography.family,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: AppColors.chip1,
                                ),
                              ),
                              Text(
                                "${item.quizCount} Quizzes • ${item.enrolled} Enrolled",
                                style: const TextStyle(
                                  fontFamily: AppTypography.family,
                                  fontSize: 12,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Text(
                                    "${item.price} BDT",
                                    style: const TextStyle(
                                      fontFamily: AppTypography.family,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.chip2,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    "${item.discount}% Off",
                                    style: const TextStyle(
                                      fontFamily: AppTypography.family,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.chip3,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}

class CourseItem {
  final String title;
  final String image;
  final int quizCount;
  final int enrolled;
  final int price;
  final int discount;

  CourseItem({
    required this.title,
    required this.image,
    required this.quizCount,
    required this.enrolled,
    required this.price,
    required this.discount,
  });
}
