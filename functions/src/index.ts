import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { createOrJoinMeeting, deleteMeeting, checkMeeting } from "./chime";
import { DataSnapshot } from "firebase-admin/database";

admin.initializeApp({
  projectId: "matchingapp-b77af",
});

const db = admin.firestore();
// eslint-disable-next-line max-len

const allUserNotification = async (title: string, body: string) => {
  const payload = {
    notification: {
      title: title,
      body: body,
    },
  };
  try {
    await admin.messaging().sendToTopic("", payload);
  } catch (error) {
    console.log("An Error Occured At AllUserNotifiction", allUserNotification);
  }
};

const sendPushNotification = async (
  title: string,
  body: string,
  selectedTab: string,
  token: string
) => {
  const payload = {
    token: token,
    data: {
      selectedTab: selectedTab,
    },
    notification: {
      title: title,
      body: body,
    },
    apns: {
      payload: {
        aps: {
          contentAvailable: true,
          sound: "default",
        },
      },
    },
  };
  try {
    const response = await admin.messaging().send(payload);
    console.log("Successfully sent message:", response);
  } catch (error) {
    console.log("Error sending message:", error);
  }
};

exports.monitorDeadCall = functions.pubsub
  .schedule("0 7 * * *")
  .timeZone("Asia/Tokyo")
  .onRun(async (context) => {
    const activeChannel = await admin
      .firestore()
      .collection("Channel")
      .where("callingNow", "==", true)
      .get();

    for (const doc of activeChannel.docs) {
      const channelId = doc.id;
      console.log("Active Call", channelId);
      checkMeeting(channelId, async (error) => {
        await handleCallEnded(channelId);
        await doc.ref.update({ callingNow: false });
      });
    }
    return null;
  });

exports.monitorOneToOneDeadCall = functions.pubsub
  .schedule("0 7 * * *")
  .timeZone("Asia/Tokyo")
  .onRun(async (context) => {
    const activeOneToOneCall = await admin
      .firestore()
      .collection("Chat")
      .where("channelId", "!=", "")
      .get();

    for (const doc of activeOneToOneCall.docs) {
      const channelId = doc.data().channelId;
      console.log("CHANNEL_ID", channelId);
      checkMeeting(channelId, async (error) => {
        await handleCallEnded(channelId);
        await doc.ref.update({ channelId: "" });
      });
    }
    return null;
  });

exports.monitorFinalDeadCallCheck = functions.pubsub
  .schedule("0 7 * * *")
  .timeZone("Asia/Tokyo")
  .onRun(async (context) => {
    const callingUserRef = await admin
      .firestore()
      .collection("User")
      .where("isCallingChannelId", "!=", "")
      .get();

    for (const doc of callingUserRef.docs) {
      const channelId = doc.data().isCallingChannelId;
      checkMeeting(channelId, async (error) => {
        await handleCallEnded(channelId);
      });
    }
    return null;
  });

exports.deleteUserAccount = functions.auth.user().onDelete(async (user) => {
  const userId = user.uid;

  const userDocRef = admin.firestore().collection("User").doc(userId);
  await userDocRef.delete();

  const postsSnapshot = await admin
    .firestore()
    .collection("Post")
    .where("posterUid", "==", userId)
    .get();

  const batch = admin.firestore().batch();
  postsSnapshot.docs.forEach((doc) => {
    batch.delete(doc.ref);
  });

  const friendSnapshot = await admin
    .firestore()
    .collection("User")
    .where("friendUids", "array-contains", userId)
    .get();

  friendSnapshot.docs.forEach((doc) => {
    batch.update(doc.ref, {
      friendUids: admin.firestore.FieldValue.arrayRemove(userId),
    });
  });

  const requestSnapshot = await admin
    .firestore()
    .collection("User")
    .where("friendRequestUids", "array-contains", userId)
    .get();

  requestSnapshot.docs.forEach((doc) => {
    batch.update(doc.ref, {
      friendRequestUids: admin.firestore.FieldValue.arrayRemove(userId),
    });
  });
  const requestedSnapshot = await admin
    .firestore()
    .collection("User")
    .where("friendRequestedUids", "array-contains", userId)
    .get();

  requestedSnapshot.docs.forEach((doc) => {
    batch.update(doc.ref, {
      friendRequestedUids: admin.firestore.FieldValue.arrayRemove(userId),
    });
  });

  const chatmateSnapshot = await admin.firestore().collection("User").get();
  chatmateSnapshot.docs.forEach((doc) => {
    const chatmateUser = doc.data().chatmateMapping || {};

    if (chatmateUser[userId]) {
      const chatRoomId = chatmateUser[userId];
      batch.delete(admin.firestore().collection("Chat").doc(chatRoomId));

      batch.update(doc.ref, {
        [`chatmateMapping.${userId}`]: admin.firestore.FieldValue.delete(),
      });
      batch.update(doc.ref, {
        [`chatLastMessageMapping.${chatRoomId}`]:
          admin.firestore.FieldValue.delete(),
      });
      batch.update(doc.ref, {
        [`chatLastTimestampMapping.${chatRoomId}`]:
          admin.firestore.FieldValue.delete(),
      });

      batch.update(doc.ref, {
        [`unreadMessageCount.${chatRoomId}`]:
          admin.firestore.FieldValue.delete(),
      });
    }
  });
  await batch.commit();
});

