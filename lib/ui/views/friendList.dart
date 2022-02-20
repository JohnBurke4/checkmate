import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:math';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import 'chatRoom.dart';

class FriendList extends StatelessWidget {
  FriendList({Key? key}) : super(key: key);

  late final Stream<DocumentSnapshot> _path = FirebaseFirestore.instance
      .collection('user')
      .doc("qb6OCKQa8pWd2ndmCq6BBE4HBJ23")
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: _path,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            print(data['friends'][0]['roomID'].toString().length);
            return ListView.builder(
                itemCount: data['friends'].length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(data['friends'][index]['name']),
                    iconColor: const Color.fromARGB(255, 248, 244, 14),
                    leading: const Icon(
                      Icons.audiotrack,
                      color: Colors.green,
                      size: 30.0,
                    ), // a placeholder for user avator
                    subtitle:
                        LastMessage(roomID: data['friends'][index]['roomID']),
                    onTap: () => {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return SafeArea(
                            child: MessageFetching(
                              roomID:  data['friends'][index]['roomID'],
                          // chatRoomReference: FirebaseFirestore.instance
                          //     .collection('messages')
                          //     .doc(data['friends'][index]['roomID'])
                          //     .collection('list')
                          //     .orderBy('createdAt')
                          //     .snapshots(),
                        ));
                      }))
                    },
                  );
                });
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
            .doc("FBCJhytvnLyweXAYaLC8")
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
