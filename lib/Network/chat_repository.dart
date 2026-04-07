import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:skin_firts/Network/cloudinary_service.dart';
import '../Data/chat_model.dart';
import '../main.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final CloudinaryService _cloudinaryService = CloudinaryService();

  Future<void> sendMessage(ChatModel message) async {
    final chatId = getChatId(message.senderId, message.receiverId);

    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(message.toJson());
  }

  Future<String?> uploadToCloudinary(String path) async {
    return await _cloudinaryService.uploadImage(path);
  }

  Future<String> uploadFile(String path, String folder) async {
    try {
      File file = File(path);
      if (!file.existsSync()) {
        throw Exception("File does not exist at path: $path");
      }
      
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = _storage.ref().child(folder).child(fileName);
      
      print("Starting upload to: ${ref.fullPath}");
      UploadTask uploadTask = ref.putFile(file);
      
      // Monitor progress or wait for completion
      TaskSnapshot snapshot = await uploadTask;
      
      print("Upload complete. Fetching download URL...");
      return await snapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      print("Firebase Storage Error: ${e.code} - ${e.message}");
      rethrow;
    } catch (e) {
      print("Unknown error during upload: $e");
      rethrow;
    }
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

  Future<void> deleteMessages(String chatId, List<String> messageIds) async {
    final batch = _firestore.batch();
    final collection = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages');

    for (var id in messageIds) {
      batch.delete(collection.doc(id));
    }
    await batch.commit();
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
