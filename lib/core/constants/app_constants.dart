/// A class containing app-wide constants to avoid hardcoded values
class AppConstants {
  // API constants
  static const int defaultPageSize = 10;
  static const int defaultInitialPage = 0;

  // UI constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double tinyPadding = 4.0;
  static const double largePadding = 24.0;

  static const double defaultBorderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double tinyBorderRadius = 4.0;
  static const double largeBorderRadius = 16.0;

  // Durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration shortSnackBarDuration = Duration(seconds: 2);
  static const Duration mediumSnackBarDuration = Duration(seconds: 4);

  // Cache durations
  static const Duration imageCacheDuration = Duration(days: 7);
  static const Duration apiCacheDuration = Duration(hours: 2);

  // Asset paths
  static const String logoAsset = 'assets/images/logo.png';
  static const String placeholderImage = 'assets/images/placeholder.png';

  // Error messages
  static const String defaultErrorMessage =
      'Something went wrong. Please try again later.';
  static const String connectionErrorMessage =
      'No internet connection. Please check your network.';
  static const String timeoutErrorMessage =
      'Connection timeout. Please try again later.';
}
