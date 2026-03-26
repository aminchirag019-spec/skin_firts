import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skin_firts/Utilities/colors.dart';

import '../../Bloc/ChatBloc/chat_bloc.dart';
import '../../Bloc/ChatBloc/chat_event.dart';
import '../../Data/chat_model.dart';
import '../../Global/enums.dart';
import '../../Utilities/media_query.dart';
import '../../Utilities/time_zones.dart';
import '../../main.dart';

final ImagePicker picker = ImagePicker();

Future<void> sendMedia({
  required BuildContext context,
  required String path,
  required ChatType type,
  required String receiverId,
}) async {
  if (type == ChatType.image) {
    context.read<ChatBloc>().add(
      SendImageMessage(imagePath: path, receiverId: receiverId),
    );
  } else if (type == ChatType.file) {
    context.read<ChatBloc>().add(
      SendFileMessage(filePath: path, receiverId: receiverId),
    );
  }
}

Future<void> pickFromGallery(BuildContext context, String receiverId) async {
  final List<XFile> images = await picker.pickMultiImage();
  if (images.isNotEmpty) {
    for (var image in images) {
      sendMedia(context: context, path: image.path, type: ChatType.image, receiverId: receiverId);
    }
  }
}

Future<void> pickFromCamera(BuildContext context, String receiverId) async {
  final image = await picker.pickImage(source: ImageSource.camera);
  if (image != null) {
    sendMedia(context: context, path: image.path, type: ChatType.image, receiverId: receiverId);
  }
}

Future<void> pickFile(BuildContext context, String receiverId) async {
  final result = await FilePicker.platform.pickFiles(allowMultiple: true);
  if (result != null) {
    for (var file in result.files) {
      if (file.path != null) {
        sendMedia(context: context, path: file.path!, type: ChatType.file, receiverId: receiverId);
      }
    }
  }
}

void showAttachmentOptions(BuildContext context, String receiverId) {
  showModalBottomSheet(
    context: context,
    builder: (_) {
      return Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text("Camera"),
            onTap: () {
              Navigator.pop(context);
              pickFromCamera(context, receiverId);
            },
          ),
          ListTile(
            leading: Icon(Icons.image),
            title: Text("Gallery"),
            onTap: () {
              Navigator.pop(context);
              pickFromGallery(context, receiverId);
            },
          ),
          ListTile(
            leading: Icon(Icons.insert_drive_file),
            title: Text("File"),
            onTap: () {
              Navigator.pop(context);
              pickFile(context, receiverId);
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
      horizontal: width ?? AppSize.width(context) * 0.030,
      vertical: height ?? AppSize.height(context) * 0.005,
    ),
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    child: Image(image: image, height: imgHeight, width: imgWidth),
  );
}

Widget fileContent(ChatModel chat, BuildContext context) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Icon(Icons.insert_drive_file, size: 30, color: Colors.blueGrey),
      const SizedBox(width: 10),
      Flexible(
        child: Text(
          chat.filePath.split('/').last,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.leagueSpartan(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ],
  );
}

Widget imageContent(ChatModel chat, BuildContext context) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: AppSize.width(context) * 0.6,
        maxHeight: AppSize.height(context) * 0.4,
      ),
      child: Image.file(
        File(chat.filePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Image.network(
          chat.filePath,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 100),
        ),
      ),
    ),
  );
}
