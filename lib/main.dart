import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:math';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

// For the testing purposes, you should probably use https://pub.dev/packages/uuid
String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ChatRoom(),
    );
  }
}

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


  Future<void> fetchPastMessages () async {
    try{
      await  FirebaseFirestore.instance
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

      print(doc["text"]);
    });
  });
    }catch(e){
      print(e);
    }
  }


  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
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
    print(message.text);

    Future<void> addMessage() async {
      CollectionReference messages =
          FirebaseFirestore.instance.collection('messages');
      // Call the user's CollectionReference to add a new user
      return messages
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

    addMessage();
  }

  @override
  void initState(){
    super.initState;
    fetchPastMessages ();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Chat(
          messages: _messages,
          onSendPressed: _handleSendPressed,
          user: _user,
        ),
      ),
    );
  }
}
