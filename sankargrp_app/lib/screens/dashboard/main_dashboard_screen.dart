import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import '../../models/solar_system.dart';
import '../../services/solar_api_service.dart';
import '../auth/login/login_screen.dart';
import '../listing/listing_screen.dart';
import 'widgets/home_dashboard_view.dart';
import 'widgets/profile_view.dart';

class MainDashboardScreen extends StatefulWidget {
  final bool isGuest;
  final String userName;

  const MainDashboardScreen({
    super.key,
    this.isGuest = false,
    this.userName = 'Alex Morgan',
  });

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  int _currentIndex = 0;

  List<SolarSystem> _solarSystems = [];
  DashboardSummary? _summary;
  bool _isLoading = true;
  String? _errorMessage;

  static const Color brandNavy = Color(0xFF0F2238);
  static const Color brandYellow = Color(0xFFFBBF24);

  static const List<GlassTab> _tabs = [
    GlassTab(
      icon: Icon(CupertinoIcons.house),
      activeIcon: Icon(CupertinoIcons.house_fill),
      label: 'Home',
    ),
    GlassTab(
      icon: Icon(CupertinoIcons.cube_box),
      activeIcon: Icon(CupertinoIcons.cube_box_fill),
      label: 'Packages',
    ),
    GlassTab(
      icon: Icon(CupertinoIcons.slider_horizontal_below_rectangle),
      activeIcon: Icon(CupertinoIcons.slider_horizontal_below_rectangle),
      label: 'Calculator',
    ),
    GlassTab(
      icon: Icon(CupertinoIcons.person),
      activeIcon: Icon(CupertinoIcons.person_fill),
      label: 'Profile',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await Future.wait([
        SolarApiService.fetchSolarSystems(),
        SolarApiService.fetchDashboardSummary(),
      ]);

      if (mounted) {
        setState(() {
          _solarSystems = results[0] as List<SolarSystem>;
          _summary = results[1] as DashboardSummary;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pushAndRemoveUntil(
      CupertinoPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      backgroundColor: Colors.white,
      bottomBar: GlassTabBar.bottom(
        tabs: _tabs,
        selectedIndex: _currentIndex,
        onTabSelected: (index) {
          setState(() => _currentIndex = index);
        },
        barHeight: 64,
        spacing: 8,
        horizontalPadding: 16,
        verticalPadding: 8,
        enableBlend: true,
        blendAmount: 10,
        indicatorPinchStrength: 0.65,
        selectedIconColor: brandYellow,
        selectedLabelColor: brandYellow,
        unselectedIconColor: const Color(0xFF64748B),
        unselectedLabelColor: const Color(0xFF64748B),
        // Explicitly set text style with NO text decoration/underline
        selectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          fontFamily: 'SF Pro Display',
          color: brandYellow,
          decoration: TextDecoration.none,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          fontFamily: 'SF Pro Display',
          color: Color(0xFF64748B),
          decoration: TextDecoration.none,
        ),
        indicatorColor: brandYellow.withValues(alpha: 0.28),
        settings: const LiquidGlassSettings(
          thickness: 28,
          blur: 16.0,
          glassColor: Color(0x33FFFFFF),
          refractiveIndex: 1.35,
          chromaticAberration: 0.02,
          lightIntensity: 0.70,
          saturation: 1.4,
          glowIntensity: 0.8,
          fresnelStrength: 1.3,
          specularSharpness: GlassSpecularSharpness.sharp,
        ),
        indicatorSettings: const LiquidGlassSettings(
          thickness: 34,
          blur: 20.0,
          glassColor: Color(0x4DFFFFFF),
          refractiveIndex: 1.40,
          chromaticAberration: 0.03,
          lightIntensity: 0.85,
          saturation: 1.5,
          glowIntensity: 0.9,
          fresnelStrength: 1.5,
          specularSharpness: GlassSpecularSharpness.sharp,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Header only shown on sub-tabs, since Home has its own rich greeting header matching the reference
            if (_currentIndex != 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _getTitleForIndex(_currentIndex),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'SF Pro Display',
                        color: brandNavy,
                        letterSpacing: -0.6,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    if (_currentIndex == 3)
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: _navigateToLogin,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: widget.isGuest
                                ? brandYellow
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(
                            widget.isGuest ? 'Log in' : 'Log out',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'SF Pro Display',
                              color: widget.isGuest
                                  ? brandNavy
                                  : const Color(0xFFDC2626),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

            // Main Content Area
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: [
                  // 1. Home Dashboard Screen
                  HomeDashboardView(
                    summary: _summary,
                    featuredSystems: _solarSystems,
                    isLoading: _isLoading,
                    errorMessage: _errorMessage,
                    userName: widget.userName,
                    onRefresh: _fetchData,
                    onExploreAll: () {
                      setState(() => _currentIndex = 1);
                    },
                    onNavigateTab: (tabIndex) {
                      setState(() => _currentIndex = tabIndex);
                    },
                  ),

                  // 2. Solar Listing Screen
                  SolarListingScreen(
                    solarSystems: _solarSystems,
                    isLoading: _isLoading,
                    errorMessage: _errorMessage,
                    onRefresh: _fetchData,
                  ),

                  // 3. Estimator Tab
                  _buildEstimatorView(),

                  // 4. Profile Tab
                  ProfileView(
                    isGuest: widget.isGuest,
                    userName: widget.userName,
                    onSignOutOrLogin: _navigateToLogin,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTitleForIndex(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Packages';
      case 2:
        return 'Calculator';
      case 3:
        return 'Profile';
      default:
        return 'Dashboard';
    }
  }

  Widget _buildEstimatorView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 110),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Rooftop Potential Calculator',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                fontFamily: 'SF Pro Display',
                color: brandNavy,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Average Monthly Power Bill',
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'SF Pro Display',
                    color: Color(0xFF64748B),
                    decoration: TextDecoration.none,
                  ),
                ),
                Text(
                  '₹ 5,500',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'SF Pro Display',
                    color: brandNavy,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Divider(color: Color(0xFFE2E8F0)),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Recommended Size',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'SF Pro Display',
                          color: Color(0xFF64748B),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '3.8 kW Plant',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'SF Pro Display',
                          color: brandNavy,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '25-Yr Net Savings',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'SF Pro Display',
                          color: Color(0xFF64748B),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '₹ 16.4 Lakhs',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'SF Pro Display',
                          color: Color(0xFF10B981),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                setState(() => _currentIndex = 1);
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: brandYellow,
                  borderRadius: BorderRadius.circular(24),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'View Matching Systems',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'SF Pro Display',
                    color: brandNavy,
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
}
