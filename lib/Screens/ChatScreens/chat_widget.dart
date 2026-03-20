import 'dart:io';
import 'dart:math' as MainAxisSize;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../Bloc/ChatBloc/chat_bloc.dart';
import '../../Bloc/ChatBloc/chat_event.dart';
import '../../Bloc/ChatBloc/chat_state.dart';
import '../../Global/enums.dart';
import '../../Utilities/media_query.dart';
import '../../Utilities/time_zones.dart';
import '../../main.dart';

final ImagePicker picker = ImagePicker();

Future<void> sendMedia({
  required BuildContext context,
  required String path,
  required ChatType type,
}) async {
  if (type == ChatType.image) {
    context.read<ChatBloc>().add(SendImageMessage(path));
  } else if (type == ChatType.file) {
    context.read<ChatBloc>().add(SendFileMessage(path));
  }
}

Future<void> pickFromGallery(BuildContext context) async {
  final image = await picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    sendMedia(context: context, path: image.path, type: ChatType.image);
  }
}

Future<void> pickFromCamera(BuildContext context) async {
  final image = await picker.pickImage(source: ImageSource.camera);

  if (image != null) {
    sendMedia(context: context, path: image.path, type: ChatType.image);
  }
}

Future<void> pickFile(BuildContext context) async {
  final result = await FilePicker.platform.pickFiles();

  if (result != null) {
    final path = result.files.single.name;
    sendMedia(context: context, path: path, type: ChatType.file);
  }
}

void showAttachmentOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (_) {
      return Column(
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text("Camera"),
            onTap: () {
              Navigator.pop(context);
              pickFromCamera(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.image),
            title: Text("Gallery"),
            onTap: () {
              Navigator.pop(context);
              pickFromGallery(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.insert_drive_file),
            title: Text("File"),
            onTap: () {
              Navigator.pop(context);
              pickFile(context);
            },
          ),
        ],
      );
    },
  );
}

Widget chatBarIcons(
  BuildContext context, {
  required ImageProvider image,
  double? width,
  double? height,
  double? imgHeight,
  double? imgWidth,
  Color? color,
}) {
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: width ?? AppSize.width(context) * 0.030, // 12
      vertical: height ?? AppSize.height(context) * 0.005, // 5
    ),
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    child: Image(image: image, height: imgHeight, width: imgWidth),
  );
}

Widget chatView() {
  return BlocBuilder<ChatBloc, ChatState>(
    builder: (context, state) {
      return ListView.builder(
        itemBuilder: (context, index) {
          final chat = state.chats![index];
          final isMe = chat.senderId == user!.uid;
          return Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: chat.chatType == ChatType.image
                ? Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(chat.filePath),
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : chat.chatType == ChatType.file
                ? Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(12),
                    constraints: BoxConstraints(maxWidth: 250),
                    decoration: BoxDecoration(
                      color: isMe ? Color(0xFFCAD6FF) : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.insert_drive_file,
                          size: 30,
                          color: Colors.black54,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                chat.filePath ?? "File",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text(
                                formatTime(chat.timestamp),
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.download),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    decoration: BoxDecoration(
                      color: isMe ? Color(0xFFCAD6FF) : Colors.grey.shade300,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: Radius.circular(isMe ? 20 : 0),
                        bottomRight: Radius.circular(isMe ? 0 : 20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chat.message ?? "",
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        SizedBox(height: 2),
                        Text(
                          formatTime(chat.timestamp),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        },
        itemCount: state.chats!.length,
      );
    },
  );
}
