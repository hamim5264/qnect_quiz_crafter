import 'package:flutter/material.dart';
import '../../models/quiz_genie_models.dart';

class StepLevel extends StatelessWidget {
  final QuizGenieLevel? value;
  final ValueChanged<QuizGenieLevel> onChanged;

  const StepLevel({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<QuizGenieLevel>(
      iconEnabledColor: Colors.white,
      iconDisabledColor: Colors.white,
      value: value,
      items: const [
        DropdownMenuItem(value: QuizGenieLevel.science, child: Text("Science")),
        DropdownMenuItem(value: QuizGenieLevel.arts, child: Text("Arts")),
        DropdownMenuItem(
          value: QuizGenieLevel.commerce,
          child: Text("Commerce"),
        ),
      ],
      onChanged: (v) => v != null ? onChanged(v) : null,
      decoration: const InputDecoration(
        labelText: "Level",
        filled: false,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}
