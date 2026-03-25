import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../Data/chat_model.dart';

abstract class ChatEvent {}
class SendTextMessage extends ChatEvent {
  final String message;
  final String receiverId;
  final String? replyMessage;
  final String? replySender;


  SendTextMessage({required this.message, required this.receiverId, this.replyMessage, this.replySender});
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

class EditChatEvent extends ChatEvent {
  final String messageId;
  final String newMessage;
  final String chatId;

  EditChatEvent(this.messageId, this.newMessage,this.chatId);
}
class StartEditingEvent extends ChatEvent {
  final ChatModel message;

  StartEditingEvent(this.message);
}

class CancelEditing extends ChatEvent {}

class ReplyMessageEvent extends ChatEvent {
  final ChatModel message;
  ReplyMessageEvent(this.message);
}
class CancelReply extends ChatEvent {}

class AddReactionEvent extends ChatEvent{
  final String chatId;
  final String message;
  final String reaction;
  AddReactionEvent(this.chatId,this.message,this.reaction);
}