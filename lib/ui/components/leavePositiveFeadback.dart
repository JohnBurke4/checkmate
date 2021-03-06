import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/cupertino.dart';

// This class is mainly used to let current user leave feadbacks for other users

class LeavePositiveFeadback extends StatelessWidget {
  final String uid;
  final String friendUid;
  // the value of editable depends on whether the current user is viewing his own score or others'.

  const LeavePositiveFeadback({
    Key? key,
    required this.uid,
    required this.friendUid,
  }) : super(key: key);

  Future<void> updatePositiveFeedback(String feadback) async {
    bool containCurrentUid = await FirebaseFirestore.instance
        .collection("user")
        .doc(friendUid)
        .collection(feadback)
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        return true;
      } else {
        return false;
      }
    });
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('user').doc(friendUid);

    FirebaseFirestore.instance
        .runTransaction((transaction) async {
          // Get the document
          DocumentSnapshot snapshot = await transaction.get(documentReference);

          if (!snapshot.exists) {
            throw Exception("User does not exist!");
          }

          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

          int feadbackCount = data[feadback];

          if (containCurrentUid) {
            // Perform an update on the document
            transaction
                .update(documentReference, {feadback: feadbackCount - 1});
          } else {
            // Perform an update on the document
            transaction
                .update(documentReference, {feadback: feadbackCount + 1});
          }
        })
        .then((value) => print("$feadback count updated to $value"))
        .catchError(
            (error) => print("Failed to update user $feadback: $error"));

    if (containCurrentUid) {
      FirebaseFirestore.instance
          .collection('user')
          .doc(friendUid)
          .collection(feadback)
          .where('id', isEqualTo: uid)
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.delete();
        }
      });
    } else {
      FirebaseFirestore.instance
          .collection('user')
          .doc(friendUid)
          .collection(feadback)
          .doc(uid)
          .set({
        'id': uid,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user')
            .doc(friendUid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 23, 29, 43))));
          }

          if (snapshot.hasData) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Row(
              children: <Widget>[
                Expanded(
                    child: Row(children: <Widget>[
                  GestureDetector(
                      child: const Icon(
                        Icons.tag_faces_sharp,
                        size: 30.0,
                        color: Colors.blue,
                      ),
                      onTapUp: (_) async {
                        updatePositiveFeedback("friendliness");
                      },
                      onLongPressStart: (DetailsElement) {
                        showMenu<String>(
                            context: context,
                            position: RelativeRect.fromLTRB(
                                DetailsElement.globalPosition.dx,
                                DetailsElement.globalPosition.dy,
                                0.0,
                                0.0), //position where you want to show the menu on screen
                            items: [
                              const PopupMenuItem<String>(
                                child: Text(
                                    'Number of unique commendations received for being Friendly'),
                              )
                            ]);
                      }),
                  Text(
                    data['friendliness'].toString(),
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
                ])),
                Expanded(
                    child: Row(children: <Widget>[
                  GestureDetector(
                      child: const Icon(
                        Icons.access_time,
                        size: 30.0,
                        color: Colors.blue,
                      ),
                      onTapUp: (_) async {
                        updatePositiveFeedback("punctuality");
                      },
                      onLongPressStart: (DetailsElement) {
                        showMenu<String>(
                            context: context,
                            position: RelativeRect.fromLTRB(
                                DetailsElement.globalPosition.dx,
                                DetailsElement.globalPosition.dy,
                                0.0,
                                0.0), //position where you want to show the menu on screen
                            items: [
                              const PopupMenuItem<String>(
                                child: Text(
                                    'Number of unique commendations received for being Punctual'),
                              )
                            ]);
                      }),
                  Text(
                    data['punctuality'].toString(),
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
                ])),
                Expanded(
                    child: Row(children: <Widget>[
                  GestureDetector(
                      child: const Icon(
                        Icons.calendar_today_rounded,
                        size: 30.0,
                        color: Colors.blue,
                      ),
                      onTapUp: (_) async {
                        updatePositiveFeedback("hangOutAgain");
                      },
                      onLongPressStart: (DetailsElement) {
                        showMenu<String>(
                            context: context,
                            position: RelativeRect.fromLTRB(
                                DetailsElement.globalPosition.dx,
                                DetailsElement.globalPosition.dy,
                                0.0,
                                0.0), //position where you want to show the menu on screen
                            items: [
                              const PopupMenuItem<String>(
                                child: Text(
                                    'Number of unique people want to hang out with this dude again'),
                              )
                            ]);
                      }),
                  Text(
                    data['hangOutAgain'].toString(),
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
                ])),
              ],
            );
          }
          return Container();
        });
  }
  // Widget build(BuildContext context) {

  // }
}
