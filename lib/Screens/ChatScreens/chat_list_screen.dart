import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Bloc/AuthBloc/auth_bloc.dart';
import 'package:skin_firts/Helper/app_localizations.dart';

import '../../Bloc/ChatBloc/chat_bloc.dart';
import '../../Bloc/ChatBloc/chat_state.dart';
import '../../Router/router_class.dart';
import '../../Utilities/colors.dart';
import 'chat_widget.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(LoadChatListEvent());
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (didPop) return;
            context.go(RouterName.profileScreen.path);
          },
          child: Scaffold(
            backgroundColor: const Color(0xffF8F9FE),
            body: state.role == null
                ? const Center(child: CircularProgressIndicator())
                : SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Custom App Bar
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildCircleButton(
                                icon: Icons.arrow_back_ios_new,
                                onTap: () => context.go(RouterName.profileScreen.path),
                              ),
                              Text(
                                state.role == "doctor" ? loc.translate("patients") : loc.translate("doctors"),
                                style: GoogleFonts.leagueSpartan(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black,
                                ),
                              ),
                              _buildCircleButton(
                                icon: Icons.more_vert,
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),

                        // Search Bar
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: loc.translate("searchConversations"),
                                hintStyle: TextStyle(color: AppColors.grey.withOpacity(0.7)),
                                prefixIcon: const Icon(Icons.search, color: AppColors.darkPurple),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                          child: Text(
                            loc.translate("recentChats"),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.grey,
                            ),
                          ),
                        ),

                        // Chat List
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            itemCount: state.role == "user"
                                ? state.doctors.length
                                : state.users.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final item = state.role == "user"
                                  ? state.doctors[index]
                                  : state.users[index];

                              return _buildChatItem(context, item);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildCircleButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Icon(icon, size: 20, color: AppColors.black),
      ),
    );
  }

  Widget _buildChatItem(BuildContext context, dynamic item) {
    return GestureDetector(
      onTap: () {
        context.push(
          RouterName.chatScreen.path,
          extra: {
            "receiverId": item.uid,
            "receiverName": item.name,
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.darkPurple, width: 2),
                  ),
                  child: const CircleAvatar(
                    radius: 28,
                    backgroundColor: Color(0xffF0F3FF),
                    child: Icon(Icons.person, size: 35, color: AppColors.darkPurple),
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    height: 14,
                    width: 14,
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DynamicTranslatedText(
                    text: item.name,
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item.email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.grey.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  "2:30 PM",
                  style: TextStyle(fontSize: 12, color: AppColors.grey),
                ),
                const SizedBox(height: 8),
                BlocBuilder<ChatBloc, ChatState>(
                  builder: (context, chatState) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.darkPurple,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "${chatState.chats?.length ?? 0}",
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
