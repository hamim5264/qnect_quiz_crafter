import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../../ui/design_system/tokens/typography.dart';

class SurpriseQuizTimePicker extends StatelessWidget {
  final Duration duration;
  final ValueChanged<Duration> onChanged;

  const SurpriseQuizTimePicker({
    super.key,
    required this.duration,
    required this.onChanged,
  });

  Future<void> _showPicker(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.primaryLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          height: 220,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: CupertinoTheme(
            data: const CupertinoThemeData(
              brightness: Brightness.dark,
              textTheme: CupertinoTextThemeData(
                dateTimePickerTextStyle: TextStyle(
                  color: Colors.white,
                  fontFamily: AppTypography.family,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            child: CupertinoTimerPicker(
              mode: CupertinoTimerPickerMode.ms,
              initialTimerDuration: duration,
              onTimerDurationChanged: (newDuration) => onChanged(newDuration),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final display = "${duration.inMinutes} min ${duration.inSeconds % 60} sec";

    return GestureDetector(
      onTap: () => _showPicker(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              display,
              style: const TextStyle(
                fontFamily: AppTypography.family,
                color: Colors.white70,
              ),
            ),
            const Icon(CupertinoIcons.clock_fill, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