exports.updateUserNickName = functions.firestore
  .document("User/{userId}")
  .onUpdate(async (change, context) => {
    console.log(context.params);
    const userId = context.params.userId;
    const beforeData = change.before.data();
    const afterData = change.after.data();

    const beforeNickName = beforeData.nickname;
    const afterNickName = afterData.nickname;

    if (beforeNickName === afterNickName) {
      return null;
    }

    const postSnapshot = await admin
      .firestore()
      .collection("Post")
      .where("posterUid", "==", userId)
      .get();
    console.log(postSnapshot);
    const batch = admin.firestore().batch();
    postSnapshot.docs.forEach((doc) => {
      const post = doc.ref;
      batch.update(post, { posterNickName: afterNickName });
    });

    return batch.commit();
  });

exports.updateProfileImageInPost = functions.firestore
  .document("User/{userId}")
  .onUpdate(async (change, context) => {
    console.log(context.params);
    const userId = context.params.userId;
    const beforeData = change.before.data();
    const afterData = change.after.data();

    const beforeImageUrl = beforeData.profileImageURL;
    const afterImageUrl = afterData.profileImageURL;

    if (beforeImageUrl === afterImageUrl) {
      return null;
    }

    const postSnapshot = await admin
      .firestore()
      .collection("Post")
      .where("posterUid", "==", userId)
      .get();
    console.log(postSnapshot);
    const batch = admin.firestore().batch();
    postSnapshot.docs.forEach((doc) => {
      const post = doc.ref;
      batch.update(post, { posterProfileImageUrlString: afterImageUrl });
    });

    return batch.commit();
  });

exports.getAllPosts = functions.https.onCall(async (data, context) => {
  const lastDocId = data.lastDocId as string;

  let query = db.collection("Post").orderBy("createdAt").limit(20);

  if (lastDocId != "") {
    const lastDoc = db.collection("Post").doc(lastDocId);
    query = query.startAfter(lastDoc);
  }

  try {
    const posts: any[] = [];
    const querySnapshot = await query.get();
    querySnapshot.docs.forEach((doc) => {
      posts.push({ ...doc.data(), id: doc.id });
    });
    return { data: posts };
  } catch (error) {
    return { data: error };
  }
});

exports.createMessage = functions.firestore
  .document("Chat/{chatId}/Message/{messageId}")
  .onCreate(async (snapshot, context) => {
    const sendUserRef = snapshot.data();
    const type = sendUserRef["type"] as string;
    if (type == "Call") {
      try {
        await sendPushNotification(
          "着信",
          `${sendUserRef["fromUserNickname"]}さんがあなたと通話を始めました。`,
          "message",
          sendUserRef["toUserToken"]
        );
      } catch (error) {
        console.log("failure createOneToOneCallRoom", error);
      }
    } else if (type == "Message") {
      try {
        await sendPushNotification(
          `${sendUserRef["fromUserNickname"]}`,
          `${sendUserRef["message"]}`,
          "message",
          sendUserRef["toUserToken"]
        );
      } catch (error) {
        console.log("notificaton", error);
      }
    }
  });

exports.recieveComment = functions.firestore
  .document("User/{userId}/CommentNotice/{noticeId}")
  .onWrite(async (snapshot, context) => {
    const noticeRef = snapshot.after.data();
    // eslint-disable-next-line max-len
    if (noticeRef !== undefined) {
      const lastTriggerUserUid = noticeRef["lastTriggerUserUid"] as string;
      console.log("Mapping:", noticeRef["triggerUserNickNameMapping"]);
      await sendPushNotification(
        // eslint-disable-next-line max-len
        `${noticeRef["triggerUserNickNameMapping"][lastTriggerUserUid]}さんからのコメント`,
        `${noticeRef["lastTriggerCommentText"]}`,
        "notification",
        noticeRef["recieverUserFcmToken"]
      );
    }
  });

exports.receiveRequestOrApprove = functions.firestore
  .document("User/{userId}/RequestNotice/{noticeId}")
  .onCreate(async (snapshot, context) => {
    const noticeRef = snapshot.data();
    try {
      if (noticeRef["type"] === "Request") {
        await sendPushNotification(
          "フレンド申請のお知らせ",
          `${noticeRef["triggerUserNickName"]}さんからフレンド申請が来ました。`,
          "notification",
          noticeRef["recieverUserFcmToken"]
        );
      } else if (noticeRef["type"] === "Approve") {
        await sendPushNotification(
          "新しい友達",
          `${noticeRef["triggerUserNickName"]}さんと友達になりました。`,
          "notification",
          noticeRef["recieverUserFcmToken"]
        );
      }
    } catch (error) {
      console.log("failure createFriendRequest", error);
    }
  });

const handleCallEnded = async (channelId: string) => {
  const usersRef = admin.firestore().collection("User");
  const relatedUsers = await usersRef
    .where("isCallingChannelId", "==", channelId)
    .get();

  const batch = admin.firestore().batch();
  relatedUsers.docs.forEach((doc) => {
    const userRef = usersRef.doc(doc.id);
    batch.update(userRef, { isCallingChannelId: "" });
  });
  await batch.commit();
};
enum State {
  online = "online",
  offline = "offline",
}

interface StatusForDatabase {
  readonly state: State;
  readonly lastChanged: number;
}

exports.onStatusUpdated = functions.database
  .ref("/status/{userId}")
  .onUpdate(async (change, context) => {
    const eventStatus: StatusForDatabase = change.after.val();
    const eventStatusRef = change.after.ref;
    const userId = context.params.userId;

    const newStatusSnapshot: DataSnapshot = await eventStatusRef.once("value");
    const newStatus: StatusForDatabase = newStatusSnapshot.val();
    if (newStatus.lastChanged > eventStatus.lastChanged) {
      return;
    }
    const userRef = admin.firestore().collection("User").doc(userId);
    await userRef.set({ status: newStatus.state }, { merge: true });
  });

exports.createOrJoinMeeting = functions.https.onRequest(createOrJoinMeeting);
exports.deleteMeeting = functions.https.onRequest(deleteMeeting);
