import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/user_model.dart';
import '../providers/core_providers.dart';

part 'user_repository.g.dart';

/// User repository for Firestore operations
class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> get _usersRef =>
      _firestore.collection('users');

  /// Get user by ID
  Future<UserModel?> getUser(String userId) async {
    final doc = await _usersRef.doc(userId).get();
    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc);
  }

  /// Get user stream by ID
  Stream<UserModel?> watchUser(String userId) {
    return _usersRef.doc(userId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc);
    });
  }

  /// Create or update user profile
  Future<void> saveUser(UserModel user) async {
    await _usersRef.doc(user.id).set(user.toFirestore(), SetOptions(merge: true));
  }

  /// Update user interests
  Future<void> updateInterests(String userId, List<String> interests) async {
    await _usersRef.doc(userId).update({'interests': interests});
  }

  /// Update user location
  Future<void> updateLocation(String userId, GeoPoint location) async {
    await _usersRef.doc(userId).update({'location': location});
  }

  /// Update FCM token
  Future<void> updateFcmToken(String userId, String token) async {
    await _usersRef.doc(userId).update({'fcmToken': token});
  }

  /// Check if user exists
  Future<bool> userExists(String userId) async {
    final doc = await _usersRef.doc(userId).get();
    return doc.exists;
  }

  /// Create initial user profile after signup
  Future<UserModel> createInitialProfile({
    required String userId,
    required List<String> interests,
  }) async {
    final user = UserModel(
      id: userId,
      interests: interests,
      createdAt: DateTime.now(),
    );
    await saveUser(user);
    return user;
  }
}

/// User repository provider
@riverpod
UserRepository userRepository(Ref ref) {
  return UserRepository(FirebaseFirestore.instance);
}

/// Current user profile provider
@riverpod
Stream<UserModel?> currentUserProfile(Ref ref) {
  final authState = ref.watch(authStateChangesProvider);
  return authState.when(
    data: (user) {
      if (user == null) return Stream.value(null);
      return ref.watch(userRepositoryProvider).watchUser(user.uid);
    },
    loading: () => Stream.value(null),
    error: (_, __) => Stream.value(null),
  );
}
