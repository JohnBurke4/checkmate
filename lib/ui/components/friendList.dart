import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:math';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

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
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
              
            print(data['friends'].toString());
            return ListView.builder(
              itemCount : data['friends'].length,
              itemBuilder : (context,index){
                return ListTile (
                  title : Text(data['friends'][index]['name']),
                );
              }
              //children : 
              // children: snapshot.data!.data((DocumentSnapshot document) {
              //   Map<String, dynamic> data =
              //       document.data()! as Map<String, dynamic>;
              //   return ListTile(
              //     title: Text(data['name'].toString()),
              //   );
              // }).toList(),
              // }
            );
          }
          return Container();
        });
  }
}
// class _FriendListState extends State<FriendList>{



// }