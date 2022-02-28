import 'package:checkmate/sign_in.dart';
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

  // static final List<Widget> _widgetOptions = <Widget>[
  //   // Put your widgets in here
  //   UserPage(),
  //   SwipePage(),
  //   FriendList(uid: getUid()),
  //   MapPage(),
  // ];

  LocationData? _currentPosition;
  Location location = new Location();
  String tmp_location_list_id = 'c09uTg5jASyKjdpCXS7f';
  String userId = 'vcCXf1YI85Nq5Op2PWMOMbu3DAv1';

  @override
  void initState() {
    super.initState();
    // test = widget.uid ;
    fetchLocation();
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
        title: Center(child: const Text('CheckMate')),
        automaticallyImplyLeading: false,
      ),
      body: <Widget>[
        // Put your widgets in here
        UserPage(),
        SwipePage(),
        FriendList(uid: widget.uid),
        MapPage(),
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

  fetchLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentPosition = await location.getLocation();
    log('data: $_currentPosition');
    FirebaseFirestore.instance
        .collection("tmp_locationData")
        .doc(tmp_location_list_id)
        .collection("location_list")
        .add({
          'author': userId,
          'createdAt': DateTime.now(),
          'lat': _currentPosition!.latitude,
          'lon': _currentPosition!.longitude,
        })
        .then((value) => print("Message Added"))
        .catchError((error) => print("Failed to add message: $error"));
    // location.onLocationChanged.listen((LocationData currentLocation) {
    //   setState(() {
    //     _currentPosition = currentLocation;
    //   });
    // });
  }
}
