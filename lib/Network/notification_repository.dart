import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Data/doctor_model.dart';

class NotificationRepository {
  Future<void> storeNotification({
    required NotificationModel notificationModel,
  }) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        print("Error: No authenticated user found for storing notification");
        return;
      }
      
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser.uid)
          .collection("notification")
          .add({
        "title": notificationModel.title,
        "body": notificationModel.body,
        "createdAt": DateTime.now().toIso8601String(),
      });
      print("Notification stored successfully for user: ${currentUser.uid}");
    } catch (e) {
      print("Error storing notification: $e");
      rethrow;
    }
  }

  Future<List<NotificationModel>> getNotifications({String? langCode}) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        print("User is null");
        return [];
      }
      final snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser.uid)
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
