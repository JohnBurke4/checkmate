import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:checkmate/ui/views/edit_user_page.dart';
import 'package:checkmate/ui/views/swipe_page.dart';
import 'package:checkmate/ui/views/user_page.dart';
import 'package:checkmate/widget_bar.dart';
import 'package:checkmate/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'location.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<User?> user;
  UserLocation ul = UserLocation();

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        // Once user is signed in, record the current location.
        User? currentUser = FirebaseAuth.instance.currentUser;
        String? uid = currentUser!.uid;
        ul.isUserExists(uid).then((result) => ul.fetchLocation(uid, result));
      }
    });
  }

  @override
  void dispose() {
    user.cancel();
    super.dispose();
  }

  Widget nextScreen() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const SignInScreen();
    } else {
      String? uid = currentUser.uid;
      return NavBar(uid: uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: nextScreen(),
        // routes: {
        //   '/user_page': (context) => UserPage(),
        //   '/edit_user_page': (context) => EditProfilePage()
        // }
        );
  }
}
