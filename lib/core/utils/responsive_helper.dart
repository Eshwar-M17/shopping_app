import 'package:flutter/material.dart';

/// A utility class for handling responsive design in the application.
class ResponsiveHelper {
  /// Screen breakpoints
  static const double mobileBreakpoint = 480;
  static const double tabletBreakpoint = 768;
  static const double desktopBreakpoint = 1024;

  /// Returns true if the current screen is a mobile device.
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < tabletBreakpoint;

  /// Returns true if the current screen is a tablet device.
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletBreakpoint &&
      MediaQuery.of(context).size.width < desktopBreakpoint;

  /// Returns true if the current screen is a desktop device.
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktopBreakpoint;

  /// Returns the appropriate value based on the screen size.
  static T getValueForScreenType<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context) && desktop != null) {
      return desktop;
    } else if (isTablet(context) && tablet != null) {
      return tablet;
    } else {
      return mobile;
    }
  }

  /// Returns the appropriate padding based on the screen size.
  static EdgeInsets getPaddingForScreenType(BuildContext context) {
    return getValueForScreenType(
      context: context,
      mobile: const EdgeInsets.all(16),
      tablet: const EdgeInsets.all(24),
      desktop: const EdgeInsets.all(32),
    );
  }

  /// Calculates the number of grid columns based on screen width.
  static int getGridColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return 2; // Small mobile devices
    } else if (width < tabletBreakpoint) {
      return 3; // Larger mobile devices
    } else if (width < desktopBreakpoint) {
      return 4; // Tablets
    } else {
      return 6; // Desktops and large tablets
    }
  }

  /// Returns the appropriate height for a banner based on screen size.
  static double getBannerHeight(BuildContext context) {
    return getValueForScreenType(
      context: context,
      mobile: 180,
      tablet: 220,
      desktop: 300,
    );
  }
}
