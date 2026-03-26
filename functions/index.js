const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendChatNotification = functions.firestore
  .document("chats/{chatId}/messages/{messageId}")
  .onCreate(async (snap, context) => {
    const messageData = snap.data();

    const receiverId = messageData.receiverId;

    const userDoc = await admin.firestore()
      .collection("users")
      .doc(receiverId)
      .get();

    const fcmToken = userDoc.data().fcmToken;

    if (!fcmToken) return;

    const payload = {
      token: fcmToken,
      notification: {
        title: "New Message",
        body: messageData.message,
      },
      data: {
        senderId: messageData.senderId,
        type: "chat",
      }
    };

    try {
      await admin.messaging().send(payload);
      console.log("Notification sent");
    } catch (error) {
      console.error("Error sending notification:", error);
    }
  });