import 'package:cloud_firestore/cloud_firestore.dart';

/// Activity status enum
enum ActivityStatus {
  active,
  completed,
  cancelled;

  String get value {
    switch (this) {
      case ActivityStatus.active:
        return 'active';
      case ActivityStatus.completed:
        return 'completed';
      case ActivityStatus.cancelled:
        return 'cancelled';
    }
  }

  static ActivityStatus fromString(String? value) {
    switch (value) {
      case 'completed':
        return ActivityStatus.completed;
      case 'cancelled':
        return ActivityStatus.cancelled;
      default:
        return ActivityStatus.active;
    }
  }
}

/// Activity model
class ActivityModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String hostId;
  final String? hostName;
  final String? hostPhotoUrl;
  final GeoPoint location;
  final String locationName;
  final DateTime dateTime;
  final int capacity;
  final double price;
  final List<String> participants;
  final String? imageUrl;
  final ActivityStatus status;
  final DateTime createdAt;

  const ActivityModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.hostId,
    this.hostName,
    this.hostPhotoUrl,
    required this.location,
    required this.locationName,
    required this.dateTime,
    required this.capacity,
    this.price = 0,
    this.participants = const [],
    this.imageUrl,
    this.status = ActivityStatus.active,
    required this.createdAt,
  });

  /// Check if activity is free
  bool get isFree => price <= 0;

  /// Check if activity is full
  bool get isFull => participants.length >= capacity;

  /// Available spots
  int get availableSpots => capacity - participants.length;

  /// Check if user is participant
  bool isParticipant(String userId) => participants.contains(userId);

  /// Check if user is host
  bool isHost(String userId) => hostId == userId;

  /// Create from Firestore document
  factory ActivityModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return ActivityModel(
      id: doc.id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      category: data['category'] as String? ?? 'Other',
      hostId: data['hostId'] as String? ?? '',
      hostName: data['hostName'] as String?,
      hostPhotoUrl: data['hostPhotoUrl'] as String?,
      location: data['location'] as GeoPoint? ?? const GeoPoint(0, 0),
      locationName: data['locationName'] as String? ?? '',
      dateTime: (data['dateTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      capacity: data['capacity'] as int? ?? 10,
      price: (data['price'] as num?)?.toDouble() ?? 0,
      participants: List<String>.from(data['participants'] ?? []),
      imageUrl: data['imageUrl'] as String?,
      status: ActivityStatus.fromString(data['status'] as String?),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Convert to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'hostId': hostId,
      'hostName': hostName,
      'hostPhotoUrl': hostPhotoUrl,
      'location': location,
      'locationName': locationName,
      'dateTime': Timestamp.fromDate(dateTime),
      'capacity': capacity,
      'price': price,
      'participants': participants,
      'imageUrl': imageUrl,
      'status': status.value,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Copy with new values
  ActivityModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? hostId,
    String? hostName,
    String? hostPhotoUrl,
    GeoPoint? location,
    String? locationName,
    DateTime? dateTime,
    int? capacity,
    double? price,
    List<String>? participants,
    String? imageUrl,
    ActivityStatus? status,
    DateTime? createdAt,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      hostId: hostId ?? this.hostId,
      hostName: hostName ?? this.hostName,
      hostPhotoUrl: hostPhotoUrl ?? this.hostPhotoUrl,
      location: location ?? this.location,
      locationName: locationName ?? this.locationName,
      dateTime: dateTime ?? this.dateTime,
      capacity: capacity ?? this.capacity,
      price: price ?? this.price,
      participants: participants ?? this.participants,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
