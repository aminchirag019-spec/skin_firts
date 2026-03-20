
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_firts/Network/auth_repository.dart';
import '../../Data/message_model.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final AuthRepository authRepository;

  ChatBloc(this.authRepository)
    : super(
        ChatState(
          messages: [
            MessageModel(
              msg: "Hello 👋",
              isMe: false,
              time: DateTime.now(),
              isRead: true, senderId: '', receiverId: '',
            ),
            MessageModel(
              msg: "Hi!",
              isMe: true,
              time: DateTime.now(),
              isRead: true, senderId: '', receiverId: '',
            ),
          ],
        ),
      ) {
    on<SendMessageEvent>(onSendMessage);
    on<LoadMessagesEvent>(onLoadMessages);

  }

  void onSendMessage(SendMessageEvent event, emit) async {


      final newList = List<MessageModel>.from(state.messages);
      newList.add(event.message);

      emit(state.copyWith(messages: newList));

      await authRepository.sendMessage(
        event.conversationId,
        event.message,
      );
 }

  void onLoadMessages(
      LoadMessagesEvent event,
      Emitter<ChatState> emit,
      ) async {
    await emit.forEach<List<MessageModel>>(
      authRepository.getMessages(event.conversationId),
      onData: (messages) {
        print(messages);
        return state.copyWith(messages: messages);
      },
    );
  }


}
