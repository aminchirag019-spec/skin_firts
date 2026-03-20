class MessageModel {
  final String? msg;
  final bool isMe;
  final DateTime time;
  final bool isRead;
  final String? imagePath;
  final String? filePath;
  final String? senderId;
  final String? receiverId;

  MessageModel({
    this.msg,
    required this.isMe,
    required this.time,
    required this.isRead,
    this.imagePath,
    this.filePath,
    required this.senderId,
    required this.receiverId
  });

  MessageModel copyWith({
    String? msg,
    bool? isMe,
    DateTime? time,
    bool? isRead,
    String? imagePath,
    String? filePath,
    String? senderId,
    String? receiverId,
  }) {
    return MessageModel(
      msg: msg ?? this.msg,
      isMe: isMe ?? this.isMe,
      time: time ?? this.time,
      isRead: isRead ?? this.isRead,
      imagePath: imagePath ?? this.imagePath,
      filePath: filePath ?? this.filePath,
      senderId: senderId??this.senderId,
      receiverId: senderId??this.receiverId
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "msg": msg,
      "isMe": isMe,
      "time": time.toIso8601String(),
      "isRead": isRead,
      "imagePath": imagePath,
      "filePath": filePath,
      "senderId":senderId,
      "receiverId":receiverId
    };
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      msg: json["msg"] ?? "",
      isMe: json["isMe"] ?? false,
      time: DateTime.parse(json["time"]),
      isRead: json["isRead"] ?? false,
      imagePath: json["imagePath"],
      filePath: json["filePath"],
      senderId: json["senderId"],
      receiverId: json["receiverId"]

    );
  }
}