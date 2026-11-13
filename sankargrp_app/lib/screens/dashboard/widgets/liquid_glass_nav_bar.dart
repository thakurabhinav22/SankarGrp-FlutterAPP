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

class LiquidGlassNavBar extends StatefulWidget {
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
  State<LiquidGlassNavBar> createState() => _LiquidGlassNavBarState();
}

class _LiquidGlassNavBarState extends State<LiquidGlassNavBar> {
  // If user is dragging the glass pill, track position continuously
  bool _isDragging = false;
  double _dragPosition = 0.0; // Current slot fractional position [0 .. items.length - 1]

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final bottomMargin = bottomInset > 0 ? bottomInset + 8.0 : 16.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, bottomMargin),
      child: SizedBox(
        height: widget.barHeight,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(34),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final barWidth = constraints.maxWidth;
              final slotWidth = barWidth / widget.items.length;

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onHorizontalDragStart: (details) {
                  setState(() {
                    _isDragging = true;
                    _updateDrag(details.localPosition.dx, slotWidth);
                  });
                },
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    _updateDrag(details.localPosition.dx, slotWidth);
                  });
                },
                onHorizontalDragEnd: (details) {
                  _finishDrag();
                },
                onHorizontalDragCancel: () {
                  setState(() => _isDragging = false);
                },
                child: Stack(
                  children: [
                    // 1. Frosted Glass Base Bar
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: widget.barBlurSigma,
                          sigmaY: widget.barBlurSigma,
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

                    // 2. Interactive Sliding & Draggable Liquid Glass Pill
                    _InteractiveGlassPill(
                      isDragging: _isDragging,
                      currentPosition: _isDragging
                          ? _dragPosition
                          : widget.selectedIndex.toDouble(),
                      slotWidth: slotWidth,
                      barHeight: widget.barHeight,
                      blurSigma: widget.pillBlurSigma,
                      activeColor: widget.activeColor,
                    ),

                    // 3. Tab Items (Tap targets & labels)
                    Row(
                      children: List.generate(widget.items.length, (index) {
                        final item = widget.items[index];
                        final isSelected = widget.selectedIndex == index;

                        return Expanded(
                          child: InkWell(
                            onTap: () {
                              widget.onItemSelected(index);
                            },
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
                                      : widget.inactiveColor,
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
                                        : widget.inactiveColor,
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
              );
            },
          ),
        ),
      ),
    );
  }

  void _updateDrag(double localDx, double slotWidth) {
    final maxIndex = widget.items.length - 1;
    final pos = ((localDx - (slotWidth / 2)) / slotWidth).clamp(0.0, maxIndex.toDouble());
    _dragPosition = pos;

    // Haptic feedback / immediate selection updates if crossed slot center
    final nearestIndex = _dragPosition.round();
    if (nearestIndex != widget.selectedIndex) {
      widget.onItemSelected(nearestIndex);
    }
  }

  void _finishDrag() {
    final targetIndex = _dragPosition.round().clamp(0, widget.items.length - 1);
    setState(() {
      _isDragging = false;
    });
    widget.onItemSelected(targetIndex);
  }
}

/// Glass Pill Widget that renders either with AnimatedPositioned (on tap)
/// or instantaneous Positioned (while dragging smoothly under the user's finger)
class _InteractiveGlassPill extends StatelessWidget {
  final bool isDragging;
  final double currentPosition;
  final double slotWidth;
  final double barHeight;
  final double blurSigma;
  final Color activeColor;

  const _InteractiveGlassPill({
    required this.isDragging,
    required this.currentPosition,
    required this.slotWidth,
    required this.barHeight,
    required this.blurSigma,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    const vMargin = 6.0;
    final pillHeight = barHeight - (vMargin * 2);
    final pillWidth = slotWidth - 10.0;
    final leftOffset = (slotWidth * currentPosition) + ((slotWidth - pillWidth) / 2);

    final pillDecoration = ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurSigma,
          sigmaY: blurSigma,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: LinearGradient(
              colors: [
                activeColor.withValues(alpha: isDragging ? 0.38 : 0.28),
                activeColor.withValues(alpha: isDragging ? 0.22 : 0.14),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: isDragging ? 0.95 : 0.8),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: activeColor.withValues(alpha: isDragging ? 0.35 : 0.25),
                blurRadius: isDragging ? 18 : 14,
                spreadRadius: isDragging ? 1.5 : 0.5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: isDragging
              ? Center(
                  child: Container(
                    width: 18,
                    height: 3,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F2238).withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                )
              : null,
        ),
      ),
    );

    if (isDragging) {
      // While user drags: follow touch directly without animation lag
      return Positioned(
        left: leftOffset,
        top: vMargin,
        width: pillWidth,
        height: pillHeight,
        child: pillDecoration,
      );
    } else {
      // When released or tapped: smooth spring / easeOutCubic interpolation
      return AnimatedPositioned(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        left: leftOffset,
        top: vMargin,
        width: pillWidth,
        height: pillHeight,
        child: pillDecoration,
      );
    }
  }
}
