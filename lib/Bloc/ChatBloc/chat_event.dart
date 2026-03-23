import '../../Data/chat_model.dart';

abstract class ChatEvent {}

/// TEXT MESSAGE
class SendTextMessage extends ChatEvent {
  final String message;
  final String receiverId;

  SendTextMessage({required this.message, required this.receiverId});
}

/// IMAGE MESSAGE
class SendImageMessage extends ChatEvent {
  final String imagePath;
  final String receiverId;

  SendImageMessage({required this.imagePath, required this.receiverId});
}

/// FILE MESSAGE
class SendFileMessage extends ChatEvent {
  final String filePath;
  final String receiverId;

  SendFileMessage({required this.filePath, required this.receiverId});
}

/// LOAD CHAT
class LoadMessageEvent extends ChatEvent {
  final String receiverId;

  LoadMessageEvent(this.receiverId);
}

class MessagesUpdated extends ChatEvent {
  final List<ChatModel> messages;

  MessagesUpdated(this.messages);
}
