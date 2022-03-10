import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'edit_user_page.dart';
import 'package:checkmate/gallery.dart';
import 'package:checkmate/models/user.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPage createState() => _UserPage();
}

class _UserPage extends State<UserPage>{
  User user = User("Magnus C", "My bio", 31, chessAbility.Master);

  @override
  void initState() {
    super.initState;
  }

  @override
  Widget build(BuildContext buildContext) {
    log("build");
    if (ModalRoute
        .of(buildContext)!
        .settings
        .arguments != null) {
      User temp = ModalRoute
          .of(buildContext)!
          .settings
          .arguments as User;
      user.name = temp.name;
      user.bio = temp.bio;
      log(temp.name);
      log(temp.bio);
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 160,
              child: Gallery(),
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
                title: Text(
                  user.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'The King in The North',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                )),
            SizedBox(
              height: 20,
            ),
            ListTile(
                title: Text(
                  'Bio',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  user.bio,
                  style: TextStyle(fontSize: 15),
                )),
            ListTile(
                title: Text(
                  'Age',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  user.age.toString(),
                  style: TextStyle(fontSize: 15),
                )),
            ListTile(
                title: Text(
                  'Ability Level',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  user.abilityLevel.name,
                  style: TextStyle(fontSize: 15),
                )),
            ElevatedButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: () {
                OpenEditPage(buildContext);
              },
              child: Text('Edit Profile'),
            )
          ],
        ));
  }
  void OpenEditPage(BuildContext context) async{
    User temp = await Navigator.pushNamed(context, '/edit_user_page', arguments: user) as User;
    setState(() {
      user.name = temp.name;
      user.bio = temp.bio;
      user.age = temp.age;
      user.abilityLevel = temp.abilityLevel;
      print(temp.abilityLevel);
    });
  }
}