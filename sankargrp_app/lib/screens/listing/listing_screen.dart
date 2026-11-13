import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/solar_system.dart';
import '../details/details_screen.dart';

class SolarListingScreen extends StatelessWidget {
  final List<SolarSystem> solarSystems;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onRefresh;

  const SolarListingScreen({
    super.key,
    required this.solarSystems,
    required this.isLoading,
    this.errorMessage,
    required this.onRefresh,
  });

  static const Color brandNavy = Color(0xFF0F2238);
  static const Color brandYellow = Color(0xFFFBBF24);
  static const Color ecoGreen = Color(0xFF10B981);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CupertinoActivityIndicator(radius: 14),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEE2E2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  CupertinoIcons.exclamationmark_triangle_fill,
                  size: 32,
                  color: Color(0xFFDC2626),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Failed to Load Packages',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'SF Pro Display',
                  color: brandNavy,
                  letterSpacing: -0.3,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'SF Pro Display',
                  color: Color(0xFF64748B),
                  height: 1.4,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 20),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onRefresh();
                },
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  decoration: BoxDecoration(
                    color: brandNavy,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Retry Connection',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'SF Pro Display',
                      color: Colors.white,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (solarSystems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(CupertinoIcons.clear_circled, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            const Text(
              'No Solar Packages Found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: 'SF Pro Display',
                color: brandNavy,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 8),
            CupertinoButton(
              onPressed: onRefresh,
              child: const Text('Try Refreshing'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        HapticFeedback.selectionClick();
        onRefresh();
      },
      color: brandYellow,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
        itemCount: solarSystems.length,
        itemBuilder: (context, index) {
          final item = solarSystems[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildItemCard(context, item),
          );
        },
      ),
    );
  }

  Widget _buildItemCard(BuildContext context, SolarSystem item) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (_) => DetailsScreen(solarSystem: item),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: brandNavy.withValues(alpha: 0.04),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: ecoGreen.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item.category,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'SF Pro Display',
                      color: ecoGreen,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Text(
                  item.priceFormatted,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'SF Pro Display',
                    color: brandNavy,
                    letterSpacing: -0.3,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Text(
              item.name,
              style: const TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w800,
                fontFamily: 'SF Pro Display',
                color: brandNavy,
                letterSpacing: -0.4,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 6),

            Text(
              item.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12.5,
                fontFamily: 'SF Pro Display',
                color: Color(0xFF64748B),
                height: 1.4,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                _buildMiniChip(
                  icon: CupertinoIcons.bolt_fill,
                  label: item.estimatedDailyGen,
                  color: brandYellow,
                ),
                const SizedBox(width: 8),
                _buildMiniChip(
                  icon: CupertinoIcons.money_dollar_circle_fill,
                  label: item.monthlySavings,
                  color: ecoGreen,
                ),
                const Spacer(),
                const Icon(
                  CupertinoIcons.chevron_right,
                  size: 16,
                  color: Color(0xFF94A3B8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4.5),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              fontFamily: 'SF Pro Display',
              color: brandNavy,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}
