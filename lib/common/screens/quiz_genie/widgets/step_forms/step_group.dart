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
        DropdownMenuItem(value: QuizGenieGroup.ssc, child: Text("SSC")),
        DropdownMenuItem(value: QuizGenieGroup.hsc, child: Text("HSC")),
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
