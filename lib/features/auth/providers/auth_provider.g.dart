// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$signOutHash() => r'9d10a6fdeda07c242e7fe31b7b5d6b45633c5568';

/// Sign out provider
///
/// Copied from [signOut].
@ProviderFor(signOut)
final signOutProvider = AutoDisposeFutureProvider<void>.internal(
  signOut,
  name: r'signOutProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signOutHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SignOutRef = AutoDisposeFutureProviderRef<void>;
String _$phoneAuthHash() => r'2140adddb74d04d398a77766ba5f8dd99f685607';

/// Phone authentication provider
///
/// Copied from [PhoneAuth].
@ProviderFor(PhoneAuth)
final phoneAuthProvider =
    AutoDisposeNotifierProvider<PhoneAuth, PhoneAuthState>.internal(
      PhoneAuth.new,
      name: r'phoneAuthProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$phoneAuthHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PhoneAuth = AutoDisposeNotifier<PhoneAuthState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
