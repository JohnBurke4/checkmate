import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:math';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class ChatRoom extends StatefulWidget {
  final String roomID;
  final String uid;
  const ChatRoom({Key? key, required this.roomID, required this.uid})
      : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  List<types.Message> _messages = [];

  late final _user = types.User(id: widget.uid);
  late Stream test = FirebaseFirestore.instance
      .collection('messages')
      .doc(widget.roomID)
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

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = _messages[index].copyWith(previewData: previewData);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        _messages[index] = updatedMessage;
      });
    });
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
        .collection("messages")
        .doc(widget.roomID)
        .collection("list")
        .add({
          'author': widget.uid,
          'createdAt': DateTime.now().millisecondsSinceEpoch, // John Doe
          'id': textMessage.id,
          'text': message.text,
        })
        .then((value) => print("Message Added"))
        .catchError((error) => print("Failed to add message: $error"));
  }

  @override
  void initState() {
    super.initState;
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
                .orderBy('createdAt')
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
                for (var document in snapshot.data!.docChanges) {
                  Map<String, dynamic> data =
                      document.doc.data() as Map<String, dynamic>;
                  print(data);

                  final textMessage = types.TextMessage(
                    author: types.User(id: data["author"]),
                    createdAt: data["createdAt"],
                    id: data["id"],
                    text: data["text"],
                  );
                  _messages.insert(0, textMessage);
                }
                return SafeArea(
                    bottom: false,
                    child: Chat(
                      messages: _messages,
                      onSendPressed: _handleSendPressed,
                      user: _user,
                      showUserNames: true,
                    ));
              }
              return Container();
            }));
  }
}
