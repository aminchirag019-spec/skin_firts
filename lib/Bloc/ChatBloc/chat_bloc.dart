import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:skin_firts/Data/chat_model.dart';
import 'package:skin_firts/Network/chat_repository.dart';
import 'package:skin_firts/Utilities/firebase_message.dart';
import 'package:skin_firts/main.dart';

import '../../Global/enums.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  StreamSubscription<List<ChatModel>>? streamSubscription;
  ChatBloc(this.chatRepository) : super(const ChatState(chats: [])) {
    on<SendTextMessage>(_onSendChatEvent);
    on<SendImageMessage>(_onSendImageMessage);
    on<SendFileMessage>(_onSendFileMessage);
    on<LoadMessageEvent>(_onLoadMessageEvent);
    on<MessagesUpdated>(_onMessagesUpdated);
    on<ChatNotificationEvent>(_onChatNotificationEvent);
  }

  void _onChatNotificationEvent(
    ChatNotificationEvent event,
    Emitter<ChatState> emit,
  ) async {
    await chatRepository.sendMessage(event.chatModel);
    NotificationService.showNotification("New message",
    "You have a new message from ${event.chatModel.senderId}");
    emit(state.copyWith(messageStatus: MessageStatus.sent));
  }

  void _onMessagesUpdated(MessagesUpdated event, Emitter<ChatState> emit) {
    emit(state.copyWith(chats: event.messages));
  }

  void _onLoadMessageEvent(
    LoadMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    streamSubscription?.cancel();

    streamSubscription = chatRepository
        .getMessages(user!.uid, event.receiverId)
        .listen((messages) {
          print("MESSAGES: ${messages.length}");
          add(MessagesUpdated(messages));
        });
  }

  void _onSendChatEvent(SendTextMessage event, Emitter<ChatState> emit) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(event.receiverId)
        .get();

    String receiverToken = userDoc.data()?['fcmToken'] ?? "";

    final newMessage = ChatModel(
      message: event.message,
      senderId: user!.uid,
      timestamp: DateTime.now(),
      chatType: ChatType.text,
      receiverId: event.receiverId,
      receiverToken: receiverToken, // ✅ IMPORTANT
      id: '',
    );

    await chatRepository.sendMessage(newMessage);
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
      id: '',
      receiverId: event.receiverId,
    );
    await chatRepository.sendMessage(sendImage);
  }

  void _onSendFileMessage(
    SendFileMessage event,
    Emitter<ChatState> emit,
  ) async {
    final sendFile = ChatModel(
      filePath: event.filePath,
      senderId: user!.uid,
      timestamp: DateTime.now(),
      chatType: ChatType.file,
      id: '',
      receiverId: event.receiverId,
    );
    await chatRepository.sendMessage(sendFile);
  }
}
