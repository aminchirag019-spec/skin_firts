import 'package:equatable/equatable.dart';
import 'package:skin_firts/Data/chat_model.dart';
import '../../Data/auth_model.dart';
import '../../Global/enums.dart';

class ChatState extends Equatable {
  final ChatStatus? status;
  final List<ChatModel>? chats;
  final ChatType? chatType;
  final ChatListStatus chatListStatus;
  final MessageStatus? messageStatus;
  final List<SignupModel> doctors;
  final List<SignupModel> users;
  final SignupModel? currentUser;
  final ChatModel? editingMessage;
  final ChatModel? replyMessage;
  final List<ChatModel> selectedMessages;
  final bool isSelectedMessage;
  final String? role;
  final String? selectedRole;



  const ChatState({
    this.chatType,
    this.doctors=const[],
    this.users=const[],
    this.chatListStatus = ChatListStatus.initial,
    this.currentUser,
    this.status,
    this.chats,
    this.messageStatus = MessageStatus.initial,
    this.editingMessage,
    this.replyMessage,
    this.selectedMessages = const [],
    this.isSelectedMessage = false,
    this.selectedRole="user",
    this.role,
  });

  ChatState copyWith({
    ChatStatus? status,
    ChatType? chatType,
    SignupModel? currentUser,
    List<ChatModel>? chats,
    ChatListStatus? chatListStatus,
    MessageStatus? messageStatus,
    ChatModel? editingMessage,
    bool clearEditing = false,
    ChatModel? replyMessage,
    bool clearReply = false,
    List<ChatModel>? selectedMessages,
    bool clearSelection = false,
    bool? isSelectedMessage,
    String? role,
    String? selectedRole,
    List<SignupModel>? doctors,
    List<SignupModel>? users,
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
      chatListStatus: chatListStatus??this.chatListStatus,
        selectedRole: selectedRole??this.selectedRole,
      role: role??this.role,
      doctors: doctors??this.doctors,
      users: users??this.users,
      currentUser: currentUser ?? this.currentUser,
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
    chatListStatus,
    role,selectedRole,
        doctors,
        users,
        currentUser,
      ];
}
