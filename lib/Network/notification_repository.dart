import 'package:cloud_firestore/cloud_firestore.dart';

import '../Data/doctor_model.dart';
import '../main.dart';

class NotificationRepository {


  Future<void> storeNotification({
    required NotificationModel notificationModel,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .collection("notification")
          .add({
        "title": notificationModel.title,
        "body": notificationModel.body,
        "createdAt": DateTime.now().toIso8601String(),
      });
      print("Notification stored successfully");
    } catch (e) {
      print("Error storing notification: $e");
    }
  }

  Future<List<NotificationModel>> getNotifications({String? langCode}) async {
    try {
      if (user == null) {
        print("User is null");
        return [];
      }
      final snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .collection("notification")
          .orderBy("createdAt", descending: true)
          .get();

      return snapshot.docs
          .map((doc) => NotificationModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print("Error fetching notifications: $e");
      return [];
    }
  }

}