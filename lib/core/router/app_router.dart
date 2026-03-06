import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../providers/core_providers.dart';
import '../../features/onboarding/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/intro_screen.dart';
import '../../features/auth/presentation/screens/phone_login_screen.dart';
import '../../features/auth/presentation/screens/otp_verification_screen.dart';
import '../../features/onboarding/presentation/screens/permissions_screen.dart';
import '../../features/onboarding/presentation/screens/interests_screen.dart';
import '../../features/onboarding/presentation/screens/location_check_screen.dart';
import '../../features/home/presentation/screens/home_feed_screen.dart';
import '../../features/home/presentation/screens/map_view_screen.dart';
import '../../features/home/presentation/screens/search_screen.dart';
import '../../features/feed/presentation/screens/feed_screen.dart';
import '../../features/chat/presentation/screens/chat_list_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/create/presentation/screens/create_activity_shell.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
import '../../features/activity/presentation/screens/activity_detail_screen.dart';
import '../../shared/widgets/app_shell.dart';

part 'app_router.g.dart';

/// Route paths as constants to avoid typos
abstract class AppRoutes {
  static const String splash = '/';
  static const String intro = '/intro';
  static const String phoneLogin = '/auth/phone';
  static const String otpVerification = '/auth/otp';
  static const String locationPermission = '/onboarding/location-permission';
  static const String notificationPermission = '/onboarding/notification-permission';
  static const String interests = '/onboarding/interests';
  static const String locationCheck = '/onboarding/location-check';
  static const String home = '/home';
  static const String map = '/map';
  static const String search = '/search';
  static const String feed = '/feed';
  static const String chat = '/chat';
  static const String profile = '/profile';
  static const String create = '/create';
  static const String activity = '/activity/:id';
}

/// GoRouter provider with auth-aware redirects
@riverpod
GoRouter appRouter(Ref ref) {
  // Watch auth state for redirects
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,

    // Refresh router when auth state changes
    refreshListenable: _GoRouterRefreshStream(
      ref.read(authStateChangesProvider.stream),
    ),

    routes: [
      // Splash - initial loading screen
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding intro slides
      GoRoute(
        path: AppRoutes.intro,
        name: 'intro',
        builder: (context, state) => const IntroScreen(),
      ),

      // Auth routes
      GoRoute(
        path: AppRoutes.phoneLogin,
        name: 'phoneLogin',
        builder: (context, state) => const PhoneLoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.otpVerification,
        name: 'otpVerification',
        builder: (context, state) {
          final verificationId = state.extra as String? ?? '';
          final phoneNumber = state.uri.queryParameters['phone'] ?? '';
          return OtpVerificationScreen(
            verificationId: verificationId,
            phoneNumber: phoneNumber,
          );
        },
      ),

      // Onboarding permission screens
      GoRoute(
        path: AppRoutes.locationPermission,
        name: 'locationPermission',
        builder: (context, state) => const PermissionsScreen(
          type: PermissionType.location,
        ),
      ),
      GoRoute(
        path: AppRoutes.notificationPermission,
        name: 'notificationPermission',
        builder: (context, state) => const PermissionsScreen(
          type: PermissionType.notification,
        ),
      ),

      // Interests selection
      GoRoute(
        path: AppRoutes.interests,
        name: 'interests',
        builder: (context, state) => const InterestsScreen(),
      ),

      // Location check (Bangalore only)
      GoRoute(
        path: AppRoutes.locationCheck,
        name: 'locationCheck',
        builder: (context, state) => const LocationCheckScreen(),
      ),

      // ========== MAIN APP ROUTES WITH SHELL ==========
      // ShellRoute wraps main app screens with persistent bottom navigation
      ShellRoute(
        builder: (context, state, child) {
          return AppShell(
            currentPath: state.uri.path,
            child: child,
          );
        },
        routes: [
          // Home feed
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const HomeFeedScreen(),
            ),
          ),

          // Map view
          GoRoute(
            path: AppRoutes.map,
            name: 'map',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const MapViewScreen(),
            ),
          ),

          // Chat list
          GoRoute(
            path: AppRoutes.chat,
            name: 'chat',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ChatListScreen(),
            ),
          ),

          // Profile
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ProfileScreen(),
            ),
          ),
        ],
      ),

      // Search (outside shell for full screen experience)
      GoRoute(
        path: AppRoutes.search,
        name: 'search',
        builder: (context, state) => const SearchScreen(),
      ),

      // Create activity (modal flow, outside shell)
      GoRoute(
        path: AppRoutes.create,
        name: 'create',
        builder: (context, state) => const CreateActivityShell(),
      ),

      // Chat detail
      GoRoute(
        path: '/chat-detail/:id',
        name: 'chatDetail',
        builder: (context, state) {
           final id = state.pathParameters['id'] ?? '';
           final title = state.extra as String? ?? 'Chat';
           return ChatScreen(activityId: id, activityTitle: title);
        },
      ),

      // Activity detail
      GoRoute(
        path: AppRoutes.activity,
        name: 'activity',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ActivityDetailScreen(activityId: id);
        },
      ),
    ],

    // Error page
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(state.uri.toString()),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Helper class to convert a Stream into a Listenable for GoRouter refresh
class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final dynamic _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

