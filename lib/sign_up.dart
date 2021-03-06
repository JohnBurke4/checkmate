import 'package:checkmate/widget_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:checkmate/reusable_widgets/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromARGB(255, 24, 65, 248),
            Color.fromARGB(255, 0, 190, 248)
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                Image(
                  height: MediaQuery.of(context).size.height * 0.25,
                  image: const AssetImage("assets/Checkmate_logo_white.png"),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                  child: Center(
                    child: Text(
                      "Check Mate",
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.9), fontSize: 30),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Name", Icons.person_outline, false,
                    _userNameTextController, TextInputType.text),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Email", Icons.person_outline, false,
                    _emailTextController, TextInputType.emailAddress),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock_outlined, true,
                    _passwordTextController, TextInputType.visiblePassword),
                const SizedBox(
                  height: 20,
                ),
                firebaseUIButton(context, "Sign Up", () {
                  if (_userNameTextController.text != "") {
                    FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: _emailTextController.text,
                            password: _passwordTextController.text)
                        .then((value) {
                      print("Created New Account");
                      final String? uid = value.user?.uid;

                      FirebaseFirestore.instance
                          .collection("user")
                          .doc(uid)
                          .set({
                        'email': _emailTextController.text,
                        'username': _userNameTextController.text,
                        'uid': uid,
                        'friendliness': 0,
                        'punctuality': 0,
                        'hangOutAgain': 0,
                      }).then((value) {
                        print("User entry Added");
                      }).catchError((error) =>
                              print("Failed to add user entry: $error"));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NavBar(uid: uid!)));
                    }).onError((error, stackTrace) {
                      print("Error ${error.toString()}");
                      if (error.toString() ==
                          "[firebase_auth/invalid-email] The email address is badly formatted.") {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'The email address is badly formatted, try again!'),
                        ));
                      } else if (error.toString() ==
                          "[firebase_auth/weak-password] The password must be 6 characters long or more.") {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'The password must be 6 characters long or more, try again!'),
                        ));
                      } else if (error.toString() ==
                          "[firebase_auth/weak-password] Password should be at least 6 characters") {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Password should be at least 6 characters, try again!'),
                        ));
                      } else if (error.toString() ==
                          "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'The email address is already in use by another account.'),
                        ));
                      }
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Type in your name'),
                    ));
                  }
                })
              ],
            ),
          ))),
    );
  }
}
