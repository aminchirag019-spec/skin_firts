import 'package:equatable/equatable.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:skin_firts/Data/chat_model.dart';

import '../../Global/enums.dart';

class ChatState extends Equatable {
  final ChatStatus? status;
  final List<ChatModel>? chats;
  final ChatType? chatType;

  const ChatState({
    this.chatType,
     this.status,
    this.chats,
  });

  ChatState copyWith({
    ChatStatus? status,
    ChatType? chatType,
    List<ChatModel>? chats,
  }) {
    return ChatState(
      status: status ?? this.status,
      chats: chats ?? this.chats,
      chatType: chatType ?? this.chatType,
    );
  }
  @override
  List<Object> get props =>[
    ?status,
    ?chats,
    ?chatType,
  ];
}