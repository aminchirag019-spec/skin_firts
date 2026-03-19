import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:skin_firts/Data/chat_model.dart';
import 'package:skin_firts/main.dart';

import '../../Global/enums.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(const ChatState(chats: [])) {
    on<SendChatEvent>(_onSendChatEvent);
    on<SendImageMessage>(_onSendImageMessage);
    on<SendFileMessage>(_onSendFileMessage);
  }

  void _onSendChatEvent(SendChatEvent event, Emitter<ChatState> emit) async {
    final newMessage = ChatModel(
      message: event.chatModel!.message,
      senderId: user!.uid,
      timestamp: DateTime.now(),
      chatType: ChatType.text
    );
    emit(state.copyWith(chats: [...state.chats!, newMessage]));
  }

  void _onSendImageMessage(
    SendImageMessage event,
    Emitter<ChatState> emit,
  ) async {
    final sendImage = ChatModel(
      filePath: event.imagePath,
      senderId: user!.uid,
      timestamp: DateTime.now(),
      chatType: ChatType.image,

    );
    emit(state.copyWith(chats: [...state.chats!, sendImage]));
  }


  void _onSendFileMessage(
    SendFileMessage event,
    Emitter<ChatState> emit,
  ) async {
    final sendFile = ChatModel(
      filePath: event.filePath,
      senderId: user!.uid,
      timestamp: DateTime.now(),
      chatType: ChatType.file
    );
    emit(state.copyWith(chats: [...state.chats!, sendFile]));
  }
}
