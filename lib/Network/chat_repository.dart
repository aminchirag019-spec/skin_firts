import 'package:cloud_firestore/cloud_firestore.dart';

import '../Data/chat_model.dart';
import '../Screens/ChatScreens/chat_widget.dart';

class ChatRepository {
  final FirebaseFirestore firestore;

  ChatRepository(this.firestore);

  /// SEND MESSAGE
  Future<void> sendMessage(ChatModel message) async {
    final chatId = generateChatId(message.senderId, message.receiverId);

    final chatRef = firestore.collection('chats').doc(chatId);
    await chatRef.collection('messages').add(message.toJson());
    await chatRef.set({
      'participants': [message.senderId, message.receiverId],
      'lastMessage': message.message ?? '',
      'lastTimestamp': Timestamp.fromDate(message.timestamp),
    }, SetOptions(merge: true));
  }

  /// GET MESSAGES (STREAM)
  Stream<List<ChatModel>> getMessages(String currentUserId, String receiverId) {
    final chatId = generateChatId(currentUserId, receiverId);

    return firestore
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
}
