import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    on<EditChatEvent>(_onEditChatEvent);
    on<StartEditingEvent>(_onStartEditingEvent);
    on<CancelEditing>(_onCancelEditingEvent);
    on<ReplyMessageEvent>(_onReplyMessageEvent);
    on<CancelReply>(_onCancelReplyEvent);
    on<AddReactionEvent>(_onAddReactionEvent);
    on<SelectMessageEvent>(_onSelectMessageEvent);
    on<UnSelectMessageEvent>(_onUnSelectMessageEvent);
  }

  void _onSelectMessageEvent(
    SelectMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(
      isSelectedMessage: true,
      selectMessage: event.message,
    ));
  }

  void _onUnSelectMessageEvent(
    UnSelectMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(isSelectedMessage: false, clearSelection: true));
  }

  void _onAddReactionEvent(
    AddReactionEvent event,
    Emitter<ChatState> emit,
  ) async {
    final userId = user!.uid;

    final updatedChats = (state.chats ?? []).map((chat) {
      if (chat.id == event.message) {
        final updatedReaction = Map<String, String>.from(chat.reaction ?? {});
        if (updatedReaction[userId] == event.reaction) {
          updatedReaction.remove(userId);
        } else {
          updatedReaction[userId] = event.reaction;
        }
        return chat.copyWith(reaction: updatedReaction);
      }
      return chat;
    }).toList();

    emit(state.copyWith(chats: updatedChats));

    await chatRepository.addReaction(
      chatId: event.chatId,
      messageId: event.message,
      emoji: event.reaction,
      userId: userId,
    );
  }

  void _onCancelReplyEvent(CancelReply event, Emitter<ChatState> emit) {
    emit(state.copyWith(replyMessage: null, clearReply: true));
  }

  void _onReplyMessageEvent(ReplyMessageEvent event, Emitter<ChatState> emit) {
    emit(state.copyWith(replyMessage: event.message));
  }

  void _onCancelEditingEvent(CancelEditing event, Emitter<ChatState> emit) {
    emit(state.copyWith(editingMessage: null));
  }

  void _onStartEditingEvent(StartEditingEvent event, Emitter<ChatState> emit) {
    emit(state.copyWith(editingMessage: event.message));
  }

  void _onEditChatEvent(EditChatEvent event, Emitter<ChatState> emit) async {
    await chatRepository.editMessage(
      event.messageId,
      event.newMessage,
      event.chatId,
    );

    final messages = state.chats!.map((chat) {
      if (chat.id == event.messageId) {
        return chat.copyWith(message: event.newMessage, isEdited: true);
      }
      return chat;
    }).toList();
    emit(state.copyWith(chats: messages, editingMessage: null));
  }

  void _onChatNotificationEvent(
    ChatNotificationEvent event,
    Emitter<ChatState> emit,
  ) async {
    await chatRepository.sendMessage(event.chatModel);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      NotificationService.showNotification(
        message.notification?.title ?? "",
        message.notification?.body ?? "",
      );
    });
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
      add(MessagesUpdated(messages));
    });
  }

  void _onSendChatEvent(SendTextMessage event, Emitter<ChatState> emit) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(event.receiverId)
        .get();
    final reply = state.replyMessage;
    String receiverToken = userDoc.data()?['fcmToken'] ?? "";
    final newMessage = ChatModel(
      message: event.message,
      senderId: user!.uid,
      timestamp: DateTime.now(),
      chatType: ChatType.text,
      receiverId: event.receiverId,
      receiverToken: receiverToken,
      id: '',
      replyMessage: reply?.message ?? (reply?.chatType == ChatType.image ? "Photo" : reply?.chatType == ChatType.file ? "File" : null),
      replySender: reply?.senderId,
    );
    final updatedChats = [newMessage, ...state.chats!];
    emit(state.copyWith(chats: updatedChats, replyMessage: null, clearReply: true));

    await chatRepository.sendMessage(newMessage);
  }

  void _onSendImageMessage(
    SendImageMessage event,
    Emitter<ChatState> emit,
  ) async {
    final reply = state.replyMessage;
    final sendImage = ChatModel(
      filePath: event.imagePath,
      senderId: user!.uid,
      timestamp: DateTime.now(),
      chatType: ChatType.image,
      id: '',
      receiverId: event.receiverId,
      replyMessage: reply?.message ?? (reply?.chatType == ChatType.image ? "Photo" : reply?.chatType == ChatType.file ? "File" : null),
      replySender: reply?.senderId,
    );
    
    final updatedChats = [sendImage, ...state.chats!];
    emit(state.copyWith(chats: updatedChats, replyMessage: null, clearReply: true));
    
    await chatRepository.sendMessage(sendImage);
  }

  void _onSendFileMessage(
    SendFileMessage event,
    Emitter<ChatState> emit,
  ) async {
    final reply = state.replyMessage;
    final sendFile = ChatModel(
      filePath: event.filePath,
      senderId: user!.uid,
      timestamp: DateTime.now(),
      chatType: ChatType.file,
      id: '',
      receiverId: event.receiverId,
      replyMessage: reply?.message ?? (reply?.chatType == ChatType.image ? "Photo" : reply?.chatType == ChatType.file ? "File" : null),
      replySender: reply?.senderId,
    );

    final updatedChats = [sendFile, ...state.chats!];
    emit(state.copyWith(chats: updatedChats, replyMessage: null, clearReply: true));

    await chatRepository.sendMessage(sendFile);
  }
}
