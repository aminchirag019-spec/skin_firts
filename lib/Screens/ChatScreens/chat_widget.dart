import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skin_firts/Network/translation_repository.dart';

import '../../Bloc/ChatBloc/chat_bloc.dart';
import '../../Bloc/ChatBloc/chat_event.dart';
import '../../Data/chat_model.dart';
import '../../Global/enums.dart';
import '../../Utilities/media_query.dart';

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
            leading: const Icon(Icons.camera_alt),
            title: const Text("Camera"),
            onTap: () {
              Navigator.pop(context);
              pickFromCamera(context, receiverId);
            },
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text("Gallery"),
            onTap: () {
              Navigator.pop(context);
              pickFromGallery(context, receiverId);
            },
          ),
          ListTile(
            leading: const Icon(Icons.insert_drive_file),
            title: const Text("File"),
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
    required String svgPath,
  double? width,
  double? height,
  double? imgHeight,
  double? imgWidth,
  Color? color,
      Color? imgColor
}) {
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: width ?? AppSize.width(context) * 0.030,
      vertical: height ?? AppSize.height(context) * 0.005,
    ),
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    child: SvgPicture.asset(svgPath, height: imgHeight, width: imgWidth,color: imgColor,),
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

class DynamicTranslatedText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;

  const DynamicTranslatedText({
    super.key,
    required this.text,
    this.style,
    this.maxLines,
    this.overflow,
  });

  @override
  State<DynamicTranslatedText> createState() => _DynamicTranslatedTextState();
}

class _DynamicTranslatedTextState extends State<DynamicTranslatedText> {
  String? translatedText;
  String? lastLocale;

  @override
  void didUpdateWidget(covariant DynamicTranslatedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _translateText();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentLocale = Localizations.localeOf(context).languageCode;
    if (lastLocale != currentLocale) {
      lastLocale = currentLocale;
      _translateText();
    }
  }

  Future<void> _translateText() async {
    if (lastLocale == 'en' || widget.text.isEmpty) {
      if (mounted) setState(() => translatedText = widget.text);
      return;
    }

    final result = await TranslationService.translate(
      widget.text,
      lastLocale!,
    );
    if (mounted) setState(() => translatedText = result);
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      translatedText ?? widget.text,
      style: widget.style,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
    );
  }
}
