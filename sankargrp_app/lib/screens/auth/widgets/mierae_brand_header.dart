import 'package:flutter/material.dart';
import '../../splash/widgets/sun_logo.dart';

class MieraeBrandHeader extends StatelessWidget {
  final double sunSize;
  final double mieraeFontSize;
  final double solarFontSize;
  final double solarLetterSpacing;

  const MieraeBrandHeader({
    super.key,
    this.sunSize = 34,
    this.mieraeFontSize = 19,
    this.solarFontSize = 7.5,
    this.solarLetterSpacing = 3.2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SunLogo(
          size: sunSize,
          color: const Color(0xFFF5A623),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'mierae',
              style: TextStyle(
                fontSize: mieraeFontSize,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.6,
                color: const Color(0xFF0F2238),
                height: 1.0,
              ),
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(left: 1.0),
              child: Text(
                'S O L A R',
                style: TextStyle(
                  fontSize: solarFontSize,
                  fontWeight: FontWeight.w800,
                  letterSpacing: solarLetterSpacing,
                  color: const Color(0xFFF5A623),
                  height: 1.0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
