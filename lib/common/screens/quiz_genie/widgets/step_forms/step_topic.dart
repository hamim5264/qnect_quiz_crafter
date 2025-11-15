import 'package:flutter/material.dart';

class StepTopic extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const StepTopic({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      onChanged: onChanged,
      decoration: const InputDecoration(
        labelText: "Topic",
        filled: false,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}
