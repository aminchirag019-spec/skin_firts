 import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:skin_firts/Data/chat_model.dart';

class ChatEvent {}

 class SendChatEvent extends ChatEvent{
  final ChatModel? chatModel;

  SendChatEvent(this.chatModel);
 }

 class SendImageMessage extends ChatEvent {
  final String imagePath;
  SendImageMessage(this.imagePath);
 }

 class SendFileMessage extends ChatEvent {
  final String filePath;
  SendFileMessage(this.filePath);
 }