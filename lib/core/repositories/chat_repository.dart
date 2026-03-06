import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/message_model.dart';
import '../providers/core_providers.dart';

part 'chat_repository.g.dart';

class ChatRepository {
  final FirebaseFirestore _firestore;

  ChatRepository(this._firestore);

  /// Get messages stream for an activity
  Stream<List<Message>> watchMessages(String activityId) {
    return _firestore
        .collection('activities')
        .doc(activityId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Message.fromFirestore(doc)).toList();
    });
  }

  /// Send a message
  Future<void> sendMessage({
    required String activityId,
    required String text,
    required String senderId,
    required String senderName,
    String? senderPhotoUrl,
  }) async {
    final message = Message(
      id: '', // Firestore gen
      text: text,
      senderId: senderId,
      senderName: senderName,
      senderPhotoUrl: senderPhotoUrl,
      createdAt: DateTime.now(),
    );

    await _firestore
        .collection('activities')
        .doc(activityId)
        .collection('messages')
        .add(message.toFirestore());

    // Update last activity message for list view previews (optional optimization)
    await _firestore.collection('activities').doc(activityId).update({
      'lastMessage': text,
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
  }
}

@riverpod
ChatRepository chatRepository(Ref ref) {
  return ChatRepository(FirebaseFirestore.instance);
}

@riverpod
Stream<List<Message>> activityMessages(Ref ref, String activityId) {
  return ref.watch(chatRepositoryProvider).watchMessages(activityId);
}
