import 'package:intl/intl.dart';

DateTime time = DateTime.timestamp();


String formatTime(DateTime time) {
  return DateFormat('hh:mm a').format(time); // 02:45 PM
}

String notificationFormatTime(DateTime time) {
  final now = DateTime.now();

  if (now.difference(time).inDays == 0) {
    return "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
  } else if (now.difference(time).inDays == 1) {
    return "Yesterday";
  } else {
    return "${time.day}/${time.month}/${time.year}";
  }
}
