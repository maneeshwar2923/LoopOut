/// App-wide constants
class AppConstants {
  AppConstants._();

  // App info
  static const String appName = 'LoopOut';
  static const String appVersion = '1.0.0';

  // Bangalore coordinates (center)
  static const double bangaloreLatitude = 12.9716;
  static const double bangaloreLongitude = 77.5946;
  static const double bangaloreRadiusKm = 50.0; // ~50km radius for Bangalore metro

  // Onboarding
  static const int minInterestsRequired = 3;
  static const int otpResendDelaySeconds = 60;

  // Storage keys
  static const String keyOnboardingComplete = 'onboarding_complete';
  static const String keyUserInterests = 'user_interests';
  static const String keyLocationPermissionAsked = 'location_permission_asked';
  static const String keyNotificationPermissionAsked = 'notification_permission_asked';

  // Categories
  static const List<String> interestCategories = [
    'Sports',
    'Gaming',
    'Art',
    'Music',
    'Tech',
    'Food',
    'Fitness',
    'Movies',
    'Reading',
    'Travel',
    'Photography',
    'Dance',
  ];
}
