import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GuestButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double borderRadius;

  const GuestButton({
    super.key,
    required this.onPressed,
    this.borderRadius = 25, // Full smooth pill curve
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: const Color(0xFFCBD5E1),
            width: 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.eco_outlined,
              size: 17,
              color: Color(0xFF10B981),
            ),
            SizedBox(width: 8),
            Text(
              'Continue as guest',
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F2238),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
