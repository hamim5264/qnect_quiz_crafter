import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class QuizNumberSlider extends StatefulWidget {
  final int total;
  final int current;
  final ValueChanged<int> onSelect;

  const QuizNumberSlider({
    super.key,
    required this.total,
    required this.current,
    required this.onSelect,
  });

  @override
  State<QuizNumberSlider> createState() => _QuizNumberSliderState();
}

class _QuizNumberSliderState extends State<QuizNumberSlider> {
  final AudioPlayer _player = AudioPlayer();

  Future<void> _playSwipeSound() async {
    await _player.setAsset('assets/sounds/swipe.mp3');
    _player.play();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 20, right: 20, bottom: 6),
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.total,
          itemBuilder: (context, index) {
            final isActive = index == widget.current;
            return GestureDetector(
              onTap: () {
                _playSwipeSound();
                widget.onSelect(index);
              },
              child: AnimatedScale(
                scale: isActive ? 1.2 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "${index + 1}",
                    style: TextStyle(
                      fontFamily: AppTypography.family,
                      fontWeight: FontWeight.bold,
                      color: isActive ? AppColors.chip1 : Colors.black54,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
