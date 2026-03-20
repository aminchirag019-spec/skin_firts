
import 'dart:async';
import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Bloc/ChatBloc/chat_bloc.dart';
import '../../../Bloc/ChatBloc/chat_event.dart';
import '../../../Bloc/ChatBloc/chat_state.dart';
import '../../../Data/message_model.dart';
import '../ChatWidgets/conversation_id.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final String otherUserId;
  final String name;

   ChatScreen({
    super.key,
    required this.currentUserId,
    required this.otherUserId,
    required this.name
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  bool showEmoji = false;
  String? selectedImage;
  String? selectedFile;

  late String conversationId;

  @override
  void initState() {
    super.initState();

    conversationId =
        getConversationId(widget.currentUserId, widget.otherUserId);

    context.read<ChatBloc>().add(LoadMessagesEvent(conversationId));
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void toggleEmojiPicker() {
    if (showEmoji) {
      focusNode.requestFocus();
    } else {
      FocusScope.of(context).unfocus();
    }
    setState(() => showEmoji = !showEmoji);
  }

  void sendMessage() {
    if (messageController.text.trim().isEmpty &&
        selectedImage == null &&
        selectedFile == null) {
      return;
    }

    final msg = MessageModel(
      msg: messageController.text,
      isMe: true,
      time: DateTime.now(),
      isRead: false,
      imagePath: selectedImage,
      filePath: selectedFile, senderId: widget.currentUserId, receiverId: widget.otherUserId,
    );

    context.read<ChatBloc>().add(
      SendMessageEvent(
        conversationId: conversationId,
        message: msg,
      ),
    );

    messageController.clear();

    setState(() {
      selectedImage = null;
      selectedFile = null;
      showEmoji = false;
    });
  }

  late String? type="";
  Timer? typingTimer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: const Color(0xff2260FF),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
        ),
        title: Row(
          children:  [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Icon(Icons.local_hospital,
                  color: Color(0xff2260FF)),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.name,
                    style: TextStyle(color: Colors.white)),
                Text("Online",
                    style: TextStyle(
                        color: Colors.white70, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),

      body: Column(
        children: [

          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                // Scroll to bottom automatically
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (scrollController.hasClients) {
                    scrollController.jumpTo(
                      scrollController.position.maxScrollExtent,
                    );
                  }
                });

                if (state.messages.isEmpty) {
                  return Center(child: Text("No messages"));
                }

                return Column(
                  children: [
                    // Message List
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.all(10),
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) {
                          final data = state.messages[index];
                          final isMe = data.senderId == widget.currentUserId;

                          return Row(
                            mainAxisAlignment: isMe
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (!isMe)
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.blue.shade100,
                                    child: const Icon(
                                      Icons.local_hospital,
                                      size: 18,
                                      color: Color(0xff2260FF),
                                    ),
                                  ),
                                ),
                              Flexible(
                                child: IntrinsicWidth(
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(vertical: 5),
                                    padding: const EdgeInsets.all(12),
                                    constraints: BoxConstraints(
                                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isMe ? Color(0xff2260FF) : Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(color: Colors.black12, blurRadius: 5),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        if (data.imagePath != null && data.imagePath!.isNotEmpty)
                                          Image.file(File(data.imagePath!), height: 120),
                                        if (data.msg != null && data.msg!.isNotEmpty)
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              data.msg!,
                                              style: TextStyle(
                                                color: isMe ? Colors.white : Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        SizedBox(height: 5),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "${data.time.hour}:${data.time.minute.toString().padLeft(2, '0')}",
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: isMe ? Colors.white70 : Colors.grey,
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Icon(Icons.done_all, size: 20, color: Colors.blueAccent)
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              if (isMe)
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.grey.shade300,
                                    child: const Icon(Icons.person, size: 18, color: Colors.black54),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),

                  ],
                );
              },
            ),
          ),

          if (selectedImage != null || selectedFile != null)
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  if (selectedImage != null)
                    Stack(
                      children: [
                        Image.file(
                          File(selectedImage!),
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          right: 0,
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => selectedImage = null),
                            child:  Icon(Icons.close,
                                color: Colors.red),
                          ),
                        )
                      ],
                    ),

                  if (selectedFile != null)
                    Expanded(
                      child: Row(
                        children: [
                           Icon(Icons.insert_drive_file),
                           SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              selectedFile!.split('/').last,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          GestureDetector(
                            onTap: () =>
                                setState(() => selectedFile = null),
                            child:  Icon(Icons.close,
                                color: Colors.red),
                          )
                        ],
                      ),
                    )
                ],
              ),
            ),

          Container(

            padding: const EdgeInsets.symmetric(
                horizontal: 8, vertical: 5),
            color: Colors.white,
            child: Row(
              children: [
                IconButton(
                  onPressed: toggleEmojiPicker,
                  icon:  Icon(Icons.emoji_emotions,
                      color: Color(0xff2260FF)),
                ),
                Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 120,
                    ),
                    child: TextField(
                      onChanged: (text){
                        // context.read<ChatBloc>().add(
                        //   TypingEvent(
                        //     conversationId: conversationId,
                        //     senderId: widget.otherUserId,
                        //     isTyping: text.isNotEmpty,
                        //   ),
                        // );

                      },

                      minLines: 1,
                      maxLines: 5,

                      focusNode: focusNode,
                      controller: messageController,
                      keyboardType: TextInputType.multiline,
                      onTap: () {
                        if (showEmoji) {
                          setState(() => showEmoji = false);
                        }
                        print("Curent User:::$conversationId");
                        print("sender Id User:::${widget.currentUserId}");
                        print("type:::$type");
                        print("Other Id:::${widget.otherUserId}");
                      },
                      decoration: const InputDecoration(
                        hintText: "Type message...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: sendMessage,
                  child: const CircleAvatar(
                    backgroundColor: Color(0xff2260FF),
                    child:
                    Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          if (showEmoji)
            SizedBox(
              height: 300,
              child: EmojiPicker(
                textEditingController: messageController,
                config: const Config(),
              ),
            ),
        ],
      ),
    );
  }
}