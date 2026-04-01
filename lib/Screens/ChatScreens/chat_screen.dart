import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Helper/app_localizations.dart';
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
  OverlayEntry? _reactionOverlay;

  @override
  void dispose() {
    _reactionOverlay?.remove();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadMessageEvent(widget.receiverId!));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final loc = AppLocalizations.of(context)!;

    return BlocConsumer<ChatBloc, ChatState>(
      listenWhen: (previous, current) =>
          previous.editingMessage != current.editingMessage ||
          previous.isSelectedMessage != current.isSelectedMessage ||
          previous.selectedMessages.length != current.selectedMessages.length ||
          previous.replyMessage != current.replyMessage,
      buildWhen: (previous, current) {
        return previous.chats != current.chats ||
            previous.isSelectedMessage != current.isSelectedMessage ||
            previous.selectedMessages.length != current.selectedMessages.length ||
            previous.replyMessage != current.replyMessage ||
            previous.editingMessage != current.editingMessage;
      },
      listener: (context, state) {
        if (!state.isSelectedMessage || state.selectedMessages.length > 1) {
          _closeReactionPopup();
        }

        if (state.editingMessage != null) {
          chatController.text = state.editingMessage!.message ?? "";
          chatController.selection = TextSelection.fromPosition(
            TextPosition(offset: chatController.text.length),
          );
        }
      },
      builder: (context, state) {
        final chats = state.chats ?? [];
        final selectedMessages = state.selectedMessages;
        final isSelectionMode = state.isSelectedMessage;
        final singleSelected = selectedMessages.length == 1 ? selectedMessages.first : null;
        final isMeSelected = singleSelected?.senderId == user!.uid;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(statusBarColor: colorScheme.primary),
          child: WillPopScope(
            onWillPop: () async {
              if (isSelectionMode) {
                context.read<ChatBloc>().add(UnSelectMessageEvent());
                return false;
              }
              context.go(RouterName.chatListScreen.path);
              return false;
            },
            child: Scaffold(
              body: SafeArea(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSelectionMode
                            ? AppSize.width(context) * 0.01
                            : AppSize.width(context) * 0.064,
                        vertical: isSelectionMode
                            ? AppSize.height(context) * 0.010
                            : AppSize.height(context) * 0.015,
                      ),
                      color: colorScheme.primary,
                      child: isSelectionMode
                          ? Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                  onPressed: () => context.read<ChatBloc>().add(
                                        UnSelectMessageEvent(),
                                      ),
                                ),
                                Text(
                                  "${selectedMessages.length}",
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Spacer(),
                                if (singleSelected != null) ...[
                                  IconButton(
                                    icon: const Icon(
                                      Icons.reply,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      context.read<ChatBloc>().add(
                                            ReplyMessageEvent(singleSelected),
                                          );
                                      context.read<ChatBloc>().add(
                                            UnSelectMessageEvent(),
                                          );
                                    },
                                  ),
                                  if (singleSelected.chatType == ChatType.text)
                                    IconButton(
                                      icon: const Icon(
                                        Icons.copy,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        Clipboard.setData(
                                          ClipboardData(
                                            text: singleSelected.message ?? "",
                                          ),
                                        );
                                        context.read<ChatBloc>().add(
                                              UnSelectMessageEvent(),
                                            );
                                      },
                                    ),
                                  if (singleSelected.senderId == user!.uid &&
                                      singleSelected.chatType == ChatType.text)
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        context.read<ChatBloc>().add(
                                              StartEditingEvent(singleSelected),
                                            );
                                        context.read<ChatBloc>().add(
                                              UnSelectMessageEvent(),
                                            );
                                      },
                                    ),
                                ],
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    final ids = selectedMessages.map((m) => m.id).toList();
                                    context.read<ChatBloc>().add(
                                          DeleteMessagesEvent(
                                            ids,
                                            widget.receiverId!,
                                          ),
                                        );
                                  },
                                ),
                                if (singleSelected != null)
                                  PopupMenuButton<String>(
                                    onOpened: () => _closeReactionPopup(),
                                    offset: const Offset(-10, 45),
                                    icon: const Icon(
                                      Icons.more_vert,
                                      color: Colors.white,
                                    ),
                                    color: theme.cardColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    onSelected: (value) {
                                      final bloc = context.read<ChatBloc>();
                                      switch (value) {
                                        case "Info":
                                          break;
                                        case "Copy":
                                          Clipboard.setData(
                                            ClipboardData(
                                              text: singleSelected.message ?? "",
                                            ),
                                          );
                                          break;
                                        case "Edit":
                                          bloc.add(
                                            StartEditingEvent(singleSelected),
                                          );
                                          FocusScope.of(context).requestFocus();
                                          break;
                                        case "Pin":
                                          break;
                                      }
                                      bloc.add(UnSelectMessageEvent());
                                    },
                                    itemBuilder: (context) => [
                                      _buildMenuItem(context, loc.translate("verifySecurityCode")),
                                      _buildMenuItem(context, "Info"),
                                      _buildMenuItem(context, loc.translate("copy")),
                                      if (isMeSelected) _buildMenuItem(context, loc.translate("edit")),
                                      _buildMenuItem(context, loc.translate("pin")),
                                    ],
                                  ),
                              ],
                            )
                          : Row(
                              children: [
                                GestureDetector(
                                  onTap: () => context.go(
                                    RouterName.chatListScreen.path,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: AppSize.width(context) * 0.025),
                                DynamicTranslatedText(
                                  text: widget.receiverName ?? "",
                                  style: GoogleFonts.leagueSpartan(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Spacer(),
                                chatBarIcons(
                                  svgPath: "assets/images/audio.svg.svg",
                                  context,
                                  height: AppSize.height(context) * 0.015,
                                  width: AppSize.width(context) * 0.015,
                                  color: Colors.white,
                                  imgColor: AppColors.darkPurple
                                ),
                                SizedBox(width: AppSize.width(context) * 0.025),
                                chatBarIcons(
                                  context,
                                  svgPath: "assets/images/video.svg.svg",
                                  height: AppSize.height(context) * 0.012,
                                  width: AppSize.width(context) * 0.012,
                                  color: Colors.white,
                                  imgColor: AppColors.darkPurple
                                ),
                              ],
                            ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (isSelectionMode) {
                            context.read<ChatBloc>().add(
                                  UnSelectMessageEvent(),
                                );
                          }
                          FocusScope.of(context).unfocus();
                        },
                        child: ListView.builder(
                          reverse: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: chats.length,
                          itemBuilder: (context, index) {
                            final chat = chats[index];
                            final isMe = chat.senderId == user!.uid;
                            final isSelected = selectedMessages.any(
                              (m) => m.id == chat.id,
                            );
                            return Builder(
                              builder: (itemContext) {
                                return GestureDetector(
                                  onTap: () {
                                    if (isSelectionMode) {
                                      context.read<ChatBloc>().add(
                                            ToggleMessageSelection(chat),
                                          );
                                    }
                                  },
                                  onLongPress: () {
                                    HapticFeedback.mediumImpact();
                                    _closeReactionPopup();
                                    FocusScope.of(context).unfocus();
                                    if (!isSelectionMode) {
                                      context.read<ChatBloc>().add(
                                            ToggleMessageSelection(chat),
                                          );
                                      final renderBox = itemContext.findRenderObject() as RenderBox;
                                      final position = renderBox.localToGlobal(
                                        Offset.zero,
                                      );
                                      showReactionPopup(
                                        context,
                                        Offset(
                                          position.dx + renderBox.size.width / 2,
                                          position.dy + 50,
                                        ),
                                        chat,
                                      );
                                    }
                                  },
                                  child: Dismissible(
                                    key: ValueKey(chat.id),
                                    direction: isMe ? DismissDirection.endToStart : DismissDirection.startToEnd,
                                    confirmDismiss: (_) async {
                                      if (isSelectionMode) return false;
                                      HapticFeedback.mediumImpact();
                                      context.read<ChatBloc>().add(
                                            ReplyMessageEvent(chat),
                                          );
                                      return false;
                                    },
                                    background: Container(
                                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      child: Icon(
                                        Icons.reply,
                                        color: theme.disabledColor,
                                      ),
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      color: isSelected ? colorScheme.primary.withOpacity(0.15) : Colors.transparent,
                                      child: Align(
                                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                                        child: messageBubble(chat, isMe),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    if (state.replyMessage != null) _buildReplyPreview(context, state.replyMessage!),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSize.width(context) * 0.054,
                        vertical: AppSize.height(context) * 0.020,
                      ),
                      color: colorScheme.secondary,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => showAttachmentOptions(
                              context,
                              widget.receiverId!,
                            ),
                            child: chatBarIcons(
                              context,
                              svgPath: "assets/images/chat_document.svg.svg",
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
                                hintText: state.editingMessage != null ? "${loc.translate("editMessage")}" : loc.translate("typeMessage"),
                                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.primary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: AppSize.width(context) * 0.013),
                          GestureDetector(
                            onTap: () {
                              final text = chatController.text.trim();
                              if (text.isEmpty) return;
                              if (state.editingMessage != null) {
                                final chatId = context.read<ChatBloc>().chatRepository.getChatId(user!.uid, widget.receiverId!);
                                context.read<ChatBloc>().add(
                                      EditChatEvent(
                                        state.editingMessage!.id,
                                        text,
                                        chatId,
                                      ),
                                    );
                                chatController.clear();
                              } else {
                                context.read<ChatBloc>().add(
                                      SendTextMessage(
                                        message: text,
                                        receiverId: widget.receiverId!,
                                        replyMessage: state.replyMessage?.chatType == ChatType.text
                                            ? state.replyMessage?.message
                                            : (state.replyMessage?.chatType == ChatType.image
                                                ? "Photo"
                                                : state.replyMessage?.chatType == ChatType.file
                                                    ? "File"
                                                    : null),
                                        replySender: state.replyMessage?.senderId,
                                      ),
                                    );
                                chatController.clear();
                              }
                            },
                            child: chatBarIcons(
                              context,
                             svgPath: "assets/images/send.svg.svg",
                              imgHeight: AppSize.height(context) * 0.023,
                              color: colorScheme.primary,
                              height: AppSize.height(context) * 0.018,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReplyPreview(BuildContext context, ChatModel reply) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(width: 4, height: 40, color: colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reply.senderId == user?.uid ? "You" : widget.receiverName ?? "",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                Text(
                  reply.chatType == ChatType.image
                      ? "Photo"
                      : reply.chatType == ChatType.file
                          ? "File"
                          : (reply.message ?? ""),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => context.read<ChatBloc>().add(CancelReply()),
            child: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  Widget messageBubble(ChatModel chat, bool isMe) {
    return BlocBuilder<ChatBloc, ChatState>(
      buildWhen: (previous, current) {
        final wasSelected = previous.selectedMessages.any((m) => m.id == chat.id);
        final isNowSelected = current.selectedMessages.any((m) => m.id == chat.id);
        return wasSelected != isNowSelected;
      },
      builder: (context, state) {
        final theme = Theme.of(context);
        return Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 3),
            Container(
              constraints: BoxConstraints(maxWidth: AppSize.width(context) * 0.75),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isMe ? AppColors.lightPurple : Colors.grey.shade300,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isMe ? 14 : 0),
                  topRight: Radius.circular(isMe ? 0 : 14),
                  bottomLeft: const Radius.circular(14),
                  bottomRight: const Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (chat.replyMessage != null && chat.replyMessage!.trim().isNotEmpty) _buildReplyBox(chat, isMe),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: chat.chatType == ChatType.image
                            ? imageContent(chat, context)
                            : chat.chatType == ChatType.file
                                ? fileContent(chat, context)
                                : DynamicTranslatedText(
                                    text: chat.message ?? "",
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontSize: 16,
                                    ),
                                  ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formatTime(chat.timestamp),
                        style: theme.textTheme.labelSmall?.copyWith(color: Colors.black54,height: 0.5),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (chat.reaction != null && chat.reaction!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Wrap(
                  spacing: 4,
                  children: _buildReactionWidgets(chat.reaction),
                ),
              ),
            const SizedBox(height: 3),
          ],
        );
      },
    );
  }

  Widget _buildReplyBox(ChatModel chat, bool isMe) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(6),
        border: Border(
          left: BorderSide(color: isMe ? Colors.blue : Colors.green, width: 3),
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
            chat.replyMessage!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildReactionWidgets(Map<String, String>? reactions) {
    if (reactions == null || reactions.isEmpty) return [];
    final Map<String, int> count = {};
    for (var emoji in reactions.values) {
      count[emoji] = (count[emoji] ?? 0) + 1;
    }
    return count.entries.map((entry) {
      return Container(
        margin: const EdgeInsets.only(right: 4),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [Text(entry.key)]),
      );
    }).toList();
  }

  void showReactionPopup(
    BuildContext context,
    Offset position,
    ChatModel chat,
  ) {
    _closeReactionPopup();
    final bloc = context.read<ChatBloc>();
    final chatId = bloc.chatRepository.getChatId(user!.uid, widget.receiverId!);
    _reactionOverlay = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned(
            left: position.dx - 140,
            top: position.dy - 80,
            child: Material(
              color: Colors.transparent,
              child: TweenAnimationBuilder(
                duration: const Duration(milliseconds: 150),
                tween: Tween(begin: 0.8, end: 1.0),
                builder: (context, value, child) => Transform.scale(scale: value.toDouble(), child: child),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(blurRadius: 12, color: Colors.black26),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: ["👍", "❤️", "😂", "😮", "😢", "🙏"]
                        .map(
                          (emoji) => GestureDetector(
                            onTap: () {
                              bloc.add(
                                AddReactionEvent(chatId, chat.id, emoji),
                              );
                              bloc.add(UnSelectMessageEvent());
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              child: Text(
                                emoji,
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_reactionOverlay!);
  }

  void _closeReactionPopup() {
    _reactionOverlay?.remove();
    _reactionOverlay = null;
  }

  PopupMenuItem<String> _buildMenuItem(BuildContext context, String title) {
    return PopupMenuItem<String>(
      value: title,
      padding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
