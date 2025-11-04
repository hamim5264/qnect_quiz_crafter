import 'package:flutter/material.dart';
import '../../ui/design_system/tokens/colors.dart';

class CommonCurvedBackground extends StatelessWidget {
  const CommonCurvedBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CurvedBackgroundPainter(),
      size: MediaQuery.of(context).size,
    );
  }
}

class _CurvedBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    paint.color = AppColors.primaryDark;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width * 0.55, 0);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.25,
      0,
      size.height * 0.4,
    );
    path.close();

    canvas.drawPath(path, Paint()..color = AppColors.secondaryDark);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
