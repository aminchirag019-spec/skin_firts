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
            previous.selectedMessages.length !=
                current.selectedMessages.length ||
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
        final singleSelected = selectedMessages.length == 1
            ? selectedMessages.first
            : null;
        final isMeSelected = singleSelected?.senderId == user!.uid;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value:  SystemUiOverlayStyle(
            statusBarColor: AppColors.darkPurple,
            statusBarIconBrightness: Brightness.light,
          ),
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
              backgroundColor: const Color(0xffF4F6FA),
              body: SafeArea(
                child: Column(
                  children: [
                    // Custom App Bar
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.darkPurple,
                            AppColors.darkPurple.withOpacity(0.85),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.darkPurple.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: isSelectionMode
                            ? AppSize.width(context) * 0.01
                            : AppSize.width(context) * 0.03,
                        vertical: AppSize.height(context) * 0.01,
                      ),
                      child: isSelectionMode
                          ? _buildSelectionHeader(
                              context,
                              selectedMessages,
                              singleSelected,
                              isMeSelected,
                              loc,
                              theme,
                            )
                          : _buildChatHeader(context),
                    ),

                    // Chat Messages
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          physics: const BouncingScrollPhysics(),
                          itemCount: chats.length,
                          itemBuilder: (context, index) {
                            final chat = chats[index];
                            final isMe = chat.senderId == user!.uid;
                            final isSelected = selectedMessages.any(
                              (m) => m.id == chat.id,
                            );
                            return _buildMessageItem(
                              context,
                              chat,
                              isMe,
                              isSelected,
                              isSelectionMode,
                            );
                          },
                        ),
                      ),
                    ),

                    if (state.replyMessage != null)
                      _buildReplyPreview(context, state.replyMessage!),

                    // Input Field Area
                    _buildInputArea(context, state, loc),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChatHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => context.go(RouterName.chatListScreen.path),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
        ),
        const CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white24,
          child: Icon(Icons.person, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DynamicTranslatedText(
                text: widget.receiverName ?? "",
                style: GoogleFonts.leagueSpartan(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Colors.greenAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "Online",
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 12,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.videocam_rounded,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.phone_rounded, color: Colors.white, size: 22),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildSelectionHeader(
    BuildContext context,
    List<ChatModel> selectedMessages,
    ChatModel? singleSelected,
    bool isMeSelected,
    AppLocalizations loc,
    dynamic theme,
  ) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 24),
          onPressed: () => context.read<ChatBloc>().add(UnSelectMessageEvent()),
        ),
        const SizedBox(width: 8),
        Text(
          "${selectedMessages.length}",
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        if (singleSelected != null) ...[
          IconButton(
            icon: const Icon(Icons.reply_rounded, color: Colors.white),
            onPressed: () {
              context.read<ChatBloc>().add(ReplyMessageEvent(singleSelected));
              context.read<ChatBloc>().add(UnSelectMessageEvent());
            },
          ),
          if (singleSelected.chatType == ChatType.text)
            IconButton(
              icon: const Icon(Icons.copy_rounded, color: Colors.white),
              onPressed: () {
                Clipboard.setData(
                  ClipboardData(text: singleSelected.message ?? ""),
                );
                context.read<ChatBloc>().add(UnSelectMessageEvent());
              },
            ),
          if (singleSelected.senderId == user!.uid &&
              singleSelected.chatType == ChatType.text)
            IconButton(
              icon: const Icon(Icons.edit_rounded, color: Colors.white),
              onPressed: () {
                context.read<ChatBloc>().add(StartEditingEvent(singleSelected));
                context.read<ChatBloc>().add(UnSelectMessageEvent());
              },
            ),
        ],
        IconButton(
          icon:  Icon(Icons.delete_outline_rounded, color: Colors.white),
          onPressed: () {
            final ids = selectedMessages.map((m) => m.id).toList();
            context.read<ChatBloc>().add(
              DeleteMessagesEvent(ids, widget.receiverId!),
            );
          },
        ),
        if (singleSelected != null)
          PopupMenuButton<String>(
            onOpened: () => _closeReactionPopup(),
            offset: const Offset(-10, 45),
            icon: const Icon(Icons.more_vert, color: Colors.white),
            color: Colors.white,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            onSelected: (value) {
              final bloc = context.read<ChatBloc>();
              switch (value) {
                case "Info":
                  break;
                case "Copy":
                  Clipboard.setData(
                    ClipboardData(text: singleSelected.message ?? ""),
                  );
                  break;
                case "Edit":
                  bloc.add(StartEditingEvent(singleSelected));
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
    );
  }

  Widget _buildMessageItem(
    BuildContext context,
    ChatModel chat,
    bool isMe,
    bool isSelected,
    bool isSelectionMode,
  ) {
    return Builder(
      builder: (itemContext) {
        return GestureDetector(
          onTap: () {
            if (isSelectionMode) {
              context.read<ChatBloc>().add(ToggleMessageSelection(chat));
            }
          },
          onLongPress: () {
            HapticFeedback.mediumImpact();
            _closeReactionPopup();
            FocusScope.of(context).unfocus();
            if (!isSelectionMode) {
              context.read<ChatBloc>().add(ToggleMessageSelection(chat));
              final renderBox = itemContext.findRenderObject() as RenderBox;
              final position = renderBox.localToGlobal(Offset.zero);
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
            direction: isMe
                ? DismissDirection.endToStart
                : DismissDirection.startToEnd,
            confirmDismiss: (_) async {
              if (isSelectionMode) return false;
              HapticFeedback.mediumImpact();
              context.read<ChatBloc>().add(ReplyMessageEvent(chat));
              return false;
            },
            background: Container(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Icon(
                Icons.reply_rounded,
                color: AppColors.darkPurple.withOpacity(0.4),
              ),
            ),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 3),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.darkPurple.withOpacity(0.08)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: messageBubble(chat, isMe),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputArea(
    BuildContext context,
    ChatState state,
    AppLocalizations loc,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () => showAttachmentOptions(context, widget.receiverId!),
            icon: const Icon(
              Icons.add_circle_outline_rounded,
              color: AppColors.darkPurple,
              size: 30,
            ),
            padding: const EdgeInsets.only(bottom: 4),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xffF1F3F8),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextFormField(
                controller: chatController,
                maxLines: 4,
                minLines: 1,
                style: GoogleFonts.leagueSpartan(fontSize: 16),
                decoration: InputDecoration(
                  hintText: state.editingMessage != null
                      ? loc.translate("editMessage")
                      : loc.translate("typeMessage"),
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 15,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: CircleAvatar(
              backgroundColor: AppColors.darkPurple,
              radius: 22,
              child: IconButton(
                onPressed: () {
                  final text = chatController.text.trim();
                  if (text.isEmpty) return;
                  if (state.editingMessage != null) {
                    final chatId = context
                        .read<ChatBloc>()
                        .chatRepository
                        .getChatId(user!.uid, widget.receiverId!);
                    context.read<ChatBloc>().add(
                      EditChatEvent(state.editingMessage!.id, text, chatId),
                    );
                    chatController.clear();
                  } else {
                    context.read<ChatBloc>().add(
                      SendTextMessage(
                        message: text,
                        receiverId: widget.receiverId!,
                        replyMessage:
                            state.replyMessage?.chatType == ChatType.text
                            ? state.replyMessage?.message
                            : (state.replyMessage?.chatType == ChatType.image
                                  ? "Photo"
                                  : state.replyMessage?.chatType ==
                                        ChatType.file
                                  ? "File"
                                  : null),
                        replySender: state.replyMessage?.senderId,
                      ),
                    );
                    chatController.clear();
                  }
                },
                icon: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReplyPreview(BuildContext context, ChatModel reply) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 4, 14, 0),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        border: Border(left: BorderSide(color: AppColors.darkPurple, width: 4)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  reply.senderId == user?.uid
                      ? "You"
                      : widget.receiverName ?? "",
                  style: GoogleFonts.leagueSpartan(
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkPurple,
                    fontSize: 14,
                  ),
                ),
                Text(
                  reply.chatType == ChatType.image
                      ? "Photo"
                      : reply.chatType == ChatType.file
                      ? "File"
                      : (reply.message ?? ""),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.leagueSpartan(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => context.read<ChatBloc>().add(CancelReply()),
            icon: const Icon(Icons.close_rounded, size: 20, color: Colors.grey),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget messageBubble(ChatModel chat, bool isMe) {
    return BlocBuilder<ChatBloc, ChatState>(
      buildWhen: (previous, current) {
        final wasSelected = previous.selectedMessages.any(
          (m) => m.id == chat.id,
        );
        final isNowSelected = current.selectedMessages.any(
          (m) => m.id == chat.id,
        );
        return wasSelected != isNowSelected;
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: AppSize.width(context) * 0.78,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? AppColors.darkPurple : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isMe ? 18 : 0),
                  bottomRight: Radius.circular(isMe ? 0 : 18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (chat.replyMessage != null &&
                      chat.replyMessage!.trim().isNotEmpty)
                    _buildReplyBox(chat, isMe),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      chat.chatType == ChatType.image
                          ? imageContent(chat, context)
                          : chat.chatType == ChatType.file
                          ? fileContent(chat, context)
                          : DynamicTranslatedText(
                              text: chat.message ?? "",
                              style: GoogleFonts.leagueSpartan(
                                fontSize: 16,
                                color: isMe ? Colors.white : Colors.black87,
                                height: 1.3,
                              ),
                            ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            formatTime(chat.timestamp),
                            style: GoogleFonts.leagueSpartan(
                              fontSize: 10,
                              color: isMe ? Colors.white70 : Colors.black45,
                            ),
                          ),
                          if (isMe) ...[
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.done_all_rounded,
                              size: 14,
                              color: Colors.white70,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (chat.reaction != null && chat.reaction!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                child: Wrap(
                  spacing: 4,
                  children: _buildReactionWidgets(chat.reaction),
                ),
              ),
            const SizedBox(height: 2),
          ],
        );
      },
    );
  }

  Widget _buildReplyBox(ChatModel chat, bool isMe) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isMe ? Colors.white.withOpacity(0.12) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border(
          left: BorderSide(
            color: isMe ? Colors.white54 : AppColors.darkPurple,
            width: 3,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            chat.replySender == user!.uid ? "You" : "User",
            style: GoogleFonts.leagueSpartan(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isMe ? Colors.white : AppColors.darkPurple,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            chat.replyMessage!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.leagueSpartan(
              fontSize: 12,
              color: isMe ? Colors.white70 : Colors.black54,
            ),
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
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Text(entry.key, style: const TextStyle(fontSize: 13)),
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
          Positioned.fill(
            child: GestureDetector(
              onTap: _closeReactionPopup,
              child: Container(color: Colors.black12.withOpacity(0.05)),
            ),
          ),
          Positioned(
            left: position.dx - 140,
            top: position.dy - 85,
            child: Material(
              color: Colors.transparent,
              child: TweenAnimationBuilder(
                duration: const Duration(milliseconds: 250),
                tween: Tween(begin: 0.0, end: 1.0),
                curve: Curves.easeOutBack,
                builder: (context, value, child) =>
                    Transform.scale(scale: value.toDouble(), child: child),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 20,
                        color: Colors.black26,
                        offset: Offset(0, 8),
                      ),
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
                              _closeReactionPopup();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text(
                                emoji,
                                style: const TextStyle(fontSize: 28),
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
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Text(
          title,
          style: GoogleFonts.leagueSpartan(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
