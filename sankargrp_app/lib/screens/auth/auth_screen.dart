import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sankargrp_app/widgets/custom_button.dart';
import 'package:sankargrp_app/widgets/custom_text_field.dart';
import 'package:sankargrp_app/widgets/responsive.dart';
import 'package:sankargrp_app/screens/auth/widgets/mierae_brand_header.dart';
import 'package:sankargrp_app/screens/auth/widgets/auth_segmented_control.dart';
import 'package:sankargrp_app/screens/auth/widgets/guest_button.dart';
import 'package:sankargrp_app/screens/auth/widgets/eco_friendly_background.dart';
import 'package:sankargrp_app/screens/guest/guest_dashboard_screen.dart';

class AuthScreen extends StatefulWidget {
  final bool initialIsLogin;

  const AuthScreen({
    super.key,
    this.initialIsLogin = false,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late bool _isLogin;

  // Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _phoneError;
  bool _isLoading = false;

  static const Color brandNavy = Color(0xFF0F2238);
  static const Color brandYellow = Color(0xFFF5A623);

  @override
  void initState() {
    super.initState();
    _isLogin = widget.initialIsLogin;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _switchTab(bool isLogin) {
    if (_isLogin == isLogin) return;
    setState(() {
      _isLogin = isLogin;
      _phoneError = null;
    });
  }

  void _handleSubmit() async {
    if (!_isLogin) {
      final phone = _phoneController.text.trim();
      if (phone.isEmpty || phone.length < 10) {
        setState(() {
          _phoneError = 'Please enter a valid mobile number';
        });
        return;
      } else {
        setState(() {
          _phoneError = null;
        });
      }
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isLoading = false);

    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(_isLogin ? 'Welcome Back' : 'Account Created'),
        content: Text(_isLogin
            ? 'Signed in successfully!'
            : 'Welcome to Mierae Solar!'),
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
    final cardWidth = Responsive.maxCardWidth(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F5),
      body: Stack(
        children: [
          // Eco background painter
          const Positioned.fill(
            child: CustomPaint(
              painter: EcoFriendlyBackgroundPainter(),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                                color: const Color(0xFF10B981).withValues(alpha: 0.12),
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
                                      color: Color(0xFF059669),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Centered Elevated Card
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0F2238).withValues(alpha: 0.06),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Animated Title & Subtitle
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              transitionBuilder: (child, animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0, 0.08),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  ),
                                );
                              },
                              child: Column(
                                key: ValueKey<bool>(_isLogin),
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    _isLogin
                                        ? 'Welcome back'
                                        : 'Create your account',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.4,
                                      color: brandNavy,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _isLogin
                                        ? 'Log in to manage your solar journey'
                                        : 'Start your solar journey today',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Segmented Switch
                            AuthSegmentedControl(
                              isLoginSelected: _isLogin,
                              onLoginTap: () => _switchTab(true),
                              onSignUpTap: () => _switchTab(false),
                            ),
                            const SizedBox(height: 16),

                            // Form Fields with AnimatedSwitcher for smooth transition
                            AnimatedSize(
                              duration: const Duration(milliseconds: 280),
                              curve: Curves.easeInOutCubic,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 240),
                                switchInCurve: Curves.easeIn,
                                switchOutCurve: Curves.easeOut,
                                transitionBuilder: (child, animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                                child: _isLogin
                                    ? _buildLoginForm()
                                    : _buildSignUpForm(),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Primary Action Button
                            CustomButton(
                              label: _isLogin ? 'Log in' : 'Sign up',
                              isLoading: _isLoading,
                              backgroundColor: brandYellow,
                              textColor: brandNavy,
                              borderRadius: 24,
                              height: 46,
                              icon: const Icon(
                                Icons.solar_power_outlined,
                                size: 18,
                                color: brandNavy,
                              ),
                              onPressed: _handleSubmit,
                            ),
                            const SizedBox(height: 14),

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
                            const SizedBox(height: 14),

                            // Continue as guest Button
                            GuestButton(
                              borderRadius: 24,
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  CupertinoPageRoute(
                                    builder: (_) =>
                                        const GuestDashboardScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

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
                              color: Colors.grey.shade600,
                              letterSpacing: -0.2,
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

  Widget _buildSignUpForm() {
    return Column(
      key: const ValueKey('signup_form'),
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextField(
          controller: _nameController,
          placeholder: 'Full name',
          prefixIcon: CupertinoIcons.person,
          keyboardType: TextInputType.name,
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: _phoneController,
          placeholder: 'Phone number',
          prefixIcon: CupertinoIcons.phone,
          keyboardType: TextInputType.phone,
          errorMessage: _phoneError,
          onChanged: (val) {
            if (_phoneError != null) {
              setState(() => _phoneError = null);
            }
          },
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: _emailController,
          placeholder: 'Email address',
          prefixIcon: CupertinoIcons.mail,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: _passwordController,
          placeholder: 'Password',
          prefixIcon: CupertinoIcons.lock,
          isPassword: true,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      key: const ValueKey('login_form'),
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextField(
          controller: _emailController,
          placeholder: 'Email address',
          prefixIcon: CupertinoIcons.mail,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: _passwordController,
          placeholder: 'Password',
          prefixIcon: CupertinoIcons.lock,
          isPassword: true,
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerRight,
          child: CupertinoButton(
            padding: const EdgeInsets.symmetric(vertical: 4),
            minimumSize: Size.zero,
            onPressed: () {},
            child: const Text(
              'Forgot password?',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F2238),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
