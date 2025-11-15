import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/quiz_genie_controller.dart';
import 'stepper_dots.dart';
import 'step_forms/step_topic.dart';
import 'step_forms/step_description.dart';
import 'step_forms/step_question_count.dart';
import 'step_forms/step_group.dart';
import 'step_forms/step_level.dart';

void showRequestForm(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const RequestFormSheet(),
  );
}

class RequestFormSheet extends ConsumerWidget {
  const RequestFormSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(quizGenieControllerProvider);
    final c = ref.read(quizGenieControllerProvider.notifier);

    Widget current() {
      switch (s.step) {
        case 0:
          return StepTopic(value: s.topic, onChanged: c.setTopic);
        case 1:
          return StepDescription(
            value: s.description,
            onChanged: c.setDescription,
          );
        case 2:
          return StepQuestionCount(
            value: s.questionCount,
            onChanged: c.setCount,
          );
        case 3:
          return StepGroup(value: s.group, onChanged: c.setGroup);
        case 4:
          return StepLevel(value: s.level, onChanged: c.setLevel);
      }
      return const SizedBox();
    }

    final isLast = s.step == 4;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF003A3A),
          borderRadius: BorderRadius.circular(26),
        ),
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Request Form",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 10),
              StepperDots(step: s.step),
              const SizedBox(height: 20),
              current(),
              const SizedBox(height: 16),
              Row(
                children: [
                  if (s.step > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: c.backStep,
                        child: const Text("Back"),
                      ),
                    ),
                  if (s.step > 0) const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (!c.valid && isLast) return;
                        if (!isLast) {
                          c.nextStep();
                        } else {
                          Navigator.pop(context);
                          c.generate();
                        }
                      },
                      child: Text(isLast ? "Generate" : "Next"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
