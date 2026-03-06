import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/activity_model.dart';
import '../providers/core_providers.dart';
import '../data/sample_activities.dart';
import '../../shared/constants/app_constants.dart';

part 'activity_repository.g.dart';

/// Activity filter options
class ActivityFilters {
  final String? category;
  final DateTime? fromDate;
  final DateTime? toDate;
  final double? maxDistance; // in km
  final GeoPoint? userLocation;

  const ActivityFilters({
    this.category,
    this.fromDate,
    this.toDate,
    this.maxDistance,
    this.userLocation,
  });

  ActivityFilters copyWith({
    String? category,
    DateTime? fromDate,
    DateTime? toDate,
    double? maxDistance,
    GeoPoint? userLocation,
  }) {
    return ActivityFilters(
      category: category ?? this.category,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      maxDistance: maxDistance ?? this.maxDistance,
      userLocation: userLocation ?? this.userLocation,
    );
  }
}

/// Activity repository for Firestore operations
class ActivityRepository {
  final FirebaseFirestore _firestore;

  ActivityRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> get _activitiesRef =>
      _firestore.collection('activities');

  /// Get activity by ID
  Future<ActivityModel?> getActivity(String activityId) async {
    final doc = await _activitiesRef.doc(activityId).get();
    if (!doc.exists) return null;
    return ActivityModel.fromFirestore(doc);
  }

  /// Watch activity by ID
  Stream<ActivityModel?> watchActivity(String activityId) {
    return _activitiesRef.doc(activityId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return ActivityModel.fromFirestore(doc);
    });
  }

  /// Get paginated activities with filters
  Future<List<ActivityModel>> getActivities({
    ActivityFilters? filters,
    DocumentSnapshot? lastDoc,
    int limit = 20,
  }) async {
    Query<Map<String, dynamic>> query = _activitiesRef
        .where('status', isEqualTo: 'active')
        .where('dateTime', isGreaterThan: Timestamp.fromDate(DateTime.now()))
        .orderBy('dateTime');

    // Apply category filter
    if (filters?.category != null && filters!.category!.isNotEmpty) {
      query = query.where('category', isEqualTo: filters.category);
    }

    // Apply date range filter
    if (filters?.fromDate != null) {
      query = query.where('dateTime',
          isGreaterThanOrEqualTo: Timestamp.fromDate(filters!.fromDate!));
    }
    if (filters?.toDate != null) {
      query = query.where('dateTime',
          isLessThanOrEqualTo: Timestamp.fromDate(filters!.toDate!));
    }

    // Apply pagination
    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    query = query.limit(limit);

    final snapshot = await query.get();
    return snapshot.docs.map(ActivityModel.fromFirestore).toList();
  }

  /// Get trending activities (most participants)
  Future<List<ActivityModel>> getTrendingActivities({int limit = 10}) async {
    final snapshot = await _activitiesRef
        .where('status', isEqualTo: 'active')
        .where('dateTime', isGreaterThan: Timestamp.fromDate(DateTime.now()))
        .orderBy('dateTime')
        .limit(limit)
        .get();

    return snapshot.docs.map(ActivityModel.fromFirestore).toList();
  }

  /// Get activities by category
  Future<List<ActivityModel>> getActivitiesByCategory(String category,
      {int limit = 20}) async {
    final snapshot = await _activitiesRef
        .where('status', isEqualTo: 'active')
        .where('category', isEqualTo: category)
        .where('dateTime', isGreaterThan: Timestamp.fromDate(DateTime.now()))
        .orderBy('dateTime')
        .limit(limit)
        .get();

    return snapshot.docs.map(ActivityModel.fromFirestore).toList();
  }

  /// Get activities hosted by user
  Future<List<ActivityModel>> getHostedActivities(String userId) async {
    final snapshot = await _activitiesRef
        .where('hostId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map(ActivityModel.fromFirestore).toList();
  }

  /// Get activities user has joined
  Future<List<ActivityModel>> getJoinedActivities(String userId) async {
    final snapshot = await _activitiesRef
        .where('participants', arrayContains: userId)
        .orderBy('dateTime')
        .get();

    return snapshot.docs.map(ActivityModel.fromFirestore).toList();
  }

  /// Create new activity
  Future<ActivityModel> createActivity(ActivityModel activity) async {
    final docRef = _activitiesRef.doc();
    final newActivity = activity.copyWith(id: docRef.id);
    await docRef.set(newActivity.toFirestore());
    return newActivity;
  }

  /// Update activity
  Future<void> updateActivity(ActivityModel activity) async {
    await _activitiesRef.doc(activity.id).update(activity.toFirestore());
  }

  /// Join activity
  Future<void> joinActivity(String activityId, String userId) async {
    await _activitiesRef.doc(activityId).update({
      'participants': FieldValue.arrayUnion([userId]),
    });
  }

  /// Leave activity
  Future<void> leaveActivity(String activityId, String userId) async {
    await _activitiesRef.doc(activityId).update({
      'participants': FieldValue.arrayRemove([userId]),
    });
  }

  /// Cancel activity
  Future<void> cancelActivity(String activityId) async {
    await _activitiesRef.doc(activityId).update({
      'status': ActivityStatus.cancelled.value,
    });
  }

  /// Search activities by title
  Future<List<ActivityModel>> searchActivities(String query,
      {int limit = 20}) async {
    // Simple prefix search - for production use Algolia or similar
    final lowercaseQuery = query.toLowerCase();
    final snapshot = await _activitiesRef
        .where('status', isEqualTo: 'active')
        .where('dateTime', isGreaterThan: Timestamp.fromDate(DateTime.now()))
        .orderBy('dateTime')
        .limit(100) // Get more for client-side filtering
        .get();

    final results = snapshot.docs
        .map(ActivityModel.fromFirestore)
        .where((a) =>
            a.title.toLowerCase().contains(lowercaseQuery) ||
            a.description.toLowerCase().contains(lowercaseQuery) ||
            a.category.toLowerCase().contains(lowercaseQuery))
        .take(limit)
        .toList();

    return results;
  }
}

