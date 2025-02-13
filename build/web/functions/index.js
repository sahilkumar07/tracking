/* eslint-disable max-len */
const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

// Trigger when a document in 'users/{userId}' is updated
exports.sendApplicationUpdateNotification = functions.firestore
    .document("users/{userId}")
    .onUpdate(async (change, context) => {
    // Get data before and after the update
      const beforeData = change.before.data();
      const afterData = change.after.data();
      if (beforeData.application_status !== afterData.application_status) {
        const userId = context.params.userId;
        // eslint-disable-next-line max-len
        const userDoc = await admin.firestore().collection("users").doc(userId).get();
        const fcmToken = userDoc.data().fcm_token;

        if (fcmToken) {
        // Set up the payload for the push notification
          const payload = {
            notification: {
              title: "Application Status Update",
              body: `Your application status is now: ${afterData.application_status}`,
            },
            token: fcmToken, // Send to the user's FCM token
          };

          // Send the push notification using Firebase Cloud Messaging
          try {
            await admin.messaging().send(payload);
            console.log("Notification sent successfully.");
          } catch (error) {
            console.error("Error sending notification:", error);
          }
        }
      }
    });
