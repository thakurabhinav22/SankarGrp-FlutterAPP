import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../auth/login/login_screen.dart';
import 'widgets/liquid_glass_nav_bar.dart';

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

  static const Color brandNavy = Color(0xFF0F2238);
  static const Color brandYellow = Color(0xFFF5A623);
  static const Color ecoGreen = Color(0xFF10B981);

  void _navigateToLogin() {
    Navigator.of(context).pushAndRemoveUntil(
      CupertinoPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  /// Guards order/booking actions: if guest, prompt login bottom sheet; otherwise proceed
  void _handleOrderOrBookingAction({required String actionTitle}) {
    if (widget.isGuest) {
      _showLoginRequiredSheet(actionTitle);
    } else {
      _showOrderSuccessDialog(actionTitle);
    }
  }

  void _showLoginRequiredSheet(String actionTitle) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: brandYellow.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_person_rounded,
                  color: brandYellow,
                  size: 30,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Sign In Required',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: brandNavy,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'To complete your $actionTitle and track your order in real-time, please log in or create your Mierae Solar account.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13.5,
                color: Color(0xFF64748B),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.of(ctx).pop();
                _navigateToLogin();
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: brandYellow,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: brandYellow.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Log In to Continue',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: brandNavy,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.of(ctx).pop(),
              child: Container(
                height: 46,
                alignment: Alignment.center,
                child: const Text(
                  'Explore More First',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showOrderSuccessDialog(String actionTitle) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text('$actionTitle Confirmed!'),
        content: Text(
          'Thank you, ${widget.userName}! Our solar engineering team will review your roof specifications and contact you.',
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Dynamically calculate bottom padding so content never collides with floating glass nav
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final totalBottomPadding = 66.0 + (bottomInset > 0 ? bottomInset + 16 : 28.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F5),
      body: Stack(
        children: [
          // Background organic subtle glow
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ecoGreen.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            bottom: 120,
            left: -50,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: brandYellow.withValues(alpha: 0.07),
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: IndexedStack(
              index: _currentIndex,
              children: [
                _buildHomeTab(totalBottomPadding),
                _buildSolarProductsTab(totalBottomPadding),
                _buildSavingsCalculatorTab(totalBottomPadding),
                _buildProfileTab(totalBottomPadding),
              ],
            ),
          ),

          // Floating iOS Liquid Glass Navbar anchored above system buttons
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: LiquidGlassNavBar(
              selectedIndex: _currentIndex,
              onItemSelected: (index) {
                setState(() => _currentIndex = index);
              },
              items: const [
                LiquidGlassNavBarItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: 'Home',
                ),
                LiquidGlassNavBarItem(
                  icon: Icons.shopping_bag_outlined,
                  activeIcon: Icons.shopping_bag_rounded,
                  label: 'Systems',
                ),
                LiquidGlassNavBarItem(
                  icon: Icons.calculate_outlined,
                  activeIcon: Icons.calculate_rounded,
                  label: 'Estimator',
                ),
                LiquidGlassNavBarItem(
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: 'Account',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB 1: Home Dashboard
  Widget _buildHomeTab(double bottomPadding) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20, 16, 20, bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: widget.isGuest
                              ? const Color(0xFF64748B).withValues(alpha: 0.12)
                              : ecoGreen.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              widget.isGuest ? Icons.person_outline : Icons.eco,
                              size: 12,
                              color: widget.isGuest
                                  ? const Color(0xFF475569)
                                  : ecoGreen,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.isGuest ? 'Guest User' : 'Verified Member',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: widget.isGuest
                                    ? const Color(0xFF475569)
                                    : ecoGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.isGuest
                        ? 'Welcome, Explorer'
                        : 'Hi, ${widget.userName}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: brandNavy,
                      letterSpacing: -0.4,
                    ),
                  ),
                ],
              ),
              if (widget.isGuest)
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: _navigateToLogin,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: brandNavy,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: brandNavy.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Log in',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                )
              else
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: brandYellow.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    color: brandNavy,
                    size: 22,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),

          // Real-time / Live Plant Status Banner
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F2238), Color(0xFF1E3A5F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: brandNavy.withValues(alpha: 0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.wb_sunny_rounded,
                          size: 16,
                          color: brandYellow,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'SOLAR GENERATION',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: brandYellow,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: ecoGreen.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.bolt, color: ecoGreen, size: 12),
                          SizedBox(width: 2),
                          Text(
                            'Active Peak',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: ecoGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.isGuest ? '3.8' : '4.6',
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text(
                        'kW',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: brandYellow,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text(
                          'Today\'s Yield',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                        Text(
                          '19.4 kWh',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: 0.76,
                    minHeight: 6,
                    backgroundColor: Colors.white.withValues(alpha: 0.15),
                    valueColor: const AlwaysStoppedAnimation<Color>(brandYellow),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Quick Metrics Row
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  icon: Icons.savings_outlined,
                  color: ecoGreen,
                  title: '₹ 2,480',
                  subtitle: 'This Month Saved',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  icon: Icons.co2_rounded,
                  color: const Color(0xFF3B82F6),
                  title: '380 kg',
                  subtitle: 'CO2 Offset',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  icon: Icons.solar_power_outlined,
                  color: brandYellow,
                  title: '98%',
                  subtitle: 'System Health',
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),

          // Order / Service Request Banner
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Solar Solutions & Orders',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: brandNavy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildActionTile(
            icon: Icons.roofing_rounded,
            title: 'Order Rooftop Installation',
            subtitle: 'Get residential solar plant installed with subsidy',
            buttonLabel: 'Order Now',
            onTap: () => _handleOrderOrBookingAction(
              actionTitle: 'Rooftop Solar Order',
            ),
          ),
          const SizedBox(height: 10),
          _buildActionTile(
            icon: Icons.battery_charging_full_rounded,
            title: 'Add Battery Storage (Lithium)',
            subtitle: 'Ensure 24/7 backup power for your home',
            buttonLabel: 'Order Kit',
            onTap: () => _handleOrderOrBookingAction(
              actionTitle: 'Battery Storage Order',
            ),
          ),
          const SizedBox(height: 10),
          _buildActionTile(
            icon: Icons.build_circle_outlined,
            title: 'Schedule Maintenance & Cleaning',
            subtitle: 'Professional solar panel inspection by Sankar Group',
            buttonLabel: 'Book Visit',
            onTap: () => _handleOrderOrBookingAction(
              actionTitle: 'Maintenance Booking',
            ),
          ),
        ],
      ),
    );
  }

  // TAB 2: Solar Products / Order Tab
  Widget _buildSolarProductsTab(double bottomPadding) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20, 16, 20, bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Solar Systems & Packages',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: brandNavy,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Select a package to order directly to your property',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 18),
          _buildProductCard(
            title: '3 kW Residential On-Grid Plant',
            price: '₹ 1,75,000',
            subsidy: 'Govt. Subsidy: ₹ 78,000 applied',
            desc:
                'Ideal for 2-3 BHK homes. Generates ~12-14 units/day, slashing electricity bills by 85%.',
            specs: ['10x Monocrystalline Panels', '3kW Smart Inverter', '25 Yrs Warranty'],
            onOrder: () => _handleOrderOrBookingAction(
              actionTitle: '3 kW Solar Plant Order',
            ),
          ),
          const SizedBox(height: 16),
          _buildProductCard(
            title: '5 kW Hybrid Solar Plant + Battery',
            price: '₹ 3,40,000',
            subsidy: 'Govt. Subsidy: ₹ 78,000 applied',
            desc:
                'High output system with lithium battery storage for continuous power round-the-clock.',
            specs: ['16x High-Efficiency Panels', '5kW Hybrid Inverter', '5kWh Lithium Battery'],
            onOrder: () => _handleOrderOrBookingAction(
              actionTitle: '5 kW Hybrid Plant Order',
            ),
          ),
          const SizedBox(height: 16),
          _buildProductCard(
            title: '10 kW Commercial Solar Solution',
            price: '₹ 5,80,000',
            subsidy: 'Industrial accelerated depreciation benefit',
            desc:
                'Engineered for offices, clinics, schools, and commercial establishments.',
            specs: ['Bi-facial High Yield Panels', '3-Phase Grid Inverter', 'IoT Cloud Monitoring'],
            onOrder: () => _handleOrderOrBookingAction(
              actionTitle: '10 kW Commercial Solar Order',
            ),
          ),
        ],
      ),
    );
  }

  // TAB 3: Solar Calculator Tab
  Widget _buildSavingsCalculatorTab(double bottomPadding) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20, 16, 20, bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Savings Estimator',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: brandNavy,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Estimate your solar plant size & lifetime cost savings',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: brandNavy.withValues(alpha: 0.05),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Monthly Electricity Bill',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: brandNavy,
                      ),
                    ),
                    Text(
                      '₹ 6,500 / mo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: brandYellow,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Recommended System',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '4.2 kW Plant',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: brandNavy,
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
                            '25-Year Net Savings',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '₹ 18.2 Lakhs',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: ecoGreen,
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
                  onPressed: () => _handleOrderOrBookingAction(
                    actionTitle: '4.2 kW Plant Quote Order',
                  ),
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: brandYellow,
                      borderRadius: BorderRadius.circular(23),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.isGuest
                          ? 'Order Proposal (Requires Login)'
                          : 'Confirm & Order Proposal',
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: brandNavy,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB 4: Profile Tab
  Widget _buildProfileTab(double bottomPadding) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20, 16, 20, bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'My Account',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: brandNavy,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: brandNavy.withValues(alpha: 0.05),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: widget.isGuest
                      ? const Color(0xFFE2E8F0)
                      : brandYellow.withValues(alpha: 0.2),
                  child: Icon(
                    widget.isGuest
                        ? Icons.person_outline_rounded
                        : Icons.person_rounded,
                    size: 40,
                    color: widget.isGuest
                        ? const Color(0xFF64748B)
                        : brandNavy,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.isGuest ? 'Guest User' : widget.userName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: brandNavy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.isGuest
                      ? 'Browsing mode • Orders require authentication'
                      : 'solar.customer@mierae.com',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 18),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: _navigateToLogin,
                  child: Container(
                    height: 46,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: widget.isGuest ? brandYellow : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(23),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.isGuest ? 'Log In / Register' : 'Log Out',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: widget.isGuest ? brandNavy : const Color(0xFFDC2626),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.eco, size: 14, color: ecoGreen),
                SizedBox(width: 5),
                Text(
                  'Mierae Solar by Sankar Group',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: brandNavy.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: brandNavy,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonLabel,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: brandNavy.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: brandNavy, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: brandNavy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: brandYellow,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                buttonLabel,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: brandNavy,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard({
    required String title,
    required String price,
    required String subsidy,
    required String desc,
    required List<String> specs,
    required VoidCallback onOrder,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: brandNavy.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: brandNavy,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                price,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: brandNavy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
            decoration: BoxDecoration(
              color: ecoGreen.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              subsidy,
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: ecoGreen,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: const TextStyle(
              fontSize: 12.5,
              color: Color(0xFF64748B),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: specs.map((s) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  s,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: brandNavy,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: onOrder,
            child: Container(
              height: 42,
              width: double.infinity,
              decoration: BoxDecoration(
                color: brandYellow,
                borderRadius: BorderRadius.circular(21),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_cart_checkout_rounded,
                    size: 17,
                    color: brandNavy,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    widget.isGuest ? 'Order (Requires Login)' : 'Order Package',
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: brandNavy,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
