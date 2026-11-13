import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IosProfileView extends StatefulWidget {
  final bool isGuest;
  final String userName;
  final VoidCallback onSignOutOrLogin;

  const IosProfileView({
    super.key,
    required this.isGuest,
    required this.userName,
    required this.onSignOutOrLogin,
  });

  @override
  State<IosProfileView> createState() => _IosProfileViewState();
}

class _IosProfileViewState extends State<IosProfileView> {
  bool _gridTelemetryNotifications = true;
  bool _peakTariffAlerts = true;
  bool _biometricUnlock = false;

  static const Color brandNavy = Color(0xFF0F172A);
  static const Color brandYellow = Color(0xFFFBBF24);
  static const Color iosCardBg = Colors.white;
  static const Color iosBorderColor = Color(0xFFE2E8F0);
  static const Color iosChevronColor = Color(0xFFC7C7CC);

  void _showComingSoon(String title) {
    HapticFeedback.lightImpact();
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(title),
        content: const Text(
          'This feature is actively synced with your DISCOM consumer number & solar net-meter.',
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _confirmSignOut() {
    HapticFeedback.mediumImpact();
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: const Text('Account Session'),
        message: Text(
          widget.isGuest
              ? 'Sign in with your mobile number to view personal solar installations & billing.'
              : 'Are you sure you want to sign out of Mierae Solar?',
        ),
        actions: [
          CupertinoActionSheetAction(
            isDestructiveAction: !widget.isGuest,
            onPressed: () {
              Navigator.pop(ctx);
              widget.onSignOutOrLogin();
            },
            child: Text(widget.isGuest ? 'Sign In / Register' : 'Sign Out'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. iOS Profile Hero Platter Card
          _buildHeroUserCard(),
          const SizedBox(height: 18),

          // 2. Solar Installation Stats Platter
          _buildSolarSummaryPills(),
          const SizedBox(height: 22),

          // 3. Section: Solar & Energy Services
          _buildSectionHeader('SOLAR & POWER METRICS'),
          _buildGroupedList([
            _IosListRow(
              icon: CupertinoIcons.sun_max_fill,
              iconBgColor: const Color(0xFFF59E0B),
              title: 'My Solar Plant',
              trailingText: '3.3 kWp Active',
              onTap: () => _showComingSoon('My Solar Plant'),
            ),
            _IosListRow(
              icon: CupertinoIcons.chart_pie_fill,
              iconBgColor: const Color(0xFF10B981),
              title: 'DISCOM Net-Metering Units',
              trailingText: '248 Units Exported',
              onTap: () => _showComingSoon('Net-Metering Units'),
            ),
            _IosListRow(
              icon: CupertinoIcons.doc_plaintext,
              iconBgColor: const Color(0xFF3B82F6),
              title: 'PM Surya Ghar Subsidy Claim',
              trailingText: 'Approved (₹78k)',
              onTap: () => _showComingSoon('Subsidy Claim'),
            ),
            _IosListRow(
              icon: CupertinoIcons.wrench_fill,
              iconBgColor: const Color(0xFF8B5CF6),
              title: 'Maintenance & Warranty',
              trailingText: '25-Yr Linear',
              onTap: () => _showComingSoon('Warranty Details'),
            ),
          ]),
          const SizedBox(height: 22),

          // 4. Section: Preferences & Toggles
          _buildSectionHeader('PREFERENCES & TELEMETRY'),
          _buildGroupedList([
            _IosListRow(
              icon: CupertinoIcons.bell_fill,
              iconBgColor: const Color(0xFFEF4444),
              title: 'Grid Telemetry Alerts',
              customTrailing: CupertinoSwitch(
                value: _gridTelemetryNotifications,
                activeTrackColor: const Color(0xFF10B981),
                onChanged: (val) {
                  HapticFeedback.selectionClick();
                  setState(() => _gridTelemetryNotifications = val);
                },
              ),
            ),
            _IosListRow(
              icon: CupertinoIcons.bolt_fill,
              iconBgColor: const Color(0xFFFBBF24),
              title: 'Peak Tariff Optimization',
              customTrailing: CupertinoSwitch(
                value: _peakTariffAlerts,
                activeTrackColor: const Color(0xFF10B981),
                onChanged: (val) {
                  HapticFeedback.selectionClick();
                  setState(() => _peakTariffAlerts = val);
                },
              ),
            ),
            _IosListRow(
              icon: CupertinoIcons.lock_shield_fill,
              iconBgColor: const Color(0xFF0F172A),
              title: 'Biometric App Lock',
              customTrailing: CupertinoSwitch(
                value: _biometricUnlock,
                activeTrackColor: const Color(0xFF10B981),
                onChanged: (val) {
                  HapticFeedback.selectionClick();
                  setState(() => _biometricUnlock = val);
                },
              ),
            ),
          ]),
          const SizedBox(height: 22),

          // 5. Section: Support & Legal
          _buildSectionHeader('SUPPORT & SANKAR GROUP'),
          _buildGroupedList([
            _IosListRow(
              icon: CupertinoIcons.phone_fill,
              iconBgColor: const Color(0xFF10B981),
              title: '24/7 Solar Engineer Support',
              trailingText: 'Call Dispatch',
              onTap: () => _showComingSoon('Engineer Helpline'),
            ),
            _IosListRow(
              icon: CupertinoIcons.chat_bubble_2_fill,
              iconBgColor: const Color(0xFF0284C7),
              title: 'WhatsApp Engineering Desk',
              onTap: () => _showComingSoon('WhatsApp Chat'),
            ),
            _IosListRow(
              icon: CupertinoIcons.shield_fill,
              iconBgColor: const Color(0xFF64748B),
              title: 'Privacy Policy & Terms',
              onTap: () => _showComingSoon('Privacy & Terms'),
            ),
          ]),
          const SizedBox(height: 22),

          // 6. Action Button (Sign Out or Sign In)
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: _confirmSignOut,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFEE2E2), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                widget.isGuest ? 'Sign In / Register' : 'Sign Out',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'SF Pro Display',
                  color: widget.isGuest
                      ? const Color(0xFF0F172A)
                      : const Color(0xFFDC2626),
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // App Version Footer
          Center(
            child: Column(
              children: [
                const Text(
                  'Mierae Solar v2.4.0 (Build 128)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'SF Pro Display',
                    color: Color(0xFF94A3B8),
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Crafted for Sankar Group • 100% Clean Energy',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'SF Pro Display',
                    color: const Color(0xFF94A3B8).withValues(alpha: 0.8),
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 1. iOS User Card ---
  Widget _buildHeroUserCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: iosBorderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Monogram or Avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F2238), Color(0xFF1E3A5F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F2238).withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              widget.userName.isNotEmpty
                  ? widget.userName[0].toUpperCase()
                  : 'A',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                fontFamily: 'SF Pro Display',
                color: brandYellow,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        widget.isGuest ? 'Guest Member' : widget.userName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'SF Pro Display',
                          color: brandNavy,
                          letterSpacing: -0.4,
                          decoration: TextDecoration.none,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Verified',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'SF Pro Display',
                          color: Color(0xFF059669),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  widget.isGuest
                      ? 'Tap below to link your solar meter'
                      : '+91 91363 93562 • Consumer #VSK-4892',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontFamily: 'SF Pro Display',
                    color: Color(0xFF64748B),
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            CupertinoIcons.chevron_right,
            color: iosChevronColor,
            size: 18,
          ),
        ],
      ),
    );
  }

  // --- 2. Solar Summary Pills ---
  Widget _buildSolarSummaryPills() {
    return Row(
      children: [
        _buildQuickMetricPill('Lifetime Gen', '14.2 MWh', CupertinoIcons.bolt_fill, const Color(0xFFF59E0B)),
        const SizedBox(width: 10),
        _buildQuickMetricPill('CO₂ Saved', '12.8 Tons', CupertinoIcons.leaf_arrow_circlepath, const Color(0xFF10B981)),
        const SizedBox(width: 10),
        _buildQuickMetricPill('Savings', '₹ 94,500', CupertinoIcons.money_dollar_circle_fill, const Color(0xFF0284C7)),
      ],
    );
  }

  Widget _buildQuickMetricPill(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: iosBorderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                fontFamily: 'SF Pro Display',
                color: brandNavy,
                decoration: TextDecoration.none,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                fontFamily: 'SF Pro Display',
                color: Color(0xFF64748B),
                decoration: TextDecoration.none,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // --- Helpers for iOS Grouped Inset Sections ---
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          fontFamily: 'SF Pro Display',
          color: Color(0xFF8E8E93),
          letterSpacing: 0.2,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }

  Widget _buildGroupedList(List<_IosListRow> rows) {
    return Container(
      decoration: BoxDecoration(
        color: iosCardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: iosBorderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(rows.length, (index) {
          final row = rows[index];
          final isLast = index == rows.length - 1;
          return Column(
            children: [
              GestureDetector(
                onTap: row.onTap,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      // Icon box
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: row.iconBgColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Icon(row.icon, size: 17, color: Colors.white),
                      ),
                      const SizedBox(width: 12),

                      // Title
                      Expanded(
                        child: Text(
                          row.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'SF Pro Display',
                            color: brandNavy,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),

                      // Trailing content
                      if (row.customTrailing != null)
                        row.customTrailing!
                      else ...[
                        if (row.trailingText != null)
                          Text(
                            row.trailingText!,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'SF Pro Display',
                              color: Color(0xFF8E8E93),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        const SizedBox(width: 6),
                        const Icon(
                          CupertinoIcons.chevron_right,
                          size: 15,
                          color: iosChevronColor,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (!isLast)
                const Padding(
                  padding: EdgeInsets.only(left: 58),
                  child: Divider(
                    height: 1,
                    thickness: 0.6,
                    color: Color(0xFFF1F5F9),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}

class _IosListRow {
  final IconData icon;
  final Color iconBgColor;
  final String title;
  final String? trailingText;
  final Widget? customTrailing;
  final VoidCallback? onTap;

  const _IosListRow({
    required this.icon,
    required this.iconBgColor,
    required this.title,
    this.trailingText,
    this.customTrailing,
    this.onTap,
  });
}
