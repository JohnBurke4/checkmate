import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:math';


import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/cupertino.dart';



class ChatRoom extends StatefulWidget {
  final String roomID;
  final String uid;
  const ChatRoom(
      {Key? key,
      required this.roomID,
      required this.uid})
      : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController _textController = new TextEditingController();

  void _handleSendPressed(String message) {
    if (message == '') return;
    FirebaseFirestore.instance
        .collection("messages")
        .doc(widget.roomID)
        .collection("list")
        .add({
      'author': widget.uid,
      'createdAt': DateTime.now().millisecondsSinceEpoch, // John Doe
      //'id': textMessage.id,
      'text': message,
    }).then((value) {
      _textController.text = '';
      print("Message Added");
    }).catchError((error) => print("Failed to add message: $error"));
  }

  @override
  void initState() {
    super.initState;
  }

  bool isSender(String friend) {
    return friend == widget.uid;
  }

  Alignment getAlignment(String friend) {
    if (friend == widget.uid) {
      return Alignment.topRight;
    }
    return Alignment.topLeft;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('CheckMate')),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('messages')
                .doc(widget.roomID)
                .collection('list')
                .orderBy('createdAt',descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                return SafeArea(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            child: ListView(
                                reverse: true,
                                //padding : EdgeInsets.only(top: 15.0),
                                children: snapshot.data!.docs
                                    .map((DocumentSnapshot document) {
                                  Map<String, dynamic> data =
                                      document.data()! as Map<String, dynamic>;
                                  return BubbleSpecialThree(
                                    text: data['text'],
                                    isSender: isSender(data['author']),
                                    color: isSender(data['author'])
                                        ? const Color(0xFF1B97F3)
                                        : const Color(0xFFE8E8EE),
                                    tail: false,
                                    textStyle: const TextStyle(
                                      fontSize: 25,
                                      //color: Colors.white,
                                    ),
                                  );
                                }).toList())),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 18.0),
                                child: CupertinoTextField(
                                  controller: _textController,
                                ),
                              ),
                            ),
                            CupertinoButton(
                                child: Icon(Icons.send_sharp),
                                onPressed: () =>
                                    _handleSendPressed(_textController.text))
                          ],
                        )
                      ]),
                );
              }
              return Container();
            }));
  }
}