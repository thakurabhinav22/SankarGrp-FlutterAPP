import 'dart:math' as math;
import 'package:flutter/material.dart';

class SunLogo extends StatelessWidget {
  final double size;
  final Color color;

  const SunLogo({
    super.key,
    this.size = 120,
    this.color = const Color(0xFFFBBF24), // Vibrant golden yellow
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _SunPainter(color: color),
      ),
    );
  }
}

class _SunPainter extends CustomPainter {
  final Color color;

  _SunPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.28;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Draw central sun circle
    canvas.drawCircle(center, radius, paint);

    // Draw 12 rounded pill rays around the circle
    const int rayCount = 12;
    final rayInnerRadius = size.width * 0.36;
    final rayOuterRadius = size.width * 0.47;
    final rayWidth = size.width * 0.055;

    for (int i = 0; i < rayCount; i++) {
      final double angle = (i * 2 * math.pi) / rayCount;

      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle);

      // Ray rectangle from rayInnerRadius to rayOuterRadius centered along X axis
      final rayRect = RRect.fromRectAndRadius(
        Rect.fromLTRB(
          -rayWidth / 2,
          rayInnerRadius,
          rayWidth / 2,
          rayOuterRadius,
        ),
        Radius.circular(rayWidth / 2),
      );

      canvas.drawRRect(rayRect, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _SunPainter oldDelegate) =>
      oldDelegate.color != color;
}
