import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'chatRoom.dart';

class FriendList extends StatelessWidget {
  final String uid;

  const FriendList({Key? key, required this.uid}) : super(key: key);

  // Remove target from the friend List
  Future<void> removeTargetFromFriendList(String targetUid) {
    return FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .collection("friends")
        .where('uid', isEqualTo: targetUid)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  // Remove target from a list of people who i swipe right on
  Future<void> removeTargetFromSwipeRightMe(String targetUid) {
    return FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .collection("swipeRightMe")
        .doc(targetUid)
        .delete();
  }

  // Remove the current user from the target's swipeRightThem list
  Future<void> removeMyselfFromTargetSwipeRgihtThemList(String targetUid) {
    return FirebaseFirestore.instance
        .collection('user')
        .doc(targetUid)
        .collection("swipeRightThem")
        .doc(uid)
        .delete();
  }

  Future<void> addTargetOnBlockList(String targetUid) {
    return FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .collection("blockList")
        .doc(targetUid)
        .set({
      'id': targetUid,
    });
  }

  Future<void> fileAComplaint(String targetUid) {
    return FirebaseFirestore.instance
        .collection('deviantBehaviorComplaints')
        .add({
      'originator': uid,
      'target': targetUid,
    }).then((value) {
      print("Complaints Added");
    }).catchError((error) => print("Failed to add complaints: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('user')
            .doc(uid)
            .collection("friends")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong"),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 23, 29, 43)),
            ));
          }
          // print(snapshot.data!.docs.length);
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isEmpty) {
              return Container(
                child: const Center(
                  child: Text(
                    "Get swiping and find your component!",
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            } else {
              // if (snapshot.data!.data().isEmpty) {
              //   return Container();
              // }
              List<Map<String, dynamic>> data =
                  (snapshot.data!.docs.map((DocumentSnapshot document) {
                return document.data()! as Map<String, dynamic>;
              }).toList(growable: true));
              print(data.length);

              // print(data['friends'][0]['roomID'].toString().length);
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () => {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return SafeArea(
                                    child: ChatRoom(
                                        roomID: data[index]['roomID'],
                                        uid: uid,
                                        name: data[index]['name']));
                              }))
                            },
                        onLongPressDown: (DetailsElement) => {
                              showMenu<String>(
                                context: context,
                                position: RelativeRect.fromLTRB(
                                    DetailsElement.localPosition.dx / 2,
                                    DetailsElement.globalPosition.dy,
                                    0.0,
                                    0.0), //position where you want to show the menu on screen
                                items: [
                                  PopupMenuItem<String>(
                                      // unfriend means this person can still sometimes appear in your swiping page.
                                      // You can swipe right again to add him back
                                      child: const Text('Unfriend'),
                                      onTap: () {
                                        print("Unfriending");
                                        removeTargetFromFriendList(
                                            data[index]['uid']);
                                        removeTargetFromSwipeRightMe(
                                            data[index]['uid']);
                                        removeMyselfFromTargetSwipeRgihtThemList(
                                            data[index]['uid']);
                                        // remove the current user's id from the other guy's swipeRight List
                                      }),
                                  PopupMenuItem<String>(
                                      // You will never see this person again ever
                                      child: const Text('Block'),
                                      onTap: () {
                                        print("Blocking");
                                        removeTargetFromFriendList(
                                            data[index]['uid']);
                                        removeTargetFromSwipeRightMe(
                                            data[index]['uid']);
                                        removeMyselfFromTargetSwipeRgihtThemList(
                                            data[index]['uid']);
                                        addTargetOnBlockList(
                                            data[index]['uid']);
                                      }),
                                  PopupMenuItem<String>(
                                      // No only you will never see this person again, You will file a complain with this person's behavior to the app owner.
                                      child:
                                          const Text('Report Deviant Behavior'),
                                      onTap: () {
                                        print("Reporting");
                                        removeTargetFromFriendList(
                                            data[index]['uid']);
                                        removeTargetFromSwipeRightMe(
                                            data[index]['uid']);
                                        removeMyselfFromTargetSwipeRgihtThemList(
                                            data[index]['uid']);
                                        addTargetOnBlockList(
                                            data[index]['uid']);
                                        fileAComplaint(data[index]['uid']);
                                      }),
                                ],
                                elevation: 8.0,
                              )
                            },
                        child: ListTile(
                          title: Text(data[index]['name']),
                          iconColor: const Color.fromARGB(255, 248, 244, 14),
                          leading: const Icon(
                            Icons.audiotrack,
                            color: Colors.green,
                            size: 30.0,
                          ), // a placeholder for user avator
                          subtitle: LastMessage(roomID: data[index]['roomID']),
                        ));
                  });
            }
          }
          return Container();
        });
  }
}

class LastMessage extends StatelessWidget {
  final String roomID;

  const LastMessage({Key? key, required this.roomID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .doc(roomID)
            .collection('list')
            .orderBy('createdAt', descending: true)
            .limit(1)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          print(roomID);
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 23, 29, 43))));
          }

          print("The length of collection is ${snapshot.data!.docs.length}");
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isEmpty) {
              print("Have no contact before");
              return Container();
            } else {
              Map<String, dynamic> data =
                  snapshot.data!.docs[0].data()! as Map<String, dynamic>;

              return Text(data['text'], overflow: TextOverflow.ellipsis);
            }
          }
          return Container();
        });
  }
}
