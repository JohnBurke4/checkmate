import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart' as auth;

import 'firebase_options.dart';
import 'models/user.dart';

class ELOButton extends StatefulWidget {
  ELOButton({Key? key}) : super(key: key);

  @override
  _ELOButton createState() => _ELOButton();
}

class _ELOButton extends State<ELOButton> {
  late TextEditingController controller;
  String username = '';

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 25,
        child: ElevatedButton(
            child: const Text('Add Chess.com Rating'),
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
              textStyle: const TextStyle(fontSize: 12.5),
            ),
            onPressed: () async {
              final username = await enterUsername();
              if (username == null || username.isEmpty)
                return;
              else {
                await _fetchData(username);
              }
            }),
      );

  Future<String?> enterUsername() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Chess.com username'),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(hintText: 'Enter your username here'),
            controller: controller,
          ),
          actions: [
            TextButton(
              onPressed: submit,
              child: Text('SUBMIT'),
            ),
          ],
        ),
      );

  void submit() {
    Navigator.of(context).pop(controller.text);
    controller.clear();
  }
}

Future<void> _fetchData(String username) async {
  User? user = User('', '');
  User? currentUser = DefaultFirebaseOptions.user;
  user = currentUser ?? User("", "");
  user.id = auth.FirebaseAuth.instance.currentUser?.uid;
  user.email = auth.FirebaseAuth.instance.currentUser?.email;
  String rating = '';
  String API_URL = 'https://api.chess.com/pub/player/$username/stats';

  final response = await http.get(Uri.parse(API_URL));
  Map<String, dynamic> data = json.decode(response.body);
  Map<String, dynamic> blitz = data['chess_blitz'];
  Map<String, dynamic> last = blitz['last'];
  rating = last['rating'].toString();
  print(rating);
  user.chessDotComELO = rating;
  await DefaultFirebaseOptions.uploadUserDetails(user);
}
