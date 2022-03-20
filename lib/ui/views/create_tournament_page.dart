import 'package:checkmate/tournament.dart';
import 'package:checkmate/widget_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:checkmate/reusable_widgets/reusable_widget.dart';
import 'package:checkmate/reset_password.dart';
import 'package:checkmate/sign_up.dart';
import 'package:flutter/material.dart';

class CreateTournamentPage extends StatefulWidget {
  const CreateTournamentPage({Key? key,
    required this.lat,
    required this.lon,}) : super(key: key);
  final double lat;
  final double lon;
  @override
  _CreateTournamentPageState createState() => _CreateTournamentPageState();
}

class _CreateTournamentPageState extends State<CreateTournamentPage> {
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _sizeTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

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
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.10, 20, 0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                  child: Center(
                    child: Text(
                      "Create a new tournament",
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.9), fontSize: 30),
                    ),
                  ),
                ),
                reusableTextField("Tournament Name?", Icons.drive_file_rename_outline, false,
                    _nameTextController, TextInputType.text),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Number of players?", Icons.supervisor_account, false,
                    _sizeTextController, TextInputType.number),
                const SizedBox(
                  height: 5,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.white),
                  ),
                  onPressed: () {
    if (_nameTextController.text.isNotEmpty && _sizeTextController.text.isNotEmpty) {
      var size = int.tryParse(_sizeTextController.text);
      if (size == null || size < 1 || size > 32){

      }
      else{
        Tournament.createTournament(FirebaseAuth.instance.currentUser!.uid, widget.lat, widget.lon, _nameTextController.text, size);
        Navigator.of(context).pop();
      }

    }
                  },
                  child: Text('Confirm'),

                ),
                ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Change Location'),
                )
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
