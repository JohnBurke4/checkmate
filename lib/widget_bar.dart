import 'package:checkmate/firebase_options.dart';
import 'package:checkmate/services/match.dart';
import 'package:checkmate/sign_in.dart';
import 'package:checkmate/gallery.dart';
import 'package:checkmate/ui/views/user_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ui/views/swipe_page.dart';

import 'ui/views/chatRoom.dart';
import 'ui/views/friendList.dart';
import 'ui/views/map.dart';

import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

class NavBar extends StatefulWidget {
  final String uid;

  const NavBar({Key? key, required this.uid}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  // _NavBarState() {};

  // late String test = widget.uid;

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);



  LocationData? _currentPosition;
  Location location = new Location();
  String userId = 'vcCXf1YI85Nq5Op2PWMOMbu3DAv1';

  @override
  void initState() {
    super.initState();
    // test = widget.uid ;
    MatchServices.getMatches(context);
  }

  String getUid() {
    return widget.uid;
  }

  void _onItemTapped(int index) {
    StatefulWidget route;
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.logout,
            color: Colors.white,
          ),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => SignInScreen()));
          },
        ),
        title: const Text('CheckMate'),
        automaticallyImplyLeading: false,
      ),
      body: <Widget>[
        // Put your widgets in here
        UserPage(uid: widget.uid,editable: true,),
        SwipePage(),
        FriendList(uid: widget.uid),
        MapPage(uid: widget.uid),
      ].elementAt(_selectedIndex),
      //_widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Me',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swipe),
            label: 'Swipe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
