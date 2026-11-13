import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sankargrp_app/services/solar_api_service.dart';
import 'package:sankargrp_app/widgets/custom_button.dart';
import 'package:sankargrp_app/widgets/custom_text_field.dart';
import 'package:sankargrp_app/widgets/responsive.dart';
import 'package:sankargrp_app/screens/auth/widgets/mierae_brand_header.dart';
import 'package:sankargrp_app/screens/auth/widgets/auth_segmented_control.dart';
import 'package:sankargrp_app/screens/auth/widgets/guest_button.dart';
import 'package:sankargrp_app/screens/auth/widgets/eco_friendly_background.dart';
import 'package:sankargrp_app/screens/auth/otp/otp_verification_screen.dart';
import 'package:sankargrp_app/screens/dashboard/main_dashboard_screen.dart';

class AuthScreen extends StatefulWidget {
  final bool initialIsLogin;

  const AuthScreen({
    super.key,
    this.initialIsLogin = true,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late bool _isLoginSelected;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = false;
  String? _nameError;
  String? _phoneError;

  static const Color brandNavy = Color(0xFF0F2238);
  static const Color brandYellow = Color(0xFFFBBF24);

  @override
  void initState() {
    super.initState();
    _isLoginSelected = widget.initialIsLogin;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _requestOtp() async {
    HapticFeedback.lightImpact();
    final phone = _phoneController.text.trim();
    final name = _nameController.text.trim();

    bool hasError = false;

    if (!_isLoginSelected && name.isEmpty) {
      setState(() => _nameError = 'Please enter your full name');
      hasError = true;
    } else {
      setState(() => _nameError = null);
    }

    if (phone.isEmpty || phone.length < 10) {
      setState(() {
        _phoneError = 'Please enter a valid 10-digit mobile number';
      });
      hasError = true;
    } else {
      setState(() => _phoneError = null);
    }

    if (hasError) {
      HapticFeedback.vibrate();
      return;
    }

    setState(() => _isLoading = true);

    try {
      final res = await SolarApiService.sendOtp(
        phone,
        fullName: !_isLoginSelected ? name : null,
        isSignUp: !_isLoginSelected,
      );
      if (!mounted) return;
      setState(() => _isLoading = false);

      final dynamicOtp = res['otp']?.toString();

      Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (_) => OtpVerificationScreen(
            phone: phone,
            initialOtpHint: dynamicOtp,
          ),
        ),
      );
    } on SolarApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _phoneError = e.message;
      });
      HapticFeedback.vibrate();
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
                            const MieraeBrandHeader(
                              sunSize: 32,
                              mieraeFontSize: 18,
                              solarFontSize: 7,
                              solarLetterSpacing: 3,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981)
                                    .withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    Icons.eco,
                                    size: 13,
                                    color: Color(0xFF059669),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '100% Clean',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'SF Pro Display',
                                      color: Color(0xFF059669),
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // iOS Platter Card
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
                              color: const Color(0xFF0F2238)
                                  .withValues(alpha: 0.05),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // iOS Segmented Switch: Log In / Sign Up
                            AuthSegmentedControl(
                              isLoginSelected: _isLoginSelected,
                              onLoginTap: () {
                                if (!_isLoginSelected) {
                                  HapticFeedback.selectionClick();
                                  setState(() {
                                    _isLoginSelected = true;
                                    _nameError = null;
                                    _phoneError = null;
                                  });
                                }
                              },
                              onSignUpTap: () {
                                if (_isLoginSelected) {
                                  HapticFeedback.selectionClick();
                                  setState(() {
                                    _isLoginSelected = false;
                                    _nameError = null;
                                    _phoneError = null;
                                  });
                                }
                              },
                            ),
                            const SizedBox(height: 20),

                            Text(
                              _isLoginSelected ? 'Sign In with Mobile' : 'Create an Account',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'SF Pro Display',
                                letterSpacing: -0.5,
                                color: brandNavy,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _isLoginSelected
                                  ? 'We will send a 4-digit verification code to your phone'
                                  : 'Join Mierae Solar to manage installations & view clean energy stats',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'SF Pro Display',
                                color: Color(0xFF64748B),
                                height: 1.35,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            const SizedBox(height: 22),

                            // Name field (Only shown for Sign Up)
                            AnimatedCrossFade(
                              duration: const Duration(milliseconds: 220),
                              crossFadeState: !_isLoginSelected
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                              firstChild: Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: CustomTextField(
                                  controller: _nameController,
                                  placeholder: 'Full Name',
                                  prefixIcon: CupertinoIcons.person_fill,
                                  errorMessage: _nameError,
                                  onChanged: (val) {
                                    if (_nameError != null) {
                                      setState(() => _nameError = null);
                                    }
                                  },
                                ),
                              ),
                              secondChild: const SizedBox.shrink(),
                            ),

                            // Phone Input
                            CustomTextField(
                              controller: _phoneController,
                              placeholder: 'Mobile Number (10 digits)',
                              prefixIcon: CupertinoIcons.phone_fill,
                              keyboardType: TextInputType.phone,
                              errorMessage: _phoneError,
                              onChanged: (val) {
                                if (_phoneError != null) {
                                  setState(() => _phoneError = null);
                                }
                              },
                            ),
                            const SizedBox(height: 22),

                            // Get OTP Button
                            CustomButton(
                              label: _isLoginSelected ? 'Send Verification OTP' : 'Sign Up with OTP',
                              isLoading: _isLoading,
                              backgroundColor: brandYellow,
                              textColor: brandNavy,
                              borderRadius: 24,
                              height: 50,
                              icon: const Icon(
                                CupertinoIcons.arrow_right_circle_fill,
                                size: 18,
                                color: brandNavy,
                              ),
                              onPressed: _requestOtp,
                            ),
                            const SizedBox(height: 18),

                            // "or" Divider
                            Row(
                              children: [
                                const Expanded(
                                  child: Divider(
                                    color: Color(0xFFE2E8F0),
                                    thickness: 1,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Text(
                                    'or',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade400,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ),
                                const Expanded(
                                  child: Divider(
                                    color: Color(0xFFE2E8F0),
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Continue as guest Button
                            GuestButton(
                              borderRadius: 24,
                              onPressed: () {
                                HapticFeedback.selectionClick();
                                Navigator.of(context).pushReplacement(
                                  CupertinoPageRoute(
                                    builder: (_) => const MainDashboardScreen(
                                      isGuest: true,
                                      userName: 'Guest User',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Footer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.eco,
                            size: 13,
                            color: Color(0xFF10B981),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'by Sankar Group',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'SF Pro Display',
                              color: Colors.grey.shade600,
                              letterSpacing: -0.2,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
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
