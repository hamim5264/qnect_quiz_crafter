import 'package:flutter/material.dart';
import '../../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import 'models/faq_item.dart';
import 'widgets/faq_tile.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  String selectedCategory = 'General';

  final List<FaqItem> faqs = const [
    FaqItem(
      category: 'General',
      question: 'Do I need an account to use QuizCrafter?',
      answer:
          'You can explore some public content as a guest. However, to enroll in courses, attempt quizzes, track progress, or make purchases, you must create an account.',
    ),
    FaqItem(
      category: 'General',
      question: 'How do I create an account?',
      answer:
          'Tap on the Sign Up button and register using your email or social login. You will be asked to provide basic information based on your role.',
    ),
    FaqItem(
      category: 'General',
      question: 'Can I change my role after registration?',
      answer:
          'No. Once you choose a role (Student or Teacher) during sign-up, it cannot be changed. Please choose carefully.',
    ),

    FaqItem(
      category: 'Student',
      question: 'Do students need to log in to buy a course?',
      answer:
          'Yes. Only logged-in students can purchase or enroll in courses. Guests and teachers cannot buy courses.',
    ),
    FaqItem(
      category: 'Student',
      question: 'Why can’t I buy some courses?',
      answer:
          'You can only purchase courses that match your Group and Level (for example: Science + HSC). This ensures relevant learning.',
    ),
    FaqItem(
      category: 'Student',
      question: 'Can I submit feedback for a course?',
      answer:
          'Yes. After enrolling in a course, you can submit one feedback per course. Duplicate feedback is not allowed.',
    ),
    FaqItem(
      category: 'Student',
      question: 'Where can I track my tasks and plans?',
      answer:
          'You can manage your daily tasks using the Planner feature available in your dashboard.',
    ),

    FaqItem(
      category: 'Teacher',
      question: 'How can I register as a teacher?',
      answer:
          'During sign-up, select Teacher as your role and provide required details including a valid resume or portfolio link.',
    ),
    FaqItem(
      category: 'Teacher',
      question: 'Why do I need to provide a resume or portfolio link?',
      answer:
          'This helps the admin verify your qualifications before approving your teacher account.',
    ),
    FaqItem(
      category: 'Teacher',
      question: 'When will my teacher account be approved?',
      answer:
          'After submission, the admin reviews your profile. You will be notified once your account is approved or rejected.',
    ),
    FaqItem(
      category: 'Teacher',
      question: 'Can teachers buy courses?',
      answer:
          'No. Teachers cannot purchase courses. Buying courses is restricted to students only.',
    ),

    FaqItem(
      category: 'Courses',
      question: 'How are courses approved?',
      answer:
          'All courses created by teachers are reviewed by the admin. Only approved courses are visible to students.',
    ),
    FaqItem(
      category: 'Courses',
      question: 'Why was my course rejected?',
      answer:
          'If your course is rejected, the admin provides a remark explaining the reason. You can view this in your course feedback section.',
    ),
    FaqItem(
      category: 'Courses',
      question: 'Who can delete course feedback?',
      answer:
          'Only admins can delete feedback. Students can submit feedback, and teachers can only view it.',
    ),

    FaqItem(
      category: 'Payment',
      question: 'Do I need to log in before making a payment?',
      answer:
          'Yes. You must be logged in as a student to proceed with any payment.',
    ),
    FaqItem(
      category: 'Payment',
      question: 'What happens after a successful payment?',
      answer:
          'Once payment is completed, the course will be added to your enrolled courses and accessible immediately.',
    ),
    FaqItem(
      category: 'Payment',
      question: 'Can I get a refund?',
      answer:
          'Refund policies depend on the course terms. Please contact support for detailed assistance.',
    ),

    FaqItem(
      category: 'Account',
      question: 'Is my data secure?',
      answer:
          'Yes. QuizCrafter uses secure authentication and database rules to protect your personal data.',
    ),
    FaqItem(
      category: 'Account',
      question: 'What happens if my account is blocked?',
      answer:
          'If your account is blocked by the admin, you will be redirected to a blocked screen and cannot access the app features.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final categories = faqs.map((e) => e.category).toSet().toList();
    final filteredFaqs =
        faqs.where((f) => f.category == selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: "FAQ"),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    categories.map((c) {
                      final active = c == selectedCategory;

                      return GestureDetector(
                        onTap: () => setState(() => selectedCategory = c),
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color:
                                active
                                    ? AppColors.primaryLight
                                    : Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            c,
                            style: TextStyle(
                              fontFamily: AppTypography.family,
                              fontWeight: FontWeight.bold,
                              color: active ? Colors.white : Colors.white70,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),

            const SizedBox(height: 18),

            Expanded(
              child:
                  filteredFaqs.isEmpty
                      ? const Center(
                        child: Text(
                          "No FAQs available",
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                      : ListView.builder(
                        itemCount: filteredFaqs.length,
                        itemBuilder: (_, i) {
                          final f = filteredFaqs[i];
                          return FaqTile(
                            question: f.question,
                            answer: f.answer,
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
