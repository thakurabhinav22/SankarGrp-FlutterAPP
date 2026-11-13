import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sankargrp_app/services/solar_api_service.dart';
import 'package:sankargrp_app/widgets/custom_button.dart';
import 'package:sankargrp_app/widgets/responsive.dart';
import 'package:sankargrp_app/screens/auth/widgets/mierae_brand_header.dart';
import 'package:sankargrp_app/screens/auth/widgets/eco_friendly_background.dart';
import 'package:sankargrp_app/screens/dashboard/main_dashboard_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phone;
  final String? initialOtpHint;

  const OtpVerificationScreen({
    super.key,
    required this.phone,
    this.initialOtpHint,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  bool _isLoading = false;
  String? _errorMessage;
  String? _hintCode;
  bool _resending = false;

  static const Color brandNavy = Color(0xFF0F2238);
  static const Color brandYellow = Color(0xFFFBBF24);

  @override
  void initState() {
    super.initState();
    _hintCode = widget.initialOtpHint;
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _enteredOtp => _controllers.map((c) => c.text).join();

  void _verifyOtp() async {
    HapticFeedback.lightImpact();
    final otp = _enteredOtp.trim();
    if (otp.length < 4) {
      setState(() => _errorMessage = 'Please enter complete 4-digit code');
      HapticFeedback.vibrate();
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final res = await SolarApiService.verifyOtp(widget.phone, otp);
      if (!mounted) return;
      setState(() => _isLoading = false);
      HapticFeedback.mediumImpact();

      final userObj = res['user'] as Map<String, dynamic>?;
      final displayName = userObj?['name']?.toString() ?? 'Solar Member';

      Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(
          builder: (_) => MainDashboardScreen(
            isGuest: false,
            userName: displayName,
          ),
        ),
        (route) => false,
      );
    } on SolarApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.message;
      });
      HapticFeedback.vibrate();
    }
  }

  void _resendOtp() async {
    HapticFeedback.selectionClick();
    setState(() => _resending = true);
    try {
      final res = await SolarApiService.sendOtp(widget.phone);
      if (!mounted) return;
      setState(() {
        _resending = false;
        _errorMessage = null;
        _hintCode = res['otp']?.toString();
      });
      HapticFeedback.lightImpact();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _resending = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = Responsive.maxCardWidth(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F7), // Neutral iOS secondary background
      body: Stack(
        children: [
          const Positioned.fill(
            child: CustomPaint(
              painter: EcoFriendlyBackgroundPainter(),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: cardWidth),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Row
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(CupertinoIcons.back,
                                      color: brandNavy, size: 22),
                                  SizedBox(width: 4),
                                  Text(
                                    'Edit Number',
                                    style: TextStyle(
                                      color: brandNavy,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'SF Pro Display',
                                      fontSize: 14,
                                      letterSpacing: -0.2,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const MieraeBrandHeader(
                              sunSize: 28,
                              mieraeFontSize: 16,
                              solarFontSize: 6.5,
                              solarLetterSpacing: 2.8,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // iOS Frosted Platter Card
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: const Color(0xFFE2E8F0),
                            width: 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0F2238).withValues(alpha: 0.05),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Enter Verification Code',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'SF Pro Display',
                                color: brandNavy,
                                letterSpacing: -0.5,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'We sent a 4-digit code to +91 ${widget.phone}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontFamily: 'SF Pro Display',
                                color: Color(0xFF64748B),
                                decoration: TextDecoration.none,
                              ),
                            ),

                            // If dynamic OTP hint is provided by the server
                            if (_hintCode != null) ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      CupertinoIcons.device_phone_portrait,
                                      size: 16,
                                      color: Color(0xFF059669),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'SMS Code Received: $_hintCode',
                                        style: const TextStyle(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'SF Pro Display',
                                          color: Color(0xFF059669),
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                    CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size.zero,
                                      onPressed: () {
                                        for (int i = 0; i < 4; i++) {
                                          if (i < _hintCode!.length) {
                                            _controllers[i].text = _hintCode![i];
                                          }
                                        }
                                        _verifyOtp();
                                      },
                                      child: const Text(
                                        'Auto-fill',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF059669),
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],

                            const SizedBox(height: 24),

                            // 4 iOS PIN Boxes
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(4, (index) {
                                return SizedBox(
                                  width: 56,
                                  height: 58,
                                  child: CupertinoTextField(
                                    controller: _controllers[index],
                                    focusNode: _focusNodes[index],
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    maxLength: 1,
                                    cursorColor: brandYellow,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                      fontFamily: 'SF Pro Display',
                                      color: brandNavy,
                                      decoration: TextDecoration.none,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF8FAFC),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: _focusNodes[index].hasFocus
                                            ? brandYellow
                                            : const Color(0xFFCBD5E1),
                                        width: _focusNodes[index].hasFocus ? 2.0 : 1.2,
                                      ),
                                    ),
                                    onChanged: (value) {
                                      if (value.isNotEmpty && index < 3) {
                                        _focusNodes[index + 1].requestFocus();
                                      } else if (value.isEmpty && index > 0) {
                                        _focusNodes[index - 1].requestFocus();
                                      }
                                      if (_enteredOtp.length == 4) {
                                        _verifyOtp();
                                      }
                                    },
                                  ),
                                );
                              }),
                            ),

                            if (_errorMessage != null) ...[
                              const SizedBox(height: 14),
                              Text(
                                _errorMessage!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  color: Color(0xFFDC2626),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'SF Pro Display',
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],

                            const SizedBox(height: 24),

                            CustomButton(
                              label: 'Verify & Sign In',
                              isLoading: _isLoading,
                              backgroundColor: brandYellow,
                              textColor: brandNavy,
                              borderRadius: 24,
                              height: 50,
                              icon: const Icon(
                                CupertinoIcons.checkmark_shield_fill,
                                size: 18,
                                color: brandNavy,
                              ),
                              onPressed: _verifyOtp,
                            ),

                            const SizedBox(height: 16),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Didn't receive the SMS? ",
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontFamily: 'SF Pro Display',
                                    color: Color(0xFF64748B),
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: _resending ? null : _resendOtp,
                                  child: Text(
                                    _resending ? 'Sending...' : 'Resend Code',
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'SF Pro Display',
                                      color: brandNavy,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
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
