import 'package:flutter/material.dart';

/// Clean custom painter that renders the solar panel vector illustration
/// matching the uploaded design reference.
class SolarPanelIllustration extends StatelessWidget {
  final double width;
  final double height;

  const SolarPanelIllustration({
    super.key,
    this.width = 120,
    this.height = 80,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: _SolarIllustrationPainter(),
    );
  }
}

class _SolarIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Draw little green leaves on bottom right
    final leafPaint = Paint()..color = const Color(0xFF6EE7B7);
    final leafPath = Path();
    leafPath.moveTo(w * 0.78, h * 0.88);
    leafPath.quadraticBezierTo(w * 0.85, h * 0.70, w * 0.90, h * 0.88);
    leafPath.close();
    canvas.drawPath(leafPath, leafPaint);

    final leafPath2 = Path();
    leafPath2.moveTo(w * 0.84, h * 0.92);
    leafPath2.quadraticBezierTo(w * 0.94, h * 0.76, w * 0.96, h * 0.92);
    leafPath2.close();
    canvas.drawPath(leafPath2, leafPaint);

    // Draw Ground base stand
    final basePaint = Paint()..color = const Color(0xFFCBD5E1);
    final standPath = Path();
    standPath.moveTo(w * 0.44, h * 0.65);
    standPath.lineTo(w * 0.56, h * 0.65);
    standPath.lineTo(w * 0.58, h * 0.88);
    standPath.lineTo(w * 0.42, h * 0.88);
    standPath.close();
    canvas.drawPath(standPath, basePaint);

    // Ground mount plate
    final groundPlatePaint = Paint()..color = const Color(0xFF94A3B8);
    final groundPlate = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.36, h * 0.88, w * 0.28, h * 0.06),
      const Radius.circular(2),
    );
    canvas.drawRRect(groundPlate, groundPlatePaint);

    // Inverter box on the left side
    final invPaint = Paint()..color = const Color(0xFFFBBF24); // Yellow inverter
    final invStroke = Paint()
      ..color = const Color(0xFF0F172A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final invRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.12, h * 0.62, w * 0.14, h * 0.30),
      const Radius.circular(3),
    );
    canvas.drawRRect(invRect, invPaint);
    canvas.drawRRect(invRect, invStroke);

    // Inverter display screen
    final invScreen = Paint()..color = const Color(0xFF0F172A);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.145, h * 0.66, w * 0.09, h * 0.08),
        const Radius.circular(1.5),
      ),
      invScreen,
    );

    // Solar Panel (Isometric Angled Perspective)
    final panelPath = Path();
    final pLeftTop = Offset(w * 0.20, h * 0.15);
    final pRightTop = Offset(w * 0.82, h * 0.15);
    final pRightBottom = Offset(w * 0.72, h * 0.65);
    final pLeftBottom = Offset(w * 0.28, h * 0.65);

    panelPath.moveTo(pLeftTop.dx, pLeftTop.dy);
    panelPath.lineTo(pRightTop.dx, pRightTop.dy);
    panelPath.lineTo(pRightBottom.dx, pRightBottom.dy);
    panelPath.lineTo(pLeftBottom.dx, pLeftBottom.dy);
    panelPath.close();

    // Panel border frame (Silver aluminum)
    final framePaint = Paint()..color = const Color(0xFF94A3B8);
    canvas.drawPath(panelPath, framePaint);

    // Panel dark blue cells
    final cellPath = Path();
    final cLeftTop = Offset(w * 0.22, h * 0.18);
    final cRightTop = Offset(w * 0.80, h * 0.18);
    final cRightBottom = Offset(w * 0.705, h * 0.63);
    final cLeftBottom = Offset(w * 0.295, h * 0.63);

    cellPath.moveTo(cLeftTop.dx, cLeftTop.dy);
    cellPath.lineTo(cRightTop.dx, cRightTop.dy);
    cellPath.lineTo(cRightBottom.dx, cRightBottom.dy);
    cellPath.lineTo(cLeftBottom.dx, cLeftBottom.dy);
    cellPath.close();

    final cellPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF2C3E50), Color(0xFF1E293B)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(w * 0.2, h * 0.15, w * 0.6, h * 0.5));
    canvas.drawPath(cellPath, cellPaint);

    // Grid lines on panel (Silver lines)
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..strokeWidth = 0.9;

    // Horizontal grid lines (2 lines)
    for (int i = 1; i <= 2; i++) {
      final t = i / 3.0;
      final start = Offset.lerp(cLeftTop, cLeftBottom, t)!;
      final end = Offset.lerp(cRightTop, cRightBottom, t)!;
      canvas.drawLine(start, end, gridPaint);
    }

    // Vertical grid lines (3 lines)
    for (int i = 1; i <= 3; i++) {
      final t = i / 4.0;
      final start = Offset.lerp(cLeftTop, cRightTop, t)!;
      final end = Offset.lerp(cLeftBottom, cRightBottom, t)!;
      canvas.drawLine(start, end, gridPaint);
    }

    // Outer outline
    final strokePaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;
    canvas.drawPath(panelPath, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
