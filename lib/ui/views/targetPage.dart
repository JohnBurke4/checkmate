import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/cupertino.dart';

import '../components/leavePositiveFeadback.dart';
import '../components/gallery.dart';

class TargetPage extends StatelessWidget {
  final String targetUid;
  final String uid;

  const TargetPage({Key? key, required this.targetUid, required this.uid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('user')
                .doc(targetUid)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
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
                              data['username'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 35, fontWeight: FontWeight.bold),
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
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              data['bio'],
                              style: TextStyle(fontSize: 15),
                            )),
                        const ListTile(
                            title: Text(
                              'Ability Level',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'Experienced (1600+)',
                              style: TextStyle(fontSize: 15),
                            )),
                        LeavePositiveFeadback(uid: uid, friendUid: targetUid)
                      ],
                    ));
              }
              return Container();
            }));
  }
}
