import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/solar_system.dart';
import '../../../widgets/solar_panel_illustration.dart';
import '../../details/details_screen.dart';

class HomeDashboardView extends StatefulWidget {
  final DashboardSummary? summary;
  final List<SolarSystem> featuredSystems;
  final bool isLoading;
  final String? errorMessage;
  final String userName;
  final VoidCallback onRefresh;
  final VoidCallback onExploreAll;
  final Function(int)? onNavigateTab;

  const HomeDashboardView({
    super.key,
    required this.summary,
    required this.featuredSystems,
    required this.isLoading,
    this.errorMessage,
    this.userName = 'Abhinav',
    required this.onRefresh,
    required this.onExploreAll,
    this.onNavigateTab,
  });

  @override
  State<HomeDashboardView> createState() => _HomeDashboardViewState();
}

class _HomeDashboardViewState extends State<HomeDashboardView> {
  String _selectedCity = 'Visakhapatnam';
  final TextEditingController _searchController = TextEditingController();

  static const Color brandNavy = Color(0xFF0F172A);
  static const Color brandYellow = Color(0xFFFBBF24);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showCitySelector() {
    final cities = [
      'Visakhapatnam',
      'Hyderabad',
      'Vijayawada',
      'Bengaluru',
      'Chennai',
      'Mumbai',
      'Delhi NCR'
    ];
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Select Location for Solar Radiation'),
        actions: cities.map((city) {
          return CupertinoActionSheetAction(
            onPressed: () {
              setState(() => _selectedCity = city);
              Navigator.pop(context);
            },
            child: Text(city),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading && widget.summary == null && widget.errorMessage == null) {
      return const Center(
        child: CupertinoActivityIndicator(radius: 14),
      );
    }

    if (widget.errorMessage != null && widget.summary == null) {
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
                  CupertinoIcons.wifi_exclamationmark,
                  size: 32,
                  color: Color(0xFFDC2626),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Server Connection Error',
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
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Top Greeting Header
                _buildHeaderSection(),
                const SizedBox(height: 18),

                // 2. Search & Filter Bar
                _buildSearchBar(),
                const SizedBox(height: 18),

                // 3. Solar Radiation Weather Card
                _buildRadiationCard(),
                const SizedBox(height: 18),

                // 4. Quick Action Grid (Packages, Calculator, Book visit, My requests)
                _buildQuickActionsRow(),
                const SizedBox(height: 20),

                // 5. Electricity Bill Reduction Banner
                _buildSavingsBanner(),
                const SizedBox(height: 24),

                // 6. Popular Packages Section
                _buildPopularPackagesSection(),
                const SizedBox(height: 24),

                // 7. Why Mierae Chips / Value Badges
                _buildWhyMieraeChips(),
                const SizedBox(height: 24),

                // 8. Recent Requests Strip
                _buildRecentRequestsStrip(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- 1. Top Greeting Header ---
  Widget _buildHeaderSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Little Sun Icon
              const Icon(
                CupertinoIcons.sun_max_fill,
                color: Color(0xFFFBBF24),
                size: 26,
              ),
              const SizedBox(height: 8),
              Text(
                'Good morning, ${widget.userName}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'SF Pro Display',
                  color: brandNavy,
                  letterSpacing: -0.5,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 3),
              const Text(
                "Let's power your home with the sun",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'SF Pro Display',
                  color: Color(0xFF64748B),
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
        // Notification bell and Avatar
        Row(
          children: [
            GestureDetector(
              onTap: () => HapticFeedback.lightImpact(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Icon(
                  CupertinoIcons.bell,
                  color: brandNavy,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFE2E8F0),
              ),
              child: const Icon(
                CupertinoIcons.person_crop_circle_fill,
                color: Color(0xFF64748B),
                size: 38,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- 2. Search & Filter Bar ---
  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(
                  CupertinoIcons.search,
                  size: 19,
                  color: Color(0xFF94A3B8),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CupertinoTextField(
                    controller: _searchController,
                    placeholder: 'Search solar packages',
                    placeholderStyle: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'SF Pro Display',
                      color: Color(0xFF94A3B8),
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'SF Pro Display',
                      color: brandNavy,
                    ),
                    decoration: null,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => HapticFeedback.selectionClick(),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              CupertinoIcons.slider_horizontal_3,
              size: 20,
              color: brandNavy,
            ),
          ),
        ),
      ],
    );
  }

  // --- 3. Solar Radiation Weather Card ---
  Widget _buildRadiationCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7).withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFDE68A),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // City Pill Dropdown
              GestureDetector(
                onTap: _showCitySelector,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selectedCity,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'SF Pro Display',
                          color: brandNavy,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        CupertinoIcons.chevron_down,
                        size: 12,
                        color: brandNavy,
                      ),
                    ],
                  ),
                ),
              ),
              // Sun outline icon
              const Icon(
                CupertinoIcons.sun_max,
                color: Color(0xFFB45309),
                size: 26,
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Radiation Value
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: const [
              Text(
                '5.8 ',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'SF Pro Display',
                  color: brandNavy,
                  letterSpacing: -0.6,
                  decoration: TextDecoration.none,
                ),
              ),
              Text(
                'kWh/m²',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'SF Pro Display',
                  color: brandNavy,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          const Text(
            'Solar radiation today',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontFamily: 'SF Pro Display',
              color: Color(0xFF78350F),
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 14),
          const Divider(color: Color(0xFFFDE68A), height: 1),
          const SizedBox(height: 12),
          // Generation insight pill
          Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: 'A 3 kW system could generate about ',
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF451A03),
                      fontFamily: 'SF Pro Display',
                    ),
                    children: const [
                      TextSpan(
                        text: '14 units today',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Great day for solar',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'SF Pro Display',
                    color: Colors.white,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- 4. Quick Action Row ---
  Widget _buildQuickActionsRow() {
    final actions = [
      {
        'title': 'Packages',
        'icon': CupertinoIcons.cube_box,
        'tab': 1,
      },
      {
        'title': 'Calculator',
        'icon': CupertinoIcons.slider_horizontal_below_rectangle,
        'tab': 2,
      },
      {
        'title': 'Book visit',
        'icon': CupertinoIcons.calendar_badge_plus,
        'tab': 3,
      },
      {
        'title': 'My requests',
        'icon': CupertinoIcons.doc_text,
        'tab': 3,
      },
    ];

    return Row(
      children: actions.map((item) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                final tab = item['tab'] as int;
                if (widget.onNavigateTab != null) {
                  widget.onNavigateTab!(tab);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(
                      item['icon'] as IconData,
                      size: 24,
                      color: brandNavy,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['title'] as String,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SF Pro Display',
                        color: brandNavy,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // --- 5. Electricity Bill Reduction Banner ---
  Widget _buildSavingsBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Text Content
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cut your electricity bill\nby up to 90%',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'SF Pro Display',
                    color: Colors.white,
                    height: 1.25,
                    letterSpacing: -0.4,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    if (widget.onNavigateTab != null) {
                      widget.onNavigateTab!(2); // Calculator Tab
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBBF24),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Text(
                      'Calculate savings',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'SF Pro Display',
                        color: Color(0xFF0F172A),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Solar Vector Art
          const Expanded(
            flex: 5,
            child: SolarPanelIllustration(
              width: 130,
              height: 85,
            ),
          ),
        ],
      ),
    );
  }

  // --- 6. Popular Packages Section ---
  Widget _buildPopularPackagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Popular packages',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                fontFamily: 'SF Pro Display',
                color: brandNavy,
                letterSpacing: -0.4,
                decoration: TextDecoration.none,
              ),
            ),
            GestureDetector(
              onTap: widget.onExploreAll,
              child: const Text(
                'See all',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'SF Pro Display',
                  color: brandNavy,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: widget.featuredSystems.isEmpty
                ? 3
                : widget.featuredSystems.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final system = widget.featuredSystems.isNotEmpty
                  ? widget.featuredSystems[index]
                  : null;

              final capacityText = system?.specs
                      .firstWhere((s) => s.key == 'Capacity',
                          orElse: () => const SolarSpec(key: 'Capacity', value: '3 kW'))
                      .value ??
                  '3 kW';
              final priceText = system?.priceFormatted ?? '₹ 1.8 L';
              final tag = system?.category.contains('Residential') == true
                  ? 'Home'
                  : 'Business';

              return Container(
                width: 145,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Panel Illustration Box
                    Container(
                      height: 85,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const SolarPanelIllustration(
                        width: 95,
                        height: 65,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      capacityText,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'SF Pro Display',
                        color: brandNavy,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'From $priceText',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SF Pro Display',
                        color: Color(0xFF64748B),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        // Tag Pill (Home / Business)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'SF Pro Display',
                              color: Color(0xFF475569),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        const Spacer(),
                        // View Yellow Button
                        GestureDetector(
                          onTap: () {
                            if (system != null) {
                              HapticFeedback.lightImpact();
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (_) => DetailsScreen(
                                    solarSystem: system,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: brandYellow,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'View',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'SF Pro Display',
                                color: brandNavy,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // --- 7. Why Mierae Chips ---
  Widget _buildWhyMieraeChips() {
    final chips = [
      '12-year warranty',
      '5-year free maintenance',
      '0 down payment EMI',
      'Tier 1 Components',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Why Mierae' Chips",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            fontFamily: 'SF Pro Display',
            color: brandNavy,
            letterSpacing: -0.3,
            decoration: TextDecoration.none,
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: chips.map((c) {
              return Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                    width: 0.8,
                  ),
                ),
                child: Text(
                  c,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'SF Pro Display',
                    color: Color(0xFF334155),
                    decoration: TextDecoration.none,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // --- 8. Recent Requests Strip ---
  Widget _buildRecentRequestsStrip() {
    final recentItems = [
      {
        'title': 'Site visit',
        'status': 'Scheduled',
        'icon': CupertinoIcons.calendar,
        'statusColor': const Color(0xFF10B981),
      },
      {
        'title': 'Design',
        'status': 'Ready for review',
        'icon': CupertinoIcons.pencil_outline,
        'statusColor': const Color(0xFFF59E0B),
      },
      {
        'title': 'Request',
        'status': 'Under process',
        'icon': CupertinoIcons.doc_text,
        'statusColor': const Color(0xFF3B82F6),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Requests Strip',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            fontFamily: 'SF Pro Display',
            color: brandNavy,
            letterSpacing: -0.3,
            decoration: TextDecoration.none,
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: recentItems.map((item) {
              return Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        item['icon'] as IconData,
                        size: 18,
                        color: brandNavy,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] as String,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'SF Pro Display',
                            color: brandNavy,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: item['statusColor'] as Color,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              item['status'] as String,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'SF Pro Display',
                                color: item['statusColor'] as Color,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
