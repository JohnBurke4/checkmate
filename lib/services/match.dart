
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class MatchServices {

  static Future<void> swipeRight(String userId, String username, context) async {
    String? myId = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance
        .collection("user")
        .doc(myId)
        .collection("swipeRightMe")
        .doc(userId)
        .set({
          'id': userId
        });

    await FirebaseFirestore.instance
        .collection("user")
        .doc(userId)
        .collection("swipeRightThem")
        .doc(myId)
        .set({
      'id': myId
    });
    if (await checkIfMatch(userId)) {
      await uploadMatch(userId, username);

      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Match'),
              content: Text('Congrats its a match!'),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK')),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Send a Message'),
                )
              ],
            );
          });
    }
  }

  static Future<void> swipeLeft(String userId) async {
    String? myId = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance
        .collection("user")
        .doc(myId)
        .collection("swipeLeftMe")
        .doc(userId)
        .set({
      'id': userId
    });

    await FirebaseFirestore.instance
        .collection("user")
        .doc(userId)
        .collection("swipeLeftThem")
        .doc(myId)
        .set({
      'id': myId
    });
  }

  static Future<bool> checkIfMatch(String userId) async {
    String? myId = FirebaseAuth.instance.currentUser?.uid;
    return FirebaseFirestore.instance
        .collection("user")
        .doc(myId)
        .collection("swipeRightThem")
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            return true;
      } else {
            return false;
          }
    });
  }

  static Future<void> uploadMatch(String userId, String username) async {
    String? myId = FirebaseAuth.instance.currentUser?.uid;
    String name = "My Name";
    var uuid = const Uuid();
    String chatId = uuid.v4();

    var chatRoomMe = {
      "name": username,
      "roomID": chatId,
      "uid": userId
    };

    var chatRoomThem = {
      "name": name,
      "roomID": chatId,
      "uid": myId
    };

    FirebaseFirestore.instance
        .collection("user")
        .doc(myId)
        .update({
      'friends': FieldValue.arrayUnion([chatRoomMe])
    });

    FirebaseFirestore.instance
        .collection("user")
        .doc(userId)
        .update({
      'friends': FieldValue.arrayUnion([chatRoomThem])
    });

    FirebaseFirestore.instance
        .collection("messages")
        .doc(chatId)
        .set({
      "created": true
    });






  }

  static Future<void> getLocalUsers() async {

  }
}