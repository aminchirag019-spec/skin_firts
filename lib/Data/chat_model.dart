import 'package:cloud_firestore/cloud_firestore.dart';
import '../Global/enums.dart';

class ChatModel {
  final String id;
  final String? message;
  final String senderId;
  final String receiverId;
  final String filePath;
  final DateTime timestamp;
  final ChatType? chatType;
  final String? receiverToken;


  ChatModel({
    required this.id,
    this.message,
    required this.senderId,
    required this.receiverId,
    required this.timestamp,
    this.filePath = '',
    required this.chatType,
    this.receiverToken,
  });

  /// copyWith (BLoC friendly)
  ChatModel copyWith({
    String? id,
    String? message,
    String? senderId,
    String? receiverId,
    DateTime? timestamp,
    String? filePath,
    ChatType? chatType,
    String? receiverToken,
  }) {
    return ChatModel(
      id: id ?? this.id,
      message: message ?? this.message,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      timestamp: timestamp ?? this.timestamp,
      filePath: filePath ?? this.filePath,
      chatType: chatType ?? this.chatType,
      receiverToken: receiverToken ?? this.receiverToken,
    );
  }

  /// JSON → Object (Firestore safe)
  factory ChatModel.fromJson(Map<String, dynamic> json, String docId) {
    return ChatModel(
      id: docId,
      message: json['message'],
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      filePath: json['filePath'] ?? '',
      chatType: ChatType.values.firstWhere(
        (e) => e.name == json['chatType'],
        orElse: () => ChatType.text,
      ),
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      receiverToken: json['receiverToken'] ?? '',
    );
  }

  /// Object → JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'senderId': senderId,
      'receiverId': receiverId,
      'filePath': filePath,
      'chatType': chatType?.name,
      'timestamp': Timestamp.fromDate(timestamp),
      'receiverToken': receiverToken,
    };
  }
}
