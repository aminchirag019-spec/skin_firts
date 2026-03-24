import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Router/router_class.dart';
import '../../Bloc/ChatBloc/chat_bloc.dart';
import '../../Bloc/ChatBloc/chat_event.dart';
import '../../Bloc/ChatBloc/chat_state.dart';
import '../../Utilities/media_query.dart';
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
  TextEditingController chatController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<ChatBloc>().add(LoadMessageEvent(widget.receiverId!));
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(statusBarColor: Colors.white),
      child: WillPopScope(
        onWillPop: () async {
          context.go(RouterName.chatListScreen.path);
          return false;
        },
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.width(context) * 0.064, // 25
                    vertical: AppSize.height(context) * 0.025, // 20
                  ),
                  decoration: BoxDecoration(color: Color(0xff2260FF)),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.go(RouterName.chatListScreen.path);
                        },
                        child: Icon(Icons.arrow_back_ios, color: Colors.white),
                      ),
                      SizedBox(width: AppSize.width(context) * 0.025), // 12
                      Text(
                        widget.receiverName ?? "",
                        style: GoogleFonts.leagueSpartan(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: AppSize.width(context) * 0.06, // 18
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
                      SizedBox(width: AppSize.width(context) * 0.025), // 12
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
                BlocConsumer<ChatBloc, ChatState>(
                  listener: (context, state) {},
                  buildWhen: (previous, current) {
                    return previous.chats != current.chats;
                  },
                  builder: (context, state) {
                    return Expanded(child: chatView());
                  },
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.width(context) * 0.054, // 25
                    vertical: AppSize.height(context) * 0.020, // 20
                  ),
                  decoration: BoxDecoration(color: Color(0xffCAD6FF)),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showAttachmentOptions(context);
                        },
                        child: chatBarIcons(
                          context,
                          image: AssetImage("assets/images/chat_document.png"),
                          imgHeight: AppSize.height(context) * 0.047,
                          width: AppSize.width(context) * 0.015,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: AppSize.width(context) * 0.013), // 12
                      SizedBox(
                        width: AppSize.width(context) * 0.6,
                        height: AppSize.height(context) * 0.06,
                        child: TextFormField(
                          controller: chatController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Type a message",
                            hintStyle: GoogleFonts.leagueSpartan(
                              color: Color(0xff2260FF),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: AppSize.width(context) * 0.013),
                      BlocConsumer<ChatBloc, ChatState>(
                        listener: (context, state) {},
                        builder: (context, state) {
                          return GestureDetector(
                            onTap: () {
                             if (chatController.text.trim().isEmpty) return;
                              final text = chatController.text.trim();
                              context.read<ChatBloc>().add(
                                SendTextMessage(
                                  message: text,
                                  receiverId: widget.receiverId!,
                                ),
                              );
                              chatController.clear();
                            },
                            child: chatBarIcons(
                              context,
                              image: AssetImage("assets/images/send_icon.png"),
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
            ),
          ),
        ),
      ),
    );
  }
}
