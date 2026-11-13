import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/solar_system.dart';
import '../../widgets/solar_panel_illustration.dart';
import '../details/details_screen.dart';

class SolarListingScreen extends StatefulWidget {
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

  @override
  State<SolarListingScreen> createState() => _SolarListingScreenState();
}

class _SolarListingScreenState extends State<SolarListingScreen> {
  int _selectedCategoryIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  static const List<String> _categories = [
    'All Packages',
    'Residential',
    'Hybrid & Battery',
    'Commercial',
    'Agriculture',
  ];

  static const Color brandNavy = Color(0xFF0F172A);
  static const Color brandYellow = Color(0xFFFBBF24);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<SolarSystem> get _filteredSystems {
    final query = _searchController.text.trim().toLowerCase();
    return widget.solarSystems.where((item) {
      final matchesCategory = _selectedCategoryIndex == 0 ||
          (_selectedCategoryIndex == 1 &&
              item.category.toLowerCase().contains('residential')) ||
          (_selectedCategoryIndex == 2 &&
              (item.category.toLowerCase().contains('hybrid') ||
                  item.category.toLowerCase().contains('storage'))) ||
          (_selectedCategoryIndex == 3 &&
              item.category.toLowerCase().contains('commercial')) ||
          (_selectedCategoryIndex == 4 &&
              item.category.toLowerCase().contains('agriculture'));

      final matchesQuery = query.isEmpty ||
          item.name.toLowerCase().contains(query) ||
          item.category.toLowerCase().contains(query) ||
          item.description.toLowerCase().contains(query);

      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading && widget.solarSystems.isEmpty && widget.errorMessage == null) {
      return const Center(
        child: CupertinoActivityIndicator(radius: 14),
      );
    }

    if (widget.errorMessage != null && widget.solarSystems.isEmpty) {
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
                widget.errorMessage!,
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
                  widget.onRefresh();
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

    final filtered = _filteredSystems;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: () async => widget.onRefresh(),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Search Bar
                Container(
                  height: 46,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        CupertinoIcons.search,
                        size: 18,
                        color: Color(0xFF94A3B8),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CupertinoTextField(
                          controller: _searchController,
                          placeholder: 'Filter by capacity, kW, or inverter',
                          placeholderStyle: const TextStyle(
                            fontSize: 13.5,
                            fontFamily: 'SF Pro Display',
                            color: Color(0xFF94A3B8),
                          ),
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontFamily: 'SF Pro Display',
                            color: brandNavy,
                          ),
                          decoration: null,
                          padding: EdgeInsets.zero,
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            setState(() {});
                          },
                          child: const Icon(
                            CupertinoIcons.clear_circled_solid,
                            size: 16,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // 2. Horizontal Filter Segment Pills
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: List.generate(_categories.length, (index) {
                      final isSelected = _selectedCategoryIndex == index;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() => _selectedCategoryIndex = index);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ? brandNavy : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? brandNavy
                                    : const Color(0xFFE2E8F0),
                                width: 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: brandNavy.withValues(alpha: 0.15),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Text(
                              _categories[index],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                                fontFamily: 'SF Pro Display',
                                color: isSelected ? Colors.white : brandNavy,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 3. Package Cards List
        if (filtered.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(CupertinoIcons.cube_box, size: 48, color: Color(0xFFCBD5E1)),
                  SizedBox(height: 12),
                  Text(
                    'No Matching Packages',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'SF Pro Display',
                      color: brandNavy,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Try adjusting your search or category filter',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontFamily: 'SF Pro Display',
                      color: Color(0xFF64748B),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = filtered[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildModernPackageCard(context, item),
                  );
                },
                childCount: filtered.length,
              ),
            ),
          ),
      ],
    );
  }

  // --- Modern Redesigned Package Card ---
  Widget _buildModernPackageCard(BuildContext context, SolarSystem item) {
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
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Row: Category Pill + Warranty Tag
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item.category.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'SF Pro Display',
                      color: Color(0xFF059669),
                      letterSpacing: 0.4,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      CupertinoIcons.checkmark_shield_fill,
                      size: 13,
                      color: Color(0xFF059669),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.warranty,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'SF Pro Display',
                        color: Color(0xFF059669),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Middle: Vector Illustration & Package Info Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Illustration Box
                Container(
                  width: 90,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: const SolarPanelIllustration(
                    width: 82,
                    height: 60,
                  ),
                ),
                const SizedBox(width: 14),

                // Name & Spec info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'SF Pro Display',
                          color: brandNavy,
                          letterSpacing: -0.4,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'SF Pro Display',
                          color: Color(0xFF64748B),
                          height: 1.35,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(color: Color(0xFFF1F5F9), height: 1),
            const SizedBox(height: 12),

            // Bottom Metrics Strip: Est. Yield | Subsidy | Price & Action
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Daily Yield',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'SF Pro Display',
                        color: Color(0xFF94A3B8),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      item.estimatedDailyGen,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'SF Pro Display',
                        color: brandNavy,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Govt. Subsidy',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'SF Pro Display',
                        color: Color(0xFF94A3B8),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      item.subsidyAmount,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'SF Pro Display',
                        color: Color(0xFF059669),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
                const Spacer(),

                // Price and View Pill
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.priceFormatted,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'SF Pro Display',
                        color: brandNavy,
                        letterSpacing: -0.3,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: brandYellow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Text(
                            'View',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'SF Pro Display',
                              color: brandNavy,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(width: 3),
                          Icon(
                            CupertinoIcons.chevron_right,
                            size: 10,
                            color: brandNavy,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
