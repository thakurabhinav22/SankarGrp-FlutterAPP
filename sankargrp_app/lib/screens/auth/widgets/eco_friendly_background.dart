import 'package:flutter/material.dart';

/// A custom painter that draws subtle, elegant eco-friendly leaves and botanical vines
/// in soft translucent green tones.
class EcoFriendlyBackgroundPainter extends CustomPainter {
  final Color primaryGreen;
  final Color secondaryGreen;

  const EcoFriendlyBackgroundPainter({
    this.primaryGreen = const Color(0xFF10B981), // Emerald/Mint
    this.secondaryGreen = const Color(0xFF84CC16), // Lime leaf
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Top-Right Botanical Branch & Leaves
    _drawTopRightBranch(canvas, size);

    // 2. Bottom-Left Botanical Branch & Leaves
    _drawBottomLeftBranch(canvas, size);

    // 3. Subtle floating organic energy orbs/glows
    final glowPaint = Paint()
      ..color = const Color(0xFF10B981).withValues(alpha: 0.04)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 60);

    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.15), 110, glowPaint);
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.85), 130, glowPaint);
  }

  void _drawTopRightBranch(Canvas canvas, Size size) {
    final stemPaint = Paint()
      ..color = primaryGreen.withValues(alpha: 0.18)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final stemPath = Path();
    stemPath.moveTo(size.width + 10, -10);
    stemPath.cubicTo(
      size.width * 0.82, size.height * 0.05,
      size.width * 0.78, size.height * 0.13,
      size.width * 0.88, size.height * 0.22,
    );
    canvas.drawPath(stemPath, stemPaint);

    // Draw leafy accents along the branch
    _drawLeaf(canvas, Offset(size.width * 0.88, size.height * 0.04), -0.6, 26, 12, primaryGreen.withValues(alpha: 0.16));
    _drawLeaf(canvas, Offset(size.width * 0.80, size.height * 0.09), 0.7, 30, 14, secondaryGreen.withValues(alpha: 0.18));
    _drawLeaf(canvas, Offset(size.width * 0.82, size.height * 0.16), -0.8, 28, 13, primaryGreen.withValues(alpha: 0.16));
    _drawLeaf(canvas, Offset(size.width * 0.88, size.height * 0.22), 0.4, 24, 11, secondaryGreen.withValues(alpha: 0.18));
    _drawLeaf(canvas, Offset(size.width * 0.95, size.height * 0.11), 1.2, 22, 10, primaryGreen.withValues(alpha: 0.14));
  }

  void _drawBottomLeftBranch(Canvas canvas, Size size) {
    final stemPaint = Paint()
      ..color = primaryGreen.withValues(alpha: 0.18)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final stemPath = Path();
    stemPath.moveTo(-10, size.height + 10);
    stemPath.cubicTo(
      size.width * 0.18, size.height * 0.95,
      size.width * 0.22, size.height * 0.87,
      size.width * 0.12, size.height * 0.78,
    );
    canvas.drawPath(stemPath, stemPaint);

    // Draw leafy accents along the branch
    _drawLeaf(canvas, Offset(size.width * 0.12, size.height * 0.96), 0.6, 28, 13, secondaryGreen.withValues(alpha: 0.18));
    _drawLeaf(canvas, Offset(size.width * 0.20, size.height * 0.91), -0.7, 32, 15, primaryGreen.withValues(alpha: 0.16));
    _drawLeaf(canvas, Offset(size.width * 0.18, size.height * 0.84), 0.8, 26, 12, secondaryGreen.withValues(alpha: 0.18));
    _drawLeaf(canvas, Offset(size.width * 0.12, size.height * 0.78), -0.5, 24, 11, primaryGreen.withValues(alpha: 0.16));
    _drawLeaf(canvas, Offset(size.width * 0.05, size.height * 0.89), -1.2, 22, 10, secondaryGreen.withValues(alpha: 0.14));
  }

  void _drawLeaf(
    Canvas canvas,
    Offset position,
    double angle,
    double length,
    double width,
    Color color,
  ) {
    final leafPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(angle);

    final path = Path();
    path.moveTo(0, 0);
    // Left curve of leaf
    path.quadraticBezierTo(-width / 2, length * 0.5, 0, length);
    // Right curve of leaf
    path.quadraticBezierTo(width / 2, length * 0.5, 0, 0);
    path.close();

    canvas.drawPath(path, leafPaint);

    // Subtle leaf center vein
    final veinPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    canvas.drawLine(const Offset(0, 2), Offset(0, length * 0.85), veinPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
