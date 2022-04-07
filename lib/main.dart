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

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<User?> user;
  UserLocation ul = UserLocation();
  ThemeMode _themeMode = ThemeMode.system;

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

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      // ThemeData(
      //   primarySwatch: Colors.amber,
      //   primaryColorLight: ThemeData.dark()
      // ),
      home: nextScreen(),
      // routes: {
      //   '/user_page': (context) => UserPage(),
      //   '/edit_user_page': (context) => EditProfilePage()
      // }
    );
  }
}
