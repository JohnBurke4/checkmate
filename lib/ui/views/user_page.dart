import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'edit_user_page.dart';
import 'package:checkmate/models/user.dart';
class UserPage extends StatelessWidget {
  User user= User("Magnus C", "My bio");

  @override
  Widget build(BuildContext buildContext){
    log("build");
    if(ModalRoute.of(buildContext)!.settings.arguments != null) {
      User temp = ModalRoute.of(buildContext)!.settings.arguments as User;
      user.name = temp.name;
      user.bio = temp.bio;
      log(temp.name);
      log(temp.bio);
    }

    return  Scaffold(
    resizeToAvoidBottomInset: false,
    body:  Column(
      children: <Widget>[
        SizedBox(height: 30, ),
        Stack(
            alignment: Alignment.center,
            children: <Widget>[
              CircleAvatar(radius: 80, backgroundColor: Colors.white, backgroundImage: NetworkImage('https://m.media-amazon.com/images/M/MV5BY2QxOWJiYzItMTQzMi00Y2MwLTgxNzMtN2ExMzc5MWZjZDFkXkEyXkFqcGdeQXVyNjUxMjc1OTM@._V1_UY1200_CR173,0,630,1200_AL_.jpg'),)
            ]
        ),
        SizedBox(height: 20, ),
        ListTile(title: Text(user.name, textAlign: TextAlign.center, style: TextStyle( fontSize: 35, fontWeight: FontWeight.bold),), subtitle: Text('The King in The North', textAlign: TextAlign.center, style: TextStyle( fontSize: 20),))
        ,SizedBox(height: 20, ),
        ListTile(title: Text('Bio', style: TextStyle( fontSize: 15, fontWeight: FontWeight.bold),),
            subtitle: Text(user.bio,
              style: TextStyle( fontSize: 15),)),
        ListTile(title: Text('Ability Level', style: TextStyle( fontSize: 15, fontWeight: FontWeight.bold),),
            subtitle: Text('Experienced (1600+)',
              style: TextStyle( fontSize: 15),)),

        ElevatedButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          onPressed: () {Navigator.pushNamed(buildContext, '/edit_user_page', arguments: user);
          EditProfilePage(); },
          child: Text('Edit Profile'),
        )

      ],
    )

    );
  }

}