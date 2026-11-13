import 'package:flutter/cupertino.dart';

class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 650;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 650 &&
      MediaQuery.sizeOf(context).width < 1024;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 1024;

  static double maxCardWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width > 900) return 440;
    if (width > 600) return 420;
    return width - 36;
  }
}
