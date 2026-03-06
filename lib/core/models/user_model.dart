import 'package:cloud_firestore/cloud_firestore.dart';

/// User profile model
class UserModel {
  final String id;
  final String? displayName;
  final String? photoUrl;
  final String? bio;
  final List<String> interests;
  final GeoPoint? location;
  final String? fcmToken;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    this.displayName,
    this.photoUrl,
    this.bio,
    this.interests = const [],
    this.location,
    this.fcmToken,
    required this.createdAt,
  });

  /// Create from Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return UserModel(
      id: doc.id,
      displayName: data['displayName'] as String?,
      photoUrl: data['photoUrl'] as String?,
      bio: data['bio'] as String?,
      interests: List<String>.from(data['interests'] ?? []),
      location: data['location'] as GeoPoint?,
      fcmToken: data['fcmToken'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Convert to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'displayName': displayName,
      'photoUrl': photoUrl,
      'bio': bio,
      'interests': interests,
      'location': location,
      'fcmToken': fcmToken,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Copy with new values
  UserModel copyWith({
    String? id,
    String? displayName,
    String? photoUrl,
    String? bio,
    List<String>? interests,
    GeoPoint? location,
    String? fcmToken,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      interests: interests ?? this.interests,
      location: location ?? this.location,
      fcmToken: fcmToken ?? this.fcmToken,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
