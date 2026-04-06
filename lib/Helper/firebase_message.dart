import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:skin_firts/Helper/sharedpref_helper.dart';
import 'package:skin_firts/Network/translation_repository.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(settings);

    // ✅ Request Permission for Android 13+
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // ✅ Create Notification Channel for Android
    const androidChannel = AndroidNotificationChannel(
      'chat_channel',
      'Chat Notifications',
      description: 'Used for chat and system notifications',
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    // ✅ Foreground notification listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 Foreground Message Received");

      String title = message.notification?.title ?? message.data['title'] ?? "";
      String body = message.notification?.body ?? message.data['body'] ?? "";

      if (title.isNotEmpty || body.isNotEmpty) {
        showNotification(title, body);
      }
    });
  }

  /// Translates text using Local JSON or Online Translation Service as fallback
  static Future<String> _translate(String text) async {
    if (text.isEmpty) return text;

    final langCode = await SharedPrefsHelper.getLanguage() ?? 'en';
    if (langCode == 'en') return text;

    try {
      // 1. Try Local JSON (Fast & Offline)
      final jsonString = await rootBundle.loadString('assets/languages/$langCode.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);

      if (jsonMap.containsKey(text)) {
        return jsonMap[text].toString();
      }

      // Prefix match check for semi-dynamic messages
      final prefixes = {
        "You have a new message from ": "new_message_prefix",
        "You successfully added a ": "add_doctor_prefix",
      };

      for (var entry in prefixes.entries) {
        if (text.startsWith(entry.key)) {
          String suffix = text.substring(entry.key.length);
          String translatedPrefix = jsonMap[entry.value]?.toString() ?? entry.key;
          return "$translatedPrefix$suffix";
        }
      }

      // 2. Fallback to Online Translation Service (with timeout)
      return await TranslationService.translate(text, langCode)
          .timeout(const Duration(seconds: 3), onTimeout: () => text);

    } catch (e) {
      print("⚠️ Translation error: $e");
      return text;
    }
  }

  static Future<void> showNotification(String title, String body) async {
    try {
      // Perform translation before showing
      String translatedTitle = await _translate(title);
      String translatedBody = await _translate(body);

      const androidDetails = AndroidNotificationDetails(
        'chat_channel',
        'Chat Notifications',
        channelDescription: 'Used for chat and system notifications',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
      );

      const details = NotificationDetails(android: androidDetails);

      await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        translatedTitle,
        translatedBody,
        details,
      );
      print("✅ Notification shown: $translatedTitle");
    } catch (e) {
      print("❌ Error showing notification: $e");
    }
  }
}
