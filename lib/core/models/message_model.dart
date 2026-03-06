import 'package:cloud_firestore/cloud_firestore.dart';

/// Message model for chat
class Message {
  final String id;
  final String text;
  final String senderId;
  final String senderName;
  final String? senderPhotoUrl;
  final DateTime createdAt;
  final bool isSystemMessage;

  const Message({
    required this.id,
    required this.text,
    required this.senderId,
    required this.senderName,
    this.senderPhotoUrl,
    required this.createdAt,
    this.isSystemMessage = false,
  });

  factory Message.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Message(
      id: doc.id,
      text: data['text'] ?? '',
      senderId: data['senderId'] ?? '',
      senderName: data['senderName'] ?? 'Unknown',
      senderPhotoUrl: data['senderPhotoUrl'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isSystemMessage: data['isSystemMessage'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'text': text,
      'senderId': senderId,
      'senderName': senderName,
      'senderPhotoUrl': senderPhotoUrl,
      'createdAt': FieldValue.serverTimestamp(),
      'isSystemMessage': isSystemMessage,
    };
  }
}
