import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class MatchServices {

  static Future<void> swipeRight(String userId) async {
    String myId = "qb6OCKQa8pWd2ndmCq6BBE4HBJ23";
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
    print(await checkIfMatch(userId));
    // if (await checkIfMatch(userId)) {
    //   await uploadMatch(userId);
    // }
  }

  static Future<void> swipeLeft(String userId) async {
    String myId = "qb6OCKQa8pWd2ndmCq6BBE4HBJ23";
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
    String myId = "qb6OCKQa8pWd2ndmCq6BBE4HBJ23";
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

  static Future<void> uploadMatch(String userId) async {

  }

  static Future<void> getLocalUsers() async {

  }
}