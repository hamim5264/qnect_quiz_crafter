import 'package:flutter/material.dart';
import '../../models/quiz_genie_models.dart';

class StepGroup extends StatelessWidget {
  final QuizGenieGroup? value;
  final ValueChanged<QuizGenieGroup> onChanged;

  const StepGroup({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<QuizGenieGroup>(
      focusColor: Colors.transparent,
      iconDisabledColor: Colors.white,
      iconEnabledColor: Colors.white,
      value: value,
      items: const [
        DropdownMenuItem(value: QuizGenieGroup.science, child: Text("Science")),
        DropdownMenuItem(value: QuizGenieGroup.arts, child: Text("Arts")),
        DropdownMenuItem(
          value: QuizGenieGroup.commerce,
          child: Text("Commerce"),
        ),
      ],
      onChanged: (v) => v != null ? onChanged(v) : null,
      decoration: const InputDecoration(
        labelText: "Group",
        filled: false,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}
