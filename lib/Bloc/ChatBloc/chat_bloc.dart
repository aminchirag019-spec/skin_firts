import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_firts/Data/chat_model.dart';
import 'package:skin_firts/Network/chat_repository.dart';
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
    on<EditChatEvent>(_onEditChatEvent);
    on<StartEditingEvent>(_onStartEditingEvent);
    on<CancelEditing>(_onCancelEditingEvent);
    on<ReplyMessageEvent>(_onReplyMessageEvent);
    on<CancelReply>(_onCancelReplyEvent);
    on<AddReactionEvent>(_onAddReactionEvent);
    on<ToggleMessageSelection>(_onToggleMessageSelection);
    on<UnSelectMessageEvent>(_onUnSelectMessageEvent);
    on<DeleteMessagesEvent>(_onDeleteMessages);
  }

  void _onToggleMessageSelection(
    ToggleMessageSelection event,
    Emitter<ChatState> emit,
  ) {
    final currentSelected = List<ChatModel>.from(state.selectedMessages);
    if (currentSelected.any((m) => m.id == event.message.id)) {
      currentSelected.removeWhere((m) => m.id == event.message.id);
    } else {
      currentSelected.add(event.message);
    }

    emit(state.copyWith(
      isSelectedMessage: currentSelected.isNotEmpty,
      selectedMessages: currentSelected,
    ));
  }

  void _onUnSelectMessageEvent(
    UnSelectMessageEvent event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(
      isSelectedMessage: false,
      clearSelection: true,
    ));
  }

  void _onDeleteMessages(
    DeleteMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    final chatId = chatRepository.getChatId(user!.uid, event.receiverId);
    await chatRepository.deleteMessages(chatId, event.messageIds);
    add(UnSelectMessageEvent());
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
      event.chatId,
      event.messageId,
      event.newMessage,
    );
    emit(state.copyWith(editingMessage: null));
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
    
    await chatRepository.sendMessage(newMessage);
    emit(state.copyWith(replyMessage: null, clearReply: true));
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
    
    await chatRepository.sendMessage(sendImage);
    emit(state.copyWith(replyMessage: null, clearReply: true));
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

    await chatRepository.sendMessage(sendFile);
    emit(state.copyWith(replyMessage: null, clearReply: true));
  }
}
