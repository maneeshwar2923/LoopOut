import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/activity_model.dart';

/// Sample activities for UI testing
/// These are used when Firestore is empty or for development
class SampleActivities {
  SampleActivities._();

  static final List<ActivityModel> activities = [
    ActivityModel(
      id: 'sample-1',
      title: 'Morning Yoga at Cubbon Park',
      description: 'Start your day with a refreshing yoga session in the heart of the city. All levels welcome. Bring your own mat if you have one!',
      category: 'Sports',
      hostId: 'sample-host-1',
      hostName: 'Priya K.',
      hostPhotoUrl: null,
      locationName: 'Cubbon Park, MG Road',
      location: const GeoPoint(12.9763, 77.5929),
      dateTime: DateTime.now().add(const Duration(days: 1, hours: 6)),
      capacity: 15,
      participants: ['user1', 'user2', 'user3', 'user4', 'user5', 'user6', 'user7', 'user8'],
      price: 0, // Free
      imageUrl: null,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      status: ActivityStatus.active,
    ),
    ActivityModel(
      id: 'sample-2',
      title: 'Photography Walk at Lalbagh',
      description: 'Explore the beautiful Lalbagh Botanical Garden with fellow photography enthusiasts. Perfect for beginners and pros alike.',
      category: 'Arts',
      hostId: 'sample-host-2',
      hostName: 'Rahul M.',
      hostPhotoUrl: null,
      locationName: 'Lalbagh Botanical Garden',
      location: const GeoPoint(12.9507, 77.5848),
      dateTime: DateTime.now().add(const Duration(days: 3, hours: 7)),
      capacity: 10,
      participants: ['user1', 'user2', 'user3'],
      price: 200,
      imageUrl: null,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      status: ActivityStatus.active,
    ),
    ActivityModel(
      id: 'sample-3',
      title: 'Board Games Night',
      description: 'Join us for a fun evening of board games! We have Catan, Monopoly, Scrabble, and more. Snacks provided.',
      category: 'Social',
      hostId: 'sample-host-3',
      hostName: 'Sneha R.',
      hostPhotoUrl: null,
      locationName: 'Dice N Dine, Koramangala',
      location: const GeoPoint(12.9352, 77.6245),
      dateTime: DateTime.now().add(const Duration(days: 2, hours: 19)),
      capacity: 8,
      participants: ['user1', 'user2', 'user3', 'user4', 'user5', 'user6', 'user7', 'user8'],
      price: 150,
      imageUrl: null,
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      status: ActivityStatus.active,
    ),
    ActivityModel(
      id: 'sample-4',
      title: 'Live Music Jam Session',
      description: 'Open mic for musicians! Bring your instrument or just come to listen. All genres welcome.',
      category: 'Music',
      hostId: 'sample-host-4',
      hostName: 'Arjun S.',
      hostPhotoUrl: null,
      locationName: 'The Humming Tree, Indiranagar',
      location: const GeoPoint(12.9784, 77.6408),
      dateTime: DateTime.now().add(const Duration(days: 4, hours: 20)),
      capacity: 25,
      participants: ['user1', 'user2', 'user3', 'user4', 'user5'],
      price: 0,
      imageUrl: null,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      status: ActivityStatus.active,
    ),
    ActivityModel(
      id: 'sample-5',
      title: 'Tech Meetup: Flutter Development',
      description: 'Learn and share Flutter development tips with fellow developers. Lightning talks and networking session.',
      category: 'Tech',
      hostId: 'sample-host-5',
      hostName: 'Vikram P.',
      hostPhotoUrl: null,
      locationName: 'WeWork, Brigade Gateway',
      location: const GeoPoint(13.0127, 77.5567),
      dateTime: DateTime.now().add(const Duration(days: 5, hours: 18)),
      capacity: 30,
      participants: ['user1'],
      price: 0,
      imageUrl: null,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      status: ActivityStatus.active,
    ),
  ];

  /// Get all sample activities
  static List<ActivityModel> getAll() => activities;

  /// Get trending activities (most participants)
  static List<ActivityModel> getTrending() {
    final sorted = [...activities]
      ..sort((a, b) => b.participants.length.compareTo(a.participants.length));
    return sorted.take(5).toList();
  }
}
