// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatRepositoryHash() => r'83100ab83bfd07c8fee6adb16071887b14cebb49';

/// See also [chatRepository].
@ProviderFor(chatRepository)
final chatRepositoryProvider = AutoDisposeProvider<ChatRepository>.internal(
  chatRepository,
  name: r'chatRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chatRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChatRepositoryRef = AutoDisposeProviderRef<ChatRepository>;
String _$activityMessagesHash() => r'266be04b48d52bb236014b2433a0cc02629ae68a';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [activityMessages].
@ProviderFor(activityMessages)
const activityMessagesProvider = ActivityMessagesFamily();

/// See also [activityMessages].
class ActivityMessagesFamily extends Family<AsyncValue<List<Message>>> {
  /// See also [activityMessages].
  const ActivityMessagesFamily();

  /// See also [activityMessages].
  ActivityMessagesProvider call(String activityId) {
    return ActivityMessagesProvider(activityId);
  }

  @override
  ActivityMessagesProvider getProviderOverride(
    covariant ActivityMessagesProvider provider,
  ) {
    return call(provider.activityId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'activityMessagesProvider';
}

/// See also [activityMessages].
class ActivityMessagesProvider
    extends AutoDisposeStreamProvider<List<Message>> {
  /// See also [activityMessages].
  ActivityMessagesProvider(String activityId)
    : this._internal(
        (ref) => activityMessages(ref as ActivityMessagesRef, activityId),
        from: activityMessagesProvider,
        name: r'activityMessagesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$activityMessagesHash,
        dependencies: ActivityMessagesFamily._dependencies,
        allTransitiveDependencies:
            ActivityMessagesFamily._allTransitiveDependencies,
        activityId: activityId,
      );

  ActivityMessagesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.activityId,
  }) : super.internal();

  final String activityId;

  @override
  Override overrideWith(
    Stream<List<Message>> Function(ActivityMessagesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ActivityMessagesProvider._internal(
        (ref) => create(ref as ActivityMessagesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        activityId: activityId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Message>> createElement() {
    return _ActivityMessagesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ActivityMessagesProvider && other.activityId == activityId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, activityId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ActivityMessagesRef on AutoDisposeStreamProviderRef<List<Message>> {
  /// The parameter `activityId` of this provider.
  String get activityId;
}

class _ActivityMessagesProviderElement
    extends AutoDisposeStreamProviderElement<List<Message>>
    with ActivityMessagesRef {
  _ActivityMessagesProviderElement(super.provider);

  @override
  String get activityId => (origin as ActivityMessagesProvider).activityId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
