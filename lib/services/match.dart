
import 'package:checkmate/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../ui/views/chatRoom.dart';

class MatchServices {

  static Future<void> swipeRight(String? userId, String username, context) async {
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
    }
  }

  static Future<void> swipeLeft(String? userId) async {
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

  static Future<bool> checkIfMatch(String? userId) async {
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

  static Future<void> uploadMatch(String? userId, String username) async {
    String? myId = FirebaseAuth.instance.currentUser?.uid;
    String? name = DefaultFirebaseOptions.user?.name;
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
        .collection("friends")
        .add(
      chatRoomMe
    );

    FirebaseFirestore.instance
        .collection("user")
        .doc(userId).
    collection("friends")
        .add(
        chatRoomThem
    );

    FirebaseFirestore.instance
        .collection("messages")
        .doc(chatId)
        .set({
      "created": true
    });






  }

  static Future<void> getLocalUsers() async {

  }

  static void getMatches(context) async {
    String? myId = FirebaseAuth.instance.currentUser?.uid;
    bool hasLoaded = false;
    FirebaseFirestore.instance
    .collection("user")
    .doc(myId)
    .collection("friends")
    .snapshots().listen((event) {
      if (event.docChanges.isNotEmpty){
        if (hasLoaded){
          for (var element in event.docChanges) {
            if (element.type == DocumentChangeType.added){
              var doc = element.doc.data();
              if (doc != null && doc.containsKey("name")){
                showMatch(context, doc);
              }
            }


          }
        }
        hasLoaded = true;
      }
    });
  }

  static void showMatch(context, data){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Match'),
            content: Text('Congrats you matched with ' + data["name"] + "!"),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK')),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return SafeArea(
                            child: ChatRoom(
                                roomID: data["roomID"],
                                uid: data["uid"]));
                      }));
                },
                child: const Text('Send a Message'),
              )
            ],
          );
        });
  }
}
