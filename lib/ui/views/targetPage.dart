import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/cupertino.dart';

import '../../firebase_options.dart';
import '../components/friend_gallery.dart';
import '../components/leavePositiveFeadback.dart';
import '../components/gallery.dart';

class TargetPage extends StatelessWidget {
  final String targetUid;
  final String uid;

  const TargetPage({Key? key, required this.targetUid, required this.uid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DefaultFirebaseOptions.showDialogIfFirstLoaded(context, "OtherUserPage", "Player Profile", "Welcome! You can review a players conduct by tapping on one of the icons. Long tap to see what it means");
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
                          height: 10,
                        ),
                        SizedBox(
                          height: 120,
                          child: FriendGallery(uid: targetUid),
                        ),
                        const SizedBox(height: 6),
                        ListTile(
                          title: Text(
                            data['username'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                            margin: const EdgeInsets.only(
                              left: 10.0,
                              right: 10.0,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.black12,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            child: Column(children: [
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                  margin: const EdgeInsets.only(
                                    left: 15.0,
                                    right: 10.0,
                                  ),
                                  child: LeavePositiveFeadback(
                                      uid: uid, friendUid: targetUid)),
                              SizedBox(
                                height: 10,
                              ),
                            ])),
                        const SizedBox(height: 10),
                        Container(
                            margin: const EdgeInsets.only(
                              left: 10.0,
                              right: 10.0,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.black12,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            child: Column(
                              children: [
                                sectionTitle(context, 'Biography'),
                                Container(
                                  margin: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      data['bio'],
                                      style: TextStyle(
                                        color: Color(0xFF9f9f9f),
                                      ),
                                    ),
                                  ),
                                ),
                                sectionTitle(context, 'Ability Level'),
                                Container(
                                  margin: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      data['abilityLevel'],
                                      style: TextStyle(
                                        color: Color(0xFF9f9f9f),
                                      ),
                                    ),
                                  ),
                                ),
                                sectionTitle(context, 'Chess.com Blitz Rating'),
                                Container(
                                  margin: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      data['chessDotComELO'] ?? "Not Available",
                                      style: TextStyle(
                                        color: Color(0xFF9f9f9f),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            )),
                      ],
                    ));
              }
              return Container();
            }));
  }
}

Widget sectionTitle(context, String title) {
  return Container(
    margin: const EdgeInsets.only(
      top: 20.0,
      left: 20.0,
      right: 20.0,
      bottom: 20.0,
    ),
    child: Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 10,
          ),
          child: Divider(
            color: Colors.black12,
            height: 1,
            thickness: 1,
          ),
        ),
      ],
    ),
  );
}
