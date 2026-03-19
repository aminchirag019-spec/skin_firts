import '../Global/enums.dart';

class ChatModel {
  // final String id;
  final String? message;
  final String senderId;
  final String filePath;
  // final String receiverId;
  final DateTime timestamp;
  final ChatType? chatType;

  ChatModel({
    // required this.id,
     this.message,
    required this.senderId,
    // required this.receiverId,
    required this.timestamp,
    this.filePath = '',
    this.chatType,
  });

  /// copyWith (very useful in BLoC)
  ChatModel copyWith({
    // String? id,
    String? message,
    String? senderId,
    // String? receiverId,
    DateTime? timestamp,
    String? filePath,
    ChatType? chatType,
  }) {
    return ChatModel(
      // id: id ?? this.id,
      message: message ?? this.message,
      senderId: senderId ?? this.senderId,
      // receiverId: receiverId ?? this.receiverId,
      timestamp: timestamp ?? this.timestamp,
      filePath: filePath ?? this.filePath,
      chatType: chatType ?? this.chatType,
    );
  }

  /// JSON → Object
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      // id: json['id'] ?? '',
      message: json['message'] ?? '',
      senderId: json['senderId'] ?? '',
      // receiverId: json['receiverId'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
      filePath: json['filePath'] ?? '',
      // chatType: json['chatType'] ?? '',
    );
  }

  /// Object → JSON
  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      'message': message,
      'senderId': senderId,
      // 'receiverId': receiverId,
      'timestamp': timestamp.toIso8601String(),
      'filePath': filePath,
      // 'chatType': chatType,
    };
  }
}