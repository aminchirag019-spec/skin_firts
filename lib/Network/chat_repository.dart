import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../Data/chat_model.dart';
import '../main.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(ChatModel message) async {
    final chatId = getChatId(message.senderId, message.receiverId);

    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(message.toJson());
  }

  Future<void> editMessage(
      String chatId,
      String messageId,
      String newMessage,
      ) async {
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({
      'message': newMessage,
      'isEdited': true,
    });
  }
  Future<void> addReaction({
    required String chatId,
    required String messageId,
    required String userId,
    required String emoji,
  }) async {
    final ref = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId);

    await ref.update({
      'reaction.$userId': emoji, // ✅ correct
    });
  }
  Future<void> removeReaction({
    required String chatId,
    required String messageId,
    required String userId,
  }) async {
    final ref = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId);

    await ref.update({
      'reaction.$userId': FieldValue.delete(), // ✅ remove
    });
  }
  String getChatId(String u1, String u2) {
    return u1.hashCode <= u2.hashCode ? "$u1-$u2" : "$u2-$u1";
  }

  Stream<List<ChatModel>> getMessages(
      String currentUserId, String receiverId) {
    final chatId = getChatId(currentUserId, receiverId);

    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map((doc) => ChatModel.fromJson(doc.data(), doc.id))
          .toList(),
    );
  }

  Future<void> saveFcmToken(String userId) async {
    String? token = await FirebaseMessaging.instance.getToken();

    print("MY TOKEN: $token");

    if (token != null) {
      await _firestore.collection('users').doc(userId).set({
        "fcmToken": token,
      }, SetOptions(merge: true));
    }
  }
}