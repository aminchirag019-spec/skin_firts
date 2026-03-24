const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendNotification = functions.firestore
  .document("chats/{chatId}/messages/{messageId}")
  .onCreate(async (snapshot, context) => {
    const data = snapshot.data();

    const payload = {
      notification: {
        title: data.senderId,
        body: data.message,
      },
    };

    return admin.messaging().sendToDevice(data.receiverToken, payload);
  });