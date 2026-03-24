import '../../Data/chat_model.dart';

abstract class ChatEvent {}
class SendTextMessage extends ChatEvent {
  final String message;
  final String receiverId;

  SendTextMessage({required this.message, required this.receiverId});
}

class SendImageMessage extends ChatEvent {
  final String imagePath;
  final String receiverId;

  SendImageMessage({required this.imagePath, required this.receiverId});
}

class SendFileMessage extends ChatEvent {
  final String filePath;
  final String receiverId;

  SendFileMessage({required this.filePath, required this.receiverId});
}


class LoadMessageEvent extends ChatEvent {
  final String receiverId;

  LoadMessageEvent(this.receiverId);
}

class MessagesUpdated extends ChatEvent {
  final List<ChatModel> messages;

  MessagesUpdated(this.messages);
}
class ChatNotificationEvent extends ChatEvent{
  final ChatModel chatModel;
ChatNotificationEvent(this.chatModel);
}
