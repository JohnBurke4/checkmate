import 'package:checkmate/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:checkmate/models/user.dart' as customUser;

import '../ui/views/chatRoom.dart';
import '../location.dart';

class MatchServices {
  static Future<void> swipeRight(
      String? userId, String username, context) async {
    String? myId = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance
        .collection("user")
        .doc(myId)
        .collection("swipeRightMe")
        .doc(userId)
        .set({'id': userId});

    await FirebaseFirestore.instance
        .collection("user")
        .doc(userId)
        .collection("swipeRightThem")
        .doc(myId)
        .set({'id': myId});
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
        .set({'id': userId});

    await FirebaseFirestore.instance
        .collection("user")
        .doc(userId)
        .collection("swipeLeftThem")
        .doc(myId)
        .set({'id': myId});
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

    var chatRoomMe = {"name": username, "roomID": chatId, "uid": userId};

    var chatRoomThem = {"name": name, "roomID": chatId, "uid": myId};

    FirebaseFirestore.instance
        .collection("user")
        .doc(myId)
        .collection("friends")
        .add(chatRoomMe);

    FirebaseFirestore.instance
        .collection("user")
        .doc(userId)
        .collection("friends")
        .add(chatRoomThem);

    FirebaseFirestore.instance
        .collection("messages")
        .doc(chatId)
        .set({"created": true});
  }

  static Future<List<customUser.User>> getLocalUsers(double range) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    List<String> localUserId = [];
    UserLocation ul = UserLocation();
    await ul
        .loadOtherUsersLocation(userId)
        .then((otherUsersLocationList) async {
      UserCoordinate currentUser = await ul.loadCurrentUserLocation(userId);
      for (UserCoordinate next in otherUsersLocationList) {
        double d = ul.calculateDistance(currentUser, next);
        print("distance between " +
            currentUser.userId.toString() +
            " and " +
            next.userId.toString() +
            " is " +
            d.toString() +
            "km.");
        if (d < range) {
          localUserId.add(next.userId.toString());
        }
      }
    });
    print("Local Users: " + localUserId.length.toString());
    return getUsersFromIds(localUserId);
  }

  static Future<List<customUser.User>> getUsersFromIds(List<String> ids) async {
    String? myId = FirebaseAuth.instance.currentUser?.uid;
    List<customUser.User> users = List.empty(growable: true);

    List<String> swipedLeft = await FirebaseFirestore.instance
        .collection("user")
        .doc(myId)
        .collection("swipeLeftMe")
        .get()
        .then((value) => value.docs.map((e) => e.id).toList());

    List<String> swipedRight = await FirebaseFirestore.instance
        .collection("user")
        .doc(myId)
        .collection("swipeRightMe")
        .get()
        .then((value) => value.docs.map((e) => e.id).toList());

    // add by SiKai Lu
    // fetch a list of blocked user id
    // remove user whoever in that list
    List<String> blockList = await FirebaseFirestore.instance
        .collection("user")
        .doc(myId)
        .collection("blockList")
        .get()
        .then((value) => value.docs.map((e) => e.id).toList());

    print(blockList.toString());
    ids.removeWhere((element) =>
        swipedRight.contains(element) ||
        swipedLeft.contains(element) ||
        blockList.contains(element));

    var tenIds = (ids..shuffle()).take(10);

    if (tenIds.isEmpty) {
      return users;
    }

    users = await FirebaseFirestore.instance
        .collection("user")
        .where('uid', whereIn: tenIds.toList())
        .get()
        .then((value) =>
            value.docs.map((e) => customUser.User.fromJSON(e.data())).toList());

    users.removeWhere((element) => element.imagePaths.isEmpty);

    return users;
  }

  static void getMatches(context) async {
    String? myId = FirebaseAuth.instance.currentUser?.uid;
    bool hasLoaded = false;
    FirebaseFirestore.instance
        .collection("user")
        .doc(myId)
        .collection("friends")
        .snapshots()
        .listen((event) {
      if (event.docChanges.isNotEmpty) {
        if (hasLoaded) {
          for (var element in event.docChanges) {
            if (element.type == DocumentChangeType.added) {
              var doc = element.doc.data();
              if (doc != null && doc.containsKey("name")) {
                showMatch(context, doc, myId);
              }
            }
          }
        }
      }
      hasLoaded = true;
    });
  }

  static void showMatch(context, data, myId) {
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SafeArea(
                        child: ChatRoom(
                            roomID: data["roomID"],
                            uid: myId,
                            name: data['name'],
                            friendUid: data['uid']));
                  }));
                },
                child: const Text('Send a Message'),
              )
            ],
          );
        });
  }
}
