import 'package:checkmate/tournament.dart';
import 'package:checkmate/widget_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:checkmate/reusable_widgets/reusable_widget.dart';
import 'package:checkmate/reset_password.dart';
import 'package:checkmate/sign_up.dart';
import 'package:flutter/material.dart';

class tournamentInfo extends StatefulWidget {
  const tournamentInfo({
    Key? key,
    required this.tournamentId,
  }) : super(key: key);
  final String tournamentId;
  @override
  _tournamentInfoState createState() => _tournamentInfoState();
}

class _tournamentInfoState extends State<tournamentInfo> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getTournamentInfo(widget.tournamentId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            TourInfo? res = snapshot.data as TourInfo?;
            if (res != null) {
              //print(res);
            }
            return Scaffold(
              appBar: AppBar(),
              body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 24, 65, 248),
                  Color.fromARGB(255, 0, 190, 248)
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                child: Column(
                  children: [
                    ListTile(
                        title: const Text(
                          'Author ID',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          res!.author_name,
                          style: TextStyle(fontSize: 15),
                        )),
                    ListTile(
                        title: const Text(
                          'Tournament name',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          res.tournamentName,
                          style: TextStyle(fontSize: 15),
                        )),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Future<TourInfo> getTournamentInfo(String tournamentID) async {
    TourInfo info =
        TourInfo(author_name: 'nothing_now', tournamentName: 'nothing_now');
    await FirebaseFirestore.instance
        .collection("tournaments")
        .doc(tournamentID)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      info = TourInfo(
          author_name: documentSnapshot.get('author'),
          tournamentName: documentSnapshot.get('name'));
      //print(documentSnapshot.data().toString());
    });
    return info;
  }
}

class TourInfo {
  final String author_name;
  final String tournamentName;
  const TourInfo({required this.author_name, required this.tournamentName});

  factory TourInfo.fromJson(Map<String, dynamic> json) {
    return TourInfo(author_name: json['author'], tournamentName: json['name']);
  }
}
