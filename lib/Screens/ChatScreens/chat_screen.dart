import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Router/router_class.dart';
import 'package:skin_firts/Utilities/colors.dart';
import '../../Bloc/ChatBloc/chat_bloc.dart';
import '../../Bloc/ChatBloc/chat_event.dart';
import '../../Bloc/ChatBloc/chat_state.dart';
import '../../Data/chat_model.dart';
import '../../Global/enums.dart';
import '../../Utilities/media_query.dart';
import '../../Utilities/time_zones.dart';
import '../../main.dart';
import 'chat_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.receiverId,
    required this.receiverName,
  });

  final String? receiverId;
  final String? receiverName;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController chatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadMessageEvent(widget.receiverId!));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listenWhen: (previous, current) =>
          previous.editingMessage != current.editingMessage,
      listener: (context, state) {
        if (state.editingMessage != null) {
          chatController.text = state.editingMessage!.message ?? "";
          chatController.selection = TextSelection.fromPosition(
            TextPosition(offset: chatController.text.length),
          );
        } else {
          chatController.clear();
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(statusBarColor: Colors.white),
        child: WillPopScope(
          onWillPop: () async {
            context.go(RouterName.chatListScreen.path);
            return false;
          },
          child: Scaffold(
            backgroundColor: AppColors.white,
            body: SafeArea(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSize.width(context) * 0.064,
                          vertical: AppSize.height(context) * 0.025,
                        ),
                        color: Color(0xff2260FF),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.go(RouterName.chatListScreen.path);
                              },
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: AppSize.width(context) * 0.025),
                            Text(
                              widget.receiverName ?? "",
                              style: GoogleFonts.leagueSpartan(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: AppSize.width(context) * 0.06,
                              ),
                            ),
                            Spacer(),
                            chatBarIcons(
                              context,
                              image: AssetImage("assets/images/chat_phone.png"),
                              height: AppSize.height(context) * 0.015,
                              width: AppSize.width(context) * 0.015,
                              color: Colors.white,
                            ),
                            SizedBox(width: AppSize.width(context) * 0.025),
                            chatBarIcons(
                              context,
                              image: AssetImage("assets/images/video_call.png"),
                              height: AppSize.height(context) * 0.012,
                              width: AppSize.width(context) * 0.012,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: BlocBuilder<ChatBloc, ChatState>(
                          builder: (context, state) {
                            final chats = state.chats ?? [];

                            if (chats.isEmpty) {
                              return Center(child: Text("No messages yet"));
                            }

                            return ListView.builder(
                              reverse: true,
                              physics: BouncingScrollPhysics(),
                              itemCount: chats.length,
                              itemBuilder: (context, index) {
                                final chat = chats[index];
                                final isMe = chat.senderId == user!.uid;

                                return GestureDetector(
                                  onLongPress: () {
                                    if (isMe) {
                                      HapticFeedback.mediumImpact();
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return SafeArea(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [

                                                /// 🔥 QUICK REACTIONS
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      reactionItem("👍", chat),
                                                      reactionItem("❤️", chat),
                                                      reactionItem("😂", chat),
                                                      reactionItem("😮", chat),
                                                      reactionItem("😢", chat),

                                                      /// ➕ OPEN FULL PICKER
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(context);
                                                          showEmojiPicker(context, chat);
                                                        },
                                                        child: Text("+", style: TextStyle(fontSize: 22)),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                Divider(),

                                                /// 📝 OPTIONS
                                                ListTile(
                                                  leading: Icon(Icons.edit),
                                                  title: Text("Edit"),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    context.read<ChatBloc>().add(StartEditingEvent(chat));
                                                  },
                                                ),
                                                ListTile(
                                                  leading: Icon(Icons.copy),
                                                  title: Text("Copy"),
                                                  onTap: () {
                                                    Clipboard.setData(
                                                      ClipboardData(text: chat.message ?? ""),
                                                    );
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  },
                                  child: Dismissible(
                                    key: ValueKey(chat.id),
                                    direction: isMe
                                        ? DismissDirection.endToStart
                                        : DismissDirection.startToEnd,
                                    confirmDismiss: (direction) async {
                                      HapticFeedback.mediumImpact();
                                      context.read<ChatBloc>().add(
                                        ReplyMessageEvent(chat),
                                      );
                                      return false;
                                    },
                                    background: Container(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      color: Colors.green,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.reply,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            "Reply",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    child: Align(
                                      alignment: isMe
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: chat.chatType == ChatType.image
                                          ? imageMessage(chat, isMe)
                                          : chat.chatType == ChatType.file
                                          ? fileMessage(chat, isMe)
                                          : textMessage(chat, isMe)
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      if (state.replyMessage != null &&
                          (state.replyMessage!.message?.trim().isNotEmpty ??
                              false))
                        BlocBuilder<ChatBloc, ChatState>(
                          builder: (context, state) {
                            final reply = state.replyMessage!;
                            return Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 40,
                                    color: Color(0xff2260FF),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          reply.senderId == user?.uid
                                              ? "You"
                                              : widget.receiverName ?? "",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff2260FF),
                                          ),
                                        ),
                                        Text(
                                          reply.message ?? "",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),

                                  GestureDetector(
                                    onTap: () {
                                      context.read<ChatBloc>().add(
                                        CancelReply(),
                                      );
                                      FocusScope.of(context).unfocus();
                                    },
                                    child: Icon(Icons.close),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSize.width(context) * 0.054,
                          vertical: AppSize.height(context) * 0.020,
                        ),
                        color: Color(0xffCAD6FF),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showAttachmentOptions(context);
                              },
                              child: chatBarIcons(
                                context,
                                image: AssetImage(
                                  "assets/images/chat_document.png",
                                ),
                                imgHeight: AppSize.height(context) * 0.047,
                                width: AppSize.width(context) * 0.015,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: AppSize.width(context) * 0.013),
                            Expanded(
                              child: TextFormField(
                                controller: chatController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText:
                                      context
                                              .watch<ChatBloc>()
                                              .state
                                              .editingMessage !=
                                          null
                                      ? "Edit message..."
                                      : "Type a message",
                                  hintStyle: GoogleFonts.leagueSpartan(
                                    color: const Color(0xff2260FF),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(width: AppSize.width(context) * 0.013),

                            BlocBuilder<ChatBloc, ChatState>(
                              builder: (context, state) {
                                return GestureDetector(
                                  onTap: () {
                                    final text = chatController.text.trim();
                                    if (text.isEmpty) return;

                                    final editing = state.editingMessage;
                                    final reply = state.replyMessage;

                                    if (editing != null) {
                                      final chatId = context
                                          .read<ChatBloc>()
                                          .chatRepository
                                          .getChatId(
                                            user!.uid,
                                            widget.receiverId!,
                                          );

                                      context.read<ChatBloc>().add(
                                        EditChatEvent(chatId, editing.id, text),
                                      );
                                    } else {
                                      context.read<ChatBloc>().add(
                                        SendTextMessage(
                                          message: text,
                                          receiverId: widget.receiverId!,
                                          replyMessage: reply?.message,
                                          replySender: reply?.senderId,
                                        ),
                                      );
                                    }
                                    chatController.clear();
                                  },
                                  child: chatBarIcons(
                                    context,
                                    image: AssetImage(
                                      "assets/images/send_icon.png",
                                    ),
                                    imgHeight: AppSize.height(context) * 0.023,
                                    color: Color(0xff2260FF),
                                    height: AppSize.height(context) * 0.018,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget textMessage(ChatModel chat, bool isMe) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        print("UI REACTION: ${chat.reaction}");
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          child: Row(
            mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMe) ...[
                CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.blue,
                  backgroundImage: AssetImage("assets/images/user_icon.png"),
                ),
                const SizedBox(width: 6),
              ],
              if (chat.replyMessage != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isMe ? AppColors.lightPurple : Colors.grey.shade300,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(14),
                      topRight: const Radius.circular(14),
                      bottomLeft: Radius.circular(isMe ? 14 : 0),
                      bottomRight: Radius.circular(isMe ? 0 : 14),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (chat.replyMessage != null &&
                          (chat.replyMessage!.trim().isNotEmpty))
                        Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(6),
                            border: Border(
                              left: BorderSide(
                                color: isMe ? Colors.blue : Colors.green,
                                width: 3,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                chat.replySender == user!.uid ? "You" : "User",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isMe ? Colors.blue : Colors.green,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                chat.replyMessage ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      Text(
                        chat.message ?? '',
                        style: const TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            formatTime(chat.timestamp),
                            style: const TextStyle(fontSize: 10, color: Colors.black54),
                          ),
                        ],
                      ),
                      Wrap(
                        spacing: 6,
                        children: _buildReactionWidgets(chat.reaction),
                      ),
                    ],
                  ),
                ),

              if (isMe) ...[
                const SizedBox(width: 6),
                CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.blue,
                  backgroundImage: AssetImage("assets/images/heart.png"),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
  List<Widget> _buildReactionWidgets(Map<String, List<String>>? reactions) {
    if (reactions == null || reactions.isEmpty) return [];

    final Map<String, int> count = {};


    for (var userReactions in reactions.values) {
      for (var emoji in userReactions) {
        count[emoji] = (count[emoji] ?? 0) + 1;
      }
    }

    return count.entries.map((entry) {
      return Container(
        margin: const EdgeInsets.only(right: 4),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(entry.key),
            const SizedBox(width: 3),
            Text(entry.value.toString()),
          ],
        ),
      );
    }).toList();
  }
  Widget reactionItem(String emoji, ChatModel chat) {
    return GestureDetector(
      onTap: () {
        print("REACTION CLICKED: $emoji for ${chat.id}");
        final chatId = context
            .read<ChatBloc>()
            .chatRepository
            .getChatId(user?.uid ?? "", widget.receiverId!);

        context.read<ChatBloc>().add(
          AddReactionEvent(chatId, chat.id, emoji),
        );

        Navigator.pop(context);
      },
      child: Text(emoji, style: TextStyle(fontSize: 22)),
    );
  }
  void showEmojiPicker(BuildContext context, ChatModel chat) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return SizedBox(
          height: 320,
          child: EmojiPicker(
            onEmojiSelected: (category, emoji) {
              final chatId = context
                  .read<ChatBloc>()
                  .chatRepository
                  .getChatId(user?.uid ?? "", widget.receiverId!);

              context.read<ChatBloc>().add(
                AddReactionEvent(chatId, chat.id, emoji.emoji),
              );

              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}

void chatOptions() {}
