// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activityRepositoryHash() =>
    r'aca6ac36a8a1808c25cdf876e48c34cfdd6ce453';

/// Activity repository provider
///
/// Copied from [activityRepository].
@ProviderFor(activityRepository)
final activityRepositoryProvider =
    AutoDisposeProvider<ActivityRepository>.internal(
      activityRepository,
      name: r'activityRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activityRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActivityRepositoryRef = AutoDisposeProviderRef<ActivityRepository>;
String _$trendingActivitiesHash() =>
    r'b8a95d0361faedcc12542422b74f3ceb99bce4b3';

/// Trending activities provider
///
/// Copied from [trendingActivities].
@ProviderFor(trendingActivities)
final trendingActivitiesProvider =
    AutoDisposeFutureProvider<List<ActivityModel>>.internal(
      trendingActivities,
      name: r'trendingActivitiesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$trendingActivitiesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TrendingActivitiesRef =
    AutoDisposeFutureProviderRef<List<ActivityModel>>;
String _$filteredActivitiesHash() =>
    r'693ff262675720c52e4d8e90df30452b2c1b64c0';

/// Filtered activities provider
///
/// Copied from [filteredActivities].
@ProviderFor(filteredActivities)
final filteredActivitiesProvider =
    AutoDisposeFutureProvider<List<ActivityModel>>.internal(
      filteredActivities,
      name: r'filteredActivitiesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$filteredActivitiesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredActivitiesRef =
    AutoDisposeFutureProviderRef<List<ActivityModel>>;
String _$joinedActivitiesHash() => r'f076209f82b193c28d9bc78c32cf686cd2c798ae';

/// Joined activities provider
///
/// Copied from [joinedActivities].
@ProviderFor(joinedActivities)
final joinedActivitiesProvider =
    AutoDisposeFutureProvider<List<ActivityModel>>.internal(
      joinedActivities,
      name: r'joinedActivitiesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$joinedActivitiesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef JoinedActivitiesRef = AutoDisposeFutureProviderRef<List<ActivityModel>>;
String _$activityFiltersStateHash() =>
    r'1e2d521492409d30998baf6203bb2ccc1842f043';

/// Activity filters state provider
///
/// Copied from [ActivityFiltersState].
@ProviderFor(ActivityFiltersState)
final activityFiltersStateProvider =
    AutoDisposeNotifierProvider<ActivityFiltersState, ActivityFilters>.internal(
      ActivityFiltersState.new,
      name: r'activityFiltersStateProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activityFiltersStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ActivityFiltersState = AutoDisposeNotifier<ActivityFilters>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
