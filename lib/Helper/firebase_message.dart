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

    // ✅ Foreground notification listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 Foreground Message Received");

      // Check both notification and data payloads
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
    print("🔔 Translating: '$text' | Target: $langCode");

    if (langCode == 'en') return text;

    try {
      // 1. Try Local JSON (Fast & Offline)
      final jsonString = await rootBundle.loadString('assets/languages/$langCode.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);

      // Exact match check
      if (jsonMap.containsKey(text)) {
        String res = jsonMap[text].toString();
        print("✅ Local Match Found: $res");
        return res;
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
          print("✅ Prefix Match: $translatedPrefix$suffix");
          return "$translatedPrefix$suffix";
        }
      }

      // 2. Fallback to Online Translation Service for truly dynamic content
      print("🌐 Calling TranslationService for dynamic text...");
      String onlineRes = await TranslationService.translate(text, langCode);
      print("✅ Online Translation Success: $onlineRes");
      return onlineRes;

    } catch (e) {
      print("⚠️ Local translation error, trying online: $e");
      return await TranslationService.translate(text, langCode);
    }
  }

  static Future<void> showNotification(String title, String body) async {
    // Perform translation before showing
    String translatedTitle = await _translate(title);
    String translatedBody = await _translate(body);

    const androidDetails = AndroidNotificationDetails(
      'chat_channel',
      'Chat Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      translatedTitle,
      translatedBody,
      details,
    );
  }
}
