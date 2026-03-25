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
  final bool? isEdited;
  final String? replyMessage;
  final String? replySender;
  final Map<String,List<String>>? reaction;

  ChatModel({
    required this.id,
    this.isEdited,
    this.message,
    required this.senderId,
    required this.receiverId,
    required this.timestamp,
    this.filePath = '',
    required this.chatType,
    this.receiverToken,
    this.replyMessage,
    this.replySender,
    this.reaction,
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
    bool? isEdited,
    String? replyMessage,
    String? replySender,
    Map<String,List<String>>? reaction,
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
      isEdited: isEdited ?? this.isEdited,
      replyMessage: replyMessage ?? this.replyMessage,
      replySender: replySender ?? this.replySender,
      reaction: reaction ?? this.reaction,
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
      isEdited: json['isEdited'] ?? false,
      replyMessage: json['replyMessage'] ?? '',
      replySender: json['replySender'] ?? '',
      reaction: json['reaction'] != null
          ? (json['reaction'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(
          key,
          List<String>.from(value),
        ),
      )
          : {},
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
      'isEdited': isEdited,
      'replyMessage': replyMessage,
      'replySender': replySender,
      'reaction': reaction,
    };
  }
}