/// Activity repository provider
@riverpod
ActivityRepository activityRepository(Ref ref) {
  return ActivityRepository(FirebaseFirestore.instance);
}

/// Activity filters state provider
@riverpod
class ActivityFiltersState extends _$ActivityFiltersState {
  @override
  ActivityFilters build() => const ActivityFilters();

  void setCategory(String? category) {
    state = state.copyWith(category: category);
  }

  void setDateRange(DateTime? from, DateTime? to) {
    state = ActivityFilters(
      category: state.category,
      fromDate: from,
      toDate: to,
      maxDistance: state.maxDistance,
      userLocation: state.userLocation,
    );
  }

  void setTimeFilter(String filter) {
    final now = DateTime.now();
    DateTime? from;
    DateTime? to;

    switch (filter) {
      case 'today':
        from = DateTime(now.year, now.month, now.day);
        to = from.add(const Duration(days: 1));
        break;
      case 'weekend':
        // Find next Saturday
        final daysUntilSaturday = (DateTime.saturday - now.weekday) % 7;
        from = DateTime(now.year, now.month, now.day)
            .add(Duration(days: daysUntilSaturday));
        to = from.add(const Duration(days: 2)); // Saturday + Sunday
        break;
      case 'week':
        from = DateTime(now.year, now.month, now.day);
        to = from.add(const Duration(days: 7));
        break;
      default:
        from = null;
        to = null;
    }

    setDateRange(from, to);
  }

  void clearFilters() {
    state = const ActivityFilters();
  }
}

/// Trending activities provider
@riverpod
Future<List<ActivityModel>> trendingActivities(Ref ref) async {
  final repo = ref.watch(activityRepositoryProvider);
  final results = await repo.getTrendingActivities();
  // Fallback to sample data if Firestore is empty
  if (results.isEmpty) {
    return SampleActivities.getTrending();
  }
  return results;
}

/// Filtered activities provider
@riverpod
Future<List<ActivityModel>> filteredActivities(Ref ref) async {
  final repo = ref.watch(activityRepositoryProvider);
  final filters = ref.watch(activityFiltersStateProvider);
  final results = await repo.getActivities(filters: filters);
  // Fallback to sample data if Firestore is empty
  if (results.isEmpty) {
    return SampleActivities.getAll();
  }
  return results;
}

/// Joined activities provider
@riverpod
Future<List<ActivityModel>> joinedActivities(Ref ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  final repo = ref.watch(activityRepositoryProvider);
  return repo.getJoinedActivities(user.uid);
}

