import 'package:skin_firts/Data/message_model.dart';

abstract class ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final MessageModel message;
  final String conversationId;

  SendMessageEvent({required this.message, required this.conversationId});
}

class LoadMessagesEvent extends ChatEvent {
  final String conversationId;

  LoadMessagesEvent(this.conversationId);
}
