import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../auth/login/login_screen.dart';
import 'widgets/sun_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const Color sunYellow = Color(0xFFFBBF24); // Yellow sun
  static const Color brandBlack = Color(0xFF000000); // Black text

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: const Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SizedBox.expand(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Yellow Sun Logo
                        SunLogo(
                          size: 110,
                          color: sunYellow,
                        ),
                        SizedBox(height: 28),

                        // 'mierae'
                        Text(
                          'mierae',
                          style: TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.2,
                            color: brandBlack,
                            height: 1.0,
                          ),
                        ),
                        SizedBox(height: 10),

                        // 'S O L A R'
                        Padding(
                          padding: EdgeInsets.only(left: 6.0),
                          child: Text(
                            'S O L A R',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 6.0,
                              color: brandBlack,
                              height: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 'by Sankar Group' Footer
                Padding(
                  padding: EdgeInsets.only(bottom: 28.0),
                  child: Text(
                    'by Sankar Group',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: brandBlack,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
