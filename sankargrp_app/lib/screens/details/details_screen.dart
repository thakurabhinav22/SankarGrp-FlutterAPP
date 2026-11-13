import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/solar_system.dart';

class DetailsScreen extends StatelessWidget {
  final SolarSystem solarSystem;

  const DetailsScreen({super.key, required this.solarSystem});

  static const Color brandNavy = Color(0xFF0F2238);
  static const Color brandYellow = Color(0xFFFBBF24);
  static const Color ecoGreen = Color(0xFF10B981);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CupertinoNavigationBar(
        backgroundColor: Colors.white.withValues(alpha: 0.9),
        border: null,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(CupertinoIcons.back, color: brandNavy, size: 22),
              SizedBox(width: 4),
              Text(
                'Back',
                style: TextStyle(
                  color: brandNavy,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'SF Pro Display',
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        middle: Text(
          solarSystem.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'SF Pro Display',
            color: brandNavy,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Hero Card
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0F2238), Color(0xFF1E3A5F)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: brandNavy.withValues(alpha: 0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: brandYellow.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              solarSystem.category.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'SF Pro Display',
                                color: brandYellow,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            solarSystem.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'SF Pro Display',
                              color: Colors.white,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Estimated Package Price',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      color: Color(0xFF94A3B8),
                                      fontFamily: 'SF Pro Display',
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    solarSystem.priceFormatted,
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'SF Pro Display',
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              if (solarSystem.subsidyAmount.isNotEmpty &&
                                  solarSystem.subsidyAmount != 'N/A')
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ecoGreen.withValues(alpha: 0.25),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Subsidy: ${solarSystem.subsidyAmount}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'SF Pro Display',
                                      color: Color(0xFF6EE7B7),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Metrics Strip
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricBox(
                            icon: CupertinoIcons.sun_max_fill,
                            color: brandYellow,
                            title: solarSystem.estimatedDailyGen,
                            subtitle: 'Daily Generation',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildMetricBox(
                            icon: CupertinoIcons.money_dollar_circle_fill,
                            color: ecoGreen,
                            title: solarSystem.monthlySavings,
                            subtitle: 'Monthly Savings',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildMetricBox(
                            icon: CupertinoIcons.shield_lefthalf_fill,
                            color: const Color(0xFF3B82F6),
                            title: solarSystem.warranty.split(' ').first,
                            subtitle: 'Warranty',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Overview Section
                    const Text(
                      'Overview',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'SF Pro Display',
                        color: brandNavy,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      solarSystem.description,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontFamily: 'SF Pro Display',
                        color: Color(0xFF475569),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Hardware Specifications
                    const Text(
                      'Technical Specifications',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'SF Pro Display',
                        color: brandNavy,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        children: solarSystem.specs.map((spec) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  spec.key,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'SF Pro Display',
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                Text(
                                  spec.value,
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'SF Pro Display',
                                    color: brandNavy,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Key Features List
                    const Text(
                      'Package Features',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'SF Pro Display',
                        color: brandNavy,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...solarSystem.features.map((feature) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              CupertinoIcons.checkmark_circle_fill,
                              color: ecoGreen,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                feature,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'SF Pro Display',
                                  color: Color(0xFF334155),
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom Order Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: brandNavy.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (ctx) => CupertinoAlertDialog(
                      title: const Text('Order Placed Successfully'),
                      content: Text(
                        'Thank you for selecting "${solarSystem.name}". A Sankar Group solar engineer will contact you shortly.',
                      ),
                      actions: [
                        CupertinoDialogAction(
                          child: const Text('OK'),
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: brandYellow,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  alignment: Alignment.center,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.cart_badge_plus, color: brandNavy),
                      SizedBox(width: 8),
                      Text(
                        'Order Now',
                        style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'SF Pro Display',
                          color: brandNavy,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricBox({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              fontFamily: 'SF Pro Display',
              color: brandNavy,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10.5,
              fontFamily: 'SF Pro Display',
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}
