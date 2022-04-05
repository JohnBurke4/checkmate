import 'package:checkmate/widget_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:checkmate/reusable_widgets/reusable_widget.dart';
import 'package:checkmate/reset_password.dart';
import 'package:checkmate/sign_up.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromARGB(255, 0, 190, 248),
          Color.fromARGB(255, 24, 65, 248),
          Color.fromARGB(255, 0, 190, 248)
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.12, 20, 0),
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
                reusableTextField("Enter Email", Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock_outline, true,
                    _passwordTextController),
                const SizedBox(
                  height: 5,
                ),
                forgetPassword(context),
                firebaseUIButton(context, "Sign In", () {
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .then((value) {
                    final String? uid = value.user?.uid;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NavBar(uid: uid!)));
                  }).onError((error, stackTrace) {
                    if (error.toString() == error.toString()) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Credentials incorrect, try again!'),
                      ));
                    }
                  });
                }),
                signUpOption()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => ResetPassword())),
      ),
    );
  }
}
