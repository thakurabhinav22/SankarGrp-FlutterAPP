import 'dart:ui';
import 'package:flutter/material.dart';

class LiquidGlassNavBarItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final int? badge;

  const LiquidGlassNavBarItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    this.badge,
  });
}

class LiquidGlassNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final List<LiquidGlassNavBarItem> items;
  final Color activeColor;
  final Color inactiveColor;
  final double barHeight;
  final double barBlurSigma;
  final double pillBlurSigma;

  const LiquidGlassNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.items,
    this.activeColor = const Color(0xFFF5A623),
    this.inactiveColor = const Color(0xFF64748B),
    this.barHeight = 68.0,
    this.barBlurSigma = 24.0,
    this.pillBlurSigma = 32.0,
  }) : assert(items.length >= 2, 'At least 2 items are required.');

  @override
  Widget build(BuildContext context) {
    // Exact safe-area calculation for Android navigation buttons & iOS home bar
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final bottomMargin = bottomInset > 0 ? bottomInset + 8.0 : 16.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, bottomMargin),
      child: SizedBox(
        height: barHeight,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(34),
          child: Stack(
            children: [
              // 1. Frosted Glass Base Bar (backdrop blur + liquid sheen)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: barBlurSigma,
                    sigmaY: barBlurSigma,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.76),
                      borderRadius: BorderRadius.circular(34),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.95),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0F2238).withValues(alpha: 0.08),
                          blurRadius: 24,
                          spreadRadius: 1,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 2. Sliding Liquid Glass Pill Indicator
              _SlidingLiquidGlassPill(
                itemCount: items.length,
                currentIndex: selectedIndex,
                barHeight: barHeight,
                blurSigma: pillBlurSigma,
                activeColor: activeColor,
              ),

              // 3. Tab Items & Labels
              Row(
                children: List.generate(items.length, (index) {
                  final item = items[index];
                  final isSelected = selectedIndex == index;

                  return Expanded(
                    child: InkWell(
                      onTap: () => onItemSelected(index),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isSelected
                                ? (item.activeIcon ?? item.icon)
                                : item.icon,
                            size: 23,
                            color: isSelected
                                ? const Color(0xFF0F2238)
                                : inactiveColor,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: isSelected
                                  ? FontWeight.w800
                                  : FontWeight.w500,
                              color: isSelected
                                  ? const Color(0xFF0F2238)
                                  : inactiveColor,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Sliding Glass Pill Indicator that animates smoothly across tabs
class _SlidingLiquidGlassPill extends StatelessWidget {
  final int itemCount;
  final int currentIndex;
  final double barHeight;
  final double blurSigma;
  final Color activeColor;

  const _SlidingLiquidGlassPill({
    required this.itemCount,
    required this.currentIndex,
    required this.barHeight,
    required this.blurSigma,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final slotWidth = constraints.maxWidth / itemCount;
        const vMargin = 6.0;
        final pillHeight = barHeight - (vMargin * 2);
        final pillWidth = slotWidth - 10.0;
        final leftOffset = (slotWidth * currentIndex) + ((slotWidth - pillWidth) / 2);

        return Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              left: leftOffset,
              top: vMargin,
              width: pillWidth,
              height: pillHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(26),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: blurSigma,
                    sigmaY: blurSigma,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      // Liquid Glass gradient with specular top rim
                      gradient: LinearGradient(
                        colors: [
                          activeColor.withValues(alpha: 0.28),
                          activeColor.withValues(alpha: 0.14),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.8),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: activeColor.withValues(alpha: 0.25),
                          blurRadius: 14,
                          spreadRadius: 0.5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
