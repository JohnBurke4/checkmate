import 'dart:developer';

import 'package:checkmate/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'edit_user_page.dart';
import 'package:checkmate/ui/components/gallery.dart';
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
                      height: 10,
                    ),
                    const SizedBox(
                      height: 120,
                      child: Gallery(),
                    ),
                    const SizedBox(height: 6),
                    ListTile(
                      title: Text(
                        user.name,
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
                              child: ViewPositiveFeadback(uid: widget.uid)),
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
                                  user.bio,
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
                                  user.abilityLevel,
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
                                  user.chessDotComELO,
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
                    widget.editable
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                                margin: const EdgeInsets.only(
                                  top: 8,
                                  left: 10.0,
                                  right: 20.0,
                                ),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                  ),
                                  onPressed: () {
                                    OpenEditPage(buildContext);
                                  },
                                  child: Text('Edit Profile'),
                                )))
                        : Container(),
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
    user = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const SafeArea(child: EditProfilePage());
    })) as User;
    setState(() {
      log("set state");
    });
    //User temp = await Navigator.pushNamed(context, '/edit_user_page', arguments: user) as User;
    // setState(() {
    //   user.name = temp.name;
    //   user.bio = temp.bio;
    // });

    log(user.name);
    build(context);
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
}
