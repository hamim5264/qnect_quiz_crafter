import 'package:flutter/material.dart';

class StepDescription extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const StepDescription({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      maxLines: 2,
      onChanged: onChanged,
      decoration: const InputDecoration(
        labelText: "Short Description",
        filled: false,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}
