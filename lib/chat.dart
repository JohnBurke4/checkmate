import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:math';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  String chatRoomId = "FBCJhytvnLyweXAYaLC8";
  //String userId = "qb6OCKQa8pWd2ndmCq6BBE4HBJ23";
  String userId = 'vcCXf1YI85Nq5Op2PWMOMbu3DAv1';
  List<types.Message> _messages = [];

  late final _user = types.User(id: userId);
  late Stream test = FirebaseFirestore.instance
      .collection('messages')
      .doc(chatRoomId)
      .collection("list")
      .snapshots();

  StreamSubscription<QuerySnapshot>? messageListener;

  String randomString() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  Future<void> fetchPastMessages() async {
    try {
      await FirebaseFirestore.instance
          .collection('messages')
          .doc(chatRoomId)
          .collection("list")
          .orderBy('createdAt')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          final textMessage = types.TextMessage(
            author: types.User(id: doc["author"]),
            createdAt: doc["createdAt"],
            id: doc["id"],
            text: doc["text"],
          );
          _addMessage(textMessage);

          //print(doc["text"]);
        });
      });
    } catch (e) {
      print(e);
    }
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );

    _addMessage(textMessage);

    FirebaseFirestore.instance
        .collection('messages')
        .doc(chatRoomId)
        .collection("list")
        .add({
          'author': userId,
          'createdAt': textMessage.createdAt, // John Doe
          'id': textMessage.id,
          'text': message.text,
        })
        .then((value) => print("Message Added"))
        .catchError((error) => print("Failed to add message: $error"));
  }

  @override
  void initState() {
    super.initState;
    // fetchPastMessages();
    messageListener = FirebaseFirestore.instance
        .collection('messages')
        .doc(chatRoomId)
        .collection("list")
        .orderBy('createdAt')
        .snapshots()
        .listen((snapshot) {
      _messages.clear();
      for (final document in snapshot.docs) {
        //print(document.data());
        final textMessage = types.TextMessage(
          author: types.User(id: document.data()["author"]),
          createdAt: document.data()["createdAt"],
          id: document.data()["id"],
          text: document.data()["text"],
        );
        _addMessage(textMessage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('messages')
                .doc(chatRoomId)
                .collection("list")
                .orderBy('createdAt')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              }

              return SafeArea(
                  bottom: false,
                  child: Chat(
                    messages: _messages,
                    onSendPressed: _handleSendPressed,
                    user: _user,
                  ));
            }));
  }
}
