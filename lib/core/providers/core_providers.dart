import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../firebase_options.dart';

part 'core_providers.g.dart';

/// Firebase initialization provider
/// This should be awaited in main() before runApp
@Riverpod(keepAlive: true)
Future<FirebaseApp> firebaseApp(Ref ref) async {
  return Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

/// Firebase Auth instance provider
@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(Ref ref) {
  return FirebaseAuth.instance;
}

/// Auth state stream - single source of truth for authentication
/// CRITICAL: Do not start Firestore listeners until this emits a non-null user
@Riverpod(keepAlive: true)
Stream<User?> authStateChanges(Ref ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.authStateChanges();
}

/// Current user provider - derived from auth state stream
@riverpod
User? currentUser(Ref ref) {
  final authState = ref.watch(authStateChangesProvider);
  return authState.whenData((user) => user).valueOrNull;
}

/// Is authenticated provider
@riverpod
bool isAuthenticated(Ref ref) {
  return ref.watch(currentUserProvider) != null;
}

/// Sign out provider
@riverpod
Future<void> signOut(Ref ref) {
  return ref.watch(firebaseAuthProvider).signOut();
}

/// SharedPreferences provider
@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(Ref ref) async {
  return SharedPreferences.getInstance();
}

/// Onboarding complete status
@riverpod
Future<bool> isOnboardingComplete(Ref ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return prefs.getBool('onboarding_complete') ?? false;
}
