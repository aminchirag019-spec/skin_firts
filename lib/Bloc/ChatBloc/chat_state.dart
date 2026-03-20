import 'package:equatable/equatable.dart';
import '../../Data/message_model.dart';

class ChatState extends Equatable {
  final List<MessageModel> messages;


  ChatState({required this.messages});

  ChatState copyWith({List<MessageModel>? messages, Map<String, bool>? typingUsers,bool? isTyping}) {
    return ChatState(
      messages: messages ?? this.messages,

    );
  }

  @override
  List<Object?> get props => [messages,];
}