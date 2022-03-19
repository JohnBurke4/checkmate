import 'package:checkmate/firebase_options.dart';
import 'package:checkmate/services/match.dart';
import 'package:checkmate/sign_in.dart';
import 'package:checkmate/ui/components/gallery.dart';
import 'package:checkmate/ui/views/user_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  late final FirebaseMessaging _messaging;
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);



  LocationData? _currentPosition;
  Location location = new Location();
  String userId = 'vcCXf1YI85Nq5Op2PWMOMbu3DAv1';
  void registerNotification() async {
    // 1. Initialize the Firebase app
    await Firebase.initializeApp();

    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      var userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null){
        return;
      }
      var token = await _messaging.getToken();
      print(token);
      await FirebaseFirestore.instance
          .collection("user")
          .doc(userId)
          .update({'deviceToken' : token});
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Backround checking
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }


  @override
  void initState() {
    super.initState();
    registerNotification();
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

class NotificationBadge extends StatelessWidget {
  final int totalNotifications;

  const NotificationBadge({required this.totalNotifications});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: new BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '$totalNotifications',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}

class PushNotification {
  PushNotification({
    this.title,
    this.body,
  });
  String? title;
  String? body;
}