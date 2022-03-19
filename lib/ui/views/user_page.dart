import 'dart:developer';

import 'package:checkmate/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'edit_user_page.dart';
import 'package:checkmate/gallery.dart';
import 'package:checkmate/models/user.dart';
import '../components/viewPositiveFeadback.dart';

class UserPage extends StatefulWidget {
  final String uid;
  final bool editable;

  final String friendUid;
  const UserPage(
      {Key? key,
      required this.uid,
      required this.editable,
      this.friendUid = "temp"})
      : super(key: key);

  @override
  _UserPage createState() => _UserPage();
}

class _UserPage extends State<UserPage> {
  User user = User("Magnus C", "My bio");

  @override
  void initState() {
    super.initState;
  }

  @override
  Widget build(BuildContext buildContext) {
    return FutureBuilder(
        future: DefaultFirebaseOptions.getUserDetails(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            user = DefaultFirebaseOptions.user ?? User("My Name", "My bio");
            if (DefaultFirebaseOptions.user?.imagePaths.isEmpty ?? true) {
              WidgetsBinding.instance?.addPostFrameCallback((_) async {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const SafeArea(child: EditProfilePage());
                }));
              });
            }
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
                          user.bio,
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

                    //LeavePositiveFeadback(uid: uid, friendUid: friendUid, editable: editable),
                    widget.editable
                        ? ElevatedButton(
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                            ),
                            onPressed: () {
                              OpenEditPage(buildContext);
                            },
                            child: Text('Edit Profile'),
                          )
                        : Container(),

                    Center(child: ViewPositiveFeadback(uid: widget.uid))
                  ],
                ));
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  void OpenEditPage(BuildContext context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const SafeArea(child: EditProfilePage());
    }));
    user = DefaultFirebaseOptions.user ?? User("My Name", "My bio");
    setState(() {});
    //User temp = await Navigator.pushNamed(context, '/edit_user_page', arguments: user) as User;
    // setState(() {
    //   user.name = temp.name;
    //   user.bio = temp.bio;
    // });

    log(user.name);
    build(context);
  }
}
