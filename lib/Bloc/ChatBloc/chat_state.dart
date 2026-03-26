import 'package:equatable/equatable.dart';
import 'package:skin_firts/Data/chat_model.dart';
import '../../Global/enums.dart';

class ChatState extends Equatable {
  final ChatStatus? status;
  final List<ChatModel>? chats;
  final ChatType? chatType;
  final MessageStatus? messageStatus;
  final ChatModel? editingMessage;
  final ChatModel? replyMessage;
  final List<ChatModel> selectedMessages;
  final bool isSelectedMessage;

  const ChatState({
    this.chatType,
    this.status,
    this.chats,
    this.messageStatus = MessageStatus.initial,
    this.editingMessage,
    this.replyMessage,
    this.selectedMessages = const [],
    this.isSelectedMessage = false,
  });

  ChatState copyWith({
    ChatStatus? status,
    ChatType? chatType,
    List<ChatModel>? chats,
    MessageStatus? messageStatus,
    ChatModel? editingMessage,
    bool clearEditing = false,
    ChatModel? replyMessage,
    bool clearReply = false,
    List<ChatModel>? selectedMessages,
    bool clearSelection = false,
    bool? isSelectedMessage,
  }) {
    return ChatState(
      status: status ?? this.status,
      chats: chats ?? this.chats,
      chatType: chatType ?? this.chatType,
      messageStatus: messageStatus ?? this.messageStatus,
      editingMessage: clearEditing ? null : editingMessage ?? this.editingMessage,
      replyMessage: clearReply ? null : replyMessage ?? this.replyMessage,
      selectedMessages: clearSelection ? const [] : selectedMessages ?? this.selectedMessages,
      isSelectedMessage: isSelectedMessage ?? this.isSelectedMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        chats,
        chatType,
        messageStatus,
        editingMessage,
        replyMessage,
        selectedMessages,
        isSelectedMessage,
      ];
}
