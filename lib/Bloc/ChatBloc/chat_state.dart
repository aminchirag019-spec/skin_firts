import 'package:equatable/equatable.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:skin_firts/Data/chat_model.dart';

import '../../Global/enums.dart';

class ChatState extends Equatable {
  final ChatStatus? status;
  final List<ChatModel>? chats;
  final ChatType? chatType;
  final MessageStatus? messageStatus;
  final ChatModel? editingMessage;
  final ChatModel? replyMessage;


  const ChatState({this.chatType, this.status, this.chats,this.messageStatus = MessageStatus.initial,this.editingMessage,this.replyMessage})
  ;

  ChatState copyWith({
    ChatStatus? status,
    ChatType? chatType,
    List<ChatModel>? chats,
    MessageStatus? messageStatus,
    ChatModel? editingMessage,
    ChatModel? replyMessage,
    bool clearReply = false,
  }) {
    return ChatState(
      status: status ?? this.status,
      chats: chats ?? this.chats,
      chatType: chatType ?? this.chatType,
      messageStatus: messageStatus ?? this.messageStatus,
      editingMessage: editingMessage ?? this.editingMessage,
      replyMessage: clearReply ? null : replyMessage ?? this.replyMessage,
    );
  }

  @override
  List<Object> get props => [?status, ?chats, ?chatType, ?messageStatus, ?editingMessage, ?replyMessage];
}
