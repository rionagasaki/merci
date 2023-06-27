import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp({
  projectId: "matchingapp-b77af",
});

// eslint-disable-next-line max-len
const sendMultiPushNotification = async (
  title: string,
  body: string,
  tokens: string[]
) => {
  // eslint-disable-next-line max-len
  const payload = {
    tokens: tokens,
    notification: {
      title: title,
      body: body,
    },
  };
  try {
    const response = await admin.messaging()
      .sendEachForMulticast(payload, false);
    console.log("Successfully sent message:", response);
  } catch (error) {
    console.log("Error sending message:", error);
  }
};

const sendPushNotification = async (
  title: string,
  body: string,
  token: string
) => {
  // eslint-disable-next-line max-len
  const payload = {
    token: token,
    notification: {
      title: title,
      body: body,
    },
  };
  try {
    const response = await admin.messaging()
      .send(payload);
    console.log("Successfully sent message:", response);
  } catch (error) {
    console.log("Error sending message:", error);
  }
};

exports.createMessage = functions.firestore
  .document("Chat/{chatId}/Message/{messageId}")
  .onCreate(async (snap, context) => {
    const sendUserRef = snap.data();
    // eslint-disable-next-line max-len
    sendMultiPushNotification(
      sendUserRef["sendUserNickname"],
      sendUserRef["message"],
      sendUserRef["notificationUserTokens"]
    );
  });

exports.createFriendRequest = functions.firestore
  .document("User/{userId}")
  .onUpdate(async (change, context) => {
    const newValue = change.after.data();
    const previousValue = change.before.data();
    console.log("new", newValue);
    console.log("old", previousValue);
    if (previousValue["requestedUid"] !== newValue["requestedUid"]) {
      sendPushNotification(
        "フレンド申請が届きました！",
        `${newValue["nickname"]}からフレンド申請が届きました！アプリを開いて確認してみよう。`,
        newValue["fcmToken"]
      );
    }
  });

exports.createPairRequest = functions.firestore
  .document("User/{userId}")
  .onUpdate(async (change, context) => {
    const newValue = change.after.data();
    const previousValue = change.before.data();

    if (previousValue["pairRequestedUid"] !== newValue["pairRequestedUids"]) {
      sendPushNotification(
        `${newValue["nickname"]}さんからペア申請が届きました！`,
        `${newValue["nickname"]}からペア申請が届きました！アプリを開いて確認してみよう。`,
        newValue["fcmToken"]
      );
    }
  });

exports.approveFriendRequest = functions.firestore
  .document("User/{userId}")
  .onUpdate(async (change, context) => {
    const newValue = change.after.data();
    const previousValue = change.before.data();

    if (previousValue["pairRequestedUid"] !== newValue["pairRequestedUids"]) {
      sendPushNotification(
        `${newValue["nickname"]}さんからペア申請が届きました！`,
        `${newValue["nickname"]}からペア申請が届きました！アプリを開いて確認してみよう。`,
        newValue["fcmToken"]
      );
    }
  });

