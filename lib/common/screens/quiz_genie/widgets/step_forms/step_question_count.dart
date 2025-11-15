import 'package:flutter/material.dart';

class StepQuestionCount extends StatelessWidget {
  final int? value;
  final ValueChanged<String> onChanged;

  const StepQuestionCount({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      initialValue: value?.toString() ?? "",
      onChanged: onChanged,
      decoration: const InputDecoration(
        labelText: "Question count (max 25)",
        filled: false,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}
