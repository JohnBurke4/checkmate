import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/cupertino.dart';

import '../components/leavePositiveFeadback.dart';
class TargetPage extends StatefulWidget {
  final String targetUid;

  const TargetPage({Key? key, required this.targetUid}) : super(key: key);

  @override
  _TargetPageState createState() => _TargetPageState();
}

class _TargetPageState extends State<TargetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: <Widget>[
            const SizedBox(
              height: 30,
            ),
            const SizedBox(
              height: 160,
              child: Gallery(),
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
                title: Text(
                  user.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  'The King in The North',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                )),
            const SizedBox(
              height: 20,
            ),
            ListTile(
                title: const Text(
                  'Bio',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  user.bio,
                  style: TextStyle(fontSize: 15),
                )),
            const ListTile(
                title: Text(
                  'Ability Level',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Experienced (1600+)',
                  style: TextStyle(fontSize: 15),
                )),


            Center(child: ViewPositiveFeadback(uid: widget.uid))
          ],
        ));
  }
}
