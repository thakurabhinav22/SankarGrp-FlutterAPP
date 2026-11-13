import 'package:flutter/material.dart';

class AuthSegmentedControl extends StatelessWidget {
  final bool isLoginSelected;
  final VoidCallback onLoginTap;
  final VoidCallback onSignUpTap;

  const AuthSegmentedControl({
    super.key,
    required this.isLoginSelected,
    required this.onLoginTap,
    required this.onSignUpTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(24), // Pill curved switch
      ),
      child: Row(
        children: [
          // Log in tab
          Expanded(
            child: GestureDetector(
              onTap: onLoginTap,
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: isLoginSelected
                      ? const Color(0xFFF5A623)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isLoginSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFFF5A623).withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  'Log in',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isLoginSelected
                        ? FontWeight.w700
                        : FontWeight.w600,
                    color: isLoginSelected
                        ? const Color(0xFF0F2238)
                        : const Color(0xFF64748B),
                  ),
                ),
              ),
            ),
          ),
          // Sign up tab
          Expanded(
            child: GestureDetector(
              onTap: onSignUpTap,
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: !isLoginSelected
                      ? const Color(0xFFF5A623)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: !isLoginSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFFF5A623).withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  'Sign up',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: !isLoginSelected
                        ? FontWeight.w700
                        : FontWeight.w600,
                    color: !isLoginSelected
                        ? const Color(0xFF0F2238)
                        : const Color(0xFF64748B),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
