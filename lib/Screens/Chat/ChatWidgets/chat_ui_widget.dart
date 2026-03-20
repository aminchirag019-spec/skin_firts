import 'dart:io';
import 'package:flutter/material.dart';

class ChatUiWidget {
  static Widget chatRow({
    required bool isMe,
    required dynamic data,
  }) {
    return Row(
      mainAxisAlignment:
      isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isMe)
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue.shade100,
              child: Icon(
                Icons.local_hospital,
                size: 18,
                color:  Color(0xff2260FF),
              ),
            ),
          ),

        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isMe ?  Color(0xff2260FF) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 5),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data.msg != null)
                  Text(
                    data.msg ?? "",
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black,
                      fontSize: 15,
                    ),
                  ),

                if (data.imagePath != null && data.imagePath!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Image.file(
                      File(data.imagePath!),
                      height: 120,
                    ),
                  ),

                if (data.filePath != null && data.filePath!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                         Icon(Icons.insert_drive_file, size: 18),
                         SizedBox(width: 5),
                        Text(
                          data.filePath!.split('/').last,
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                 SizedBox(height: 5),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      data.time,
                      style: TextStyle(
                        fontSize: 10,
                        color: isMe ? Colors.white70 : Colors.grey,
                      ),
                    ),
                     SizedBox(width: 5),
                    if (isMe)
                      Icon(
                        Icons.done_all,
                        size: 16,
                        color: data.isRead
                            ? Colors.lightBlueAccent
                            : Colors.white70,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),

        if (isMe)
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey.shade300,
              child: const Icon(
                Icons.person,
                size: 18,
                color: Colors.black54,
              ),
            ),
          ),
      ],
    );
  }
}