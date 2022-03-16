const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });


exports.messageNotification = functions.https.onCall(async (data, context) => {
    const uid = context.auth.uid;
    const message = data.message;
    const destinationId = data.destinationId;

    let username = await admin.firestore().collection('user').doc(uid).get().then((doc) => {
        if (doc.exists) {
            return doc.data()['username'];
        }
    });

    let deviceToken = await admin.firestore().collection('user').doc(destinationId).get().then((doc) => {
        if (doc.exists) {
            return doc.data()['deviceToken'];
        }
    });

    if (deviceToken == null){
        return;
    }

    await admin.messaging().sendToDevice(deviceToken,
        {notification: {
            title: `${username} messaged you.`,
            body: message,
        },
      });
});

exports.matchNotification = functions.https.onCall(async (data, context) => {
    const uid = context.auth.uid;
    const destinationId = data.destinationId;

    let username = await admin.firestore().collection('user').doc(uid).get().then((doc) => {
        if (doc.exists) {
            return doc.data()['username'];
        }
    });

    let deviceToken = await admin.firestore().collection('user').doc(destinationId).get().then((doc) => {
        if (doc.exists) {
            return doc.data()['deviceToken'];
        }
    });

    if (deviceToken == null){
        return;
    }

    await admin.messaging().sendToDevice(deviceToken,
        {notification: {
          title: "New Match!",
          body: `${username} matched with you!`,
        },
      });

    



    
});