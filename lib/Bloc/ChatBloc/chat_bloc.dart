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
    on<EditChatEvent>(_onEditChatEvent);
    on<StartEditingEvent>(_onStartEditingEvent);
    on<CancelEditing>(_onCancelEditingEvent);
    on<ReplyMessageEvent>(_onReplyMessageEvent);
    on<CancelReply>(_onCancelReplyEvent);
    on<AddReactionEvent>(_onAddReactionEvent);
  }
  void _onAddReactionEvent(
      AddReactionEvent event,
      Emitter<ChatState> emit,
      ) async {

    print("EVENT RECEIVED: ${event.message} ${event.reaction}");

    final updatedChats = (state.chats ?? []).map((chat) {
      if (chat.id == event.message) {

        print("MATCH FOUND: ${chat.id}");

        final updatedReaction =
        Map<String, List<String>>.from(chat.reaction ?? {});

        final userId = user!.uid;

        // Get existing reactions for this user
        final userReactions =
        List<String>.from(updatedReaction[userId] ?? []);

        // 🔁 Toggle logic
        if (userReactions.contains(event.reaction)) {
          userReactions.remove(event.reaction); // remove if already exists
        } else {
          userReactions.add(event.reaction); // add new one
        }

        // Clean empty list
        if (userReactions.isEmpty) {
          updatedReaction.remove(userId);
        } else {
          updatedReaction[userId] = userReactions;
        }

        print("UPDATED REACTION: $updatedReaction");

        return chat.copyWith(reaction: updatedReaction);
      }

      return chat;
    }).toList();

    emit(state.copyWith(chats: updatedChats));

    print("STATE EMITTED");

    // 🔥 IMPORTANT: send full map instead of single emoji
    final updatedChat =
    updatedChats.firstWhere((c) => c.id == event.message);

    await chatRepository.addReaction(
      chatId: event.chatId,
      messageId: event.message,
      reactions: updatedChat.reaction ?? {},
      // ✅ send full map
    );
  }
  void _onCancelReplyEvent(
    CancelReply event,
    Emitter<ChatState> emit,) {
    emit(state.copyWith(replyMessage: null,clearReply: true));
  }
  void _onReplyMessageEvent(
    ReplyMessageEvent event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(replyMessage: event.message));
  }


  void _onCancelEditingEvent(
    CancelEditing event,
    Emitter<ChatState> emit,
      ) {
    emit(state.copyWith(editingMessage: null));
  }
  void _onStartEditingEvent(
    StartEditingEvent event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(editingMessage: event.message));
  }


  void _onEditChatEvent(
    EditChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    await chatRepository.editMessage(event.messageId, event.newMessage,event.chatId);

    final messages = state.chats!.map((chat) {
      if (chat.id == event.messageId) {
        return chat.copyWith(message: event.newMessage, isEdited: true);
      }
      return chat;
    }).toList();
    emit(state.copyWith(chats: messages,editingMessage: null));
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
    final reply = state.replyMessage;
    String receiverToken = userDoc.data()?['fcmToken'] ?? "";

    final newMessage = ChatModel(
      message: event.message,
      senderId: user!.uid,
      timestamp: DateTime.now(),
      chatType: ChatType.text,
      receiverId: event.receiverId,
      receiverToken: receiverToken, // ✅ IMPORTANT
      id: '',
      replyMessage: reply?.message,
      replySender: reply?.senderId,
    );
    final updatedChats = [newMessage, ...state.chats!];
    emit(state.copyWith(chats: updatedChats, replyMessage: null));

    await chatRepository.sendMessage(newMessage);
    emit(state.copyWith(replyMessage: null));
    emit(state.copyWith(clearReply: true));
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
