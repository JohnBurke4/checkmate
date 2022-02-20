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

class MessageFetching extends StatelessWidget {
  final String roomID;

  MessageFetching({Key? key, required this.roomID}) : super(key: key);

  List<types.Message> _messages = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('CheckMate')),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('messages')
                .doc("FBCJhytvnLyweXAYaLC8")
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
              print(snapshot.data!.docs.length);
              print("Is data inside snapshot : ${snapshot.hasData.toString()}");
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
                  // print(data);
                  // _addMessage(textMessage);
                }
                return SafeArea(
                    bottom: false, child: ChatRoom(messages: _messages));
              }
              return Container(); //SafeArea(bottom: false, child: Messages());
            }));
  }
}

class ChatRoom extends StatefulWidget {
  ChatRoom({Key? key, required this.messages}) : super(key: key);

  List<types.Message> messages;

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  String chatRoomId = "FBCJhytvnLyweXAYaLC8";
  //String userId = "qb6OCKQa8pWd2ndmCq6BBE4HBJ23";
  String userId = 'vcCXf1YI85Nq5Op2PWMOMbu3DAv1';

  late final _user = types.User(id: userId);

  String randomString() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );

    // _addMessage(textMessage);

    FirebaseFirestore.instance
        .collection("messages")
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
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        child: Chat(
          messages: widget.messages,
          onSendPressed: _handleSendPressed,
          user: _user,
          showUserNames: true,
        ));
  }
}

// class _MessagesState extends State<Messages> {
//   String chatRoomId = "FBCJhytvnLyweXAYaLC8";
//   //String userId = "qb6OCKQa8pWd2ndmCq6BBE4HBJ23";
//   String userId = 'vcCXf1YI85Nq5Op2PWMOMbu3DAv1';
//   List<types.Message> _messages = [];

//   late Stream test = FirebaseFirestore.instance
//       .collection('messages')
//       .doc(chatRoomId)
//       .collection("list")
//       .snapshots();

//   StreamSubscription<QuerySnapshot>? messageListener;

//   Future<void> fetchPastMessages() async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('messages')
//           .doc(chatRoomId)
//           .collection("list")
//           .orderBy('createdAt')
//           .get()
//           .then((QuerySnapshot querySnapshot) {
//         querySnapshot.docs.forEach((doc) {
//           final textMessage = types.TextMessage(
//             author: types.User(id: doc["author"]),
//             createdAt: doc["createdAt"],
//             id: doc["id"],
//             text: doc["text"],
//           );
//           _addMessage(textMessage);

//           //print(doc["text"]);
//         });
//       });
//     } catch (e) {
//       print(e);
//     }
//   }

//   @override
//   void initState() {
//     super.initState;
//     // fetchPastMessages();
//     messageListener = FirebaseFirestore.instance
//         .collection('messages')
//         .doc(chatRoomId)
//         .collection("list")
//         .orderBy('createdAt')
//         .snapshots()
//         .listen((snapshot) {
//       _messages.clear();
//       for (final document in snapshot.docs) {
//         //print(document.data());
//         final textMessage = types.TextMessage(
//           author: types.User(id: document.data()["author"]),
//           createdAt: document.data()["createdAt"],
//           id: document.data()["id"],
//           text: document.data()["text"],
//         );
//         _addMessage(textMessage);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Center(child: const Text('CheckMate')),
//         ),
//         body: StreamBuilder(
//             stream: FirebaseFirestore.instance
//                 .collection('messages')
//                 .doc(chatRoomId)
//                 .collection('list')
//                 .orderBy('createdAt')
//                 .snapshots(),
//             builder:
//                 (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//               if (snapshot.hasError) {
//                 return const Text('Something went wrong');
//               }
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(
//                     child: CircularProgressIndicator(
//                         valueColor: AlwaysStoppedAnimation<Color>(
//                             Color.fromARGB(255, 23, 29, 43))));
//               }
//               print(snapshot.data!.docs.length);
//               return SafeArea(
//                   bottom: false,
//                   child: Chat(
//                     messages: _messages,
//                     onSendPressed: _handleSendPressed,
//                     user: _user,
//                     showUserNames: true,
//                   ));
//             }));
//   }
// }
