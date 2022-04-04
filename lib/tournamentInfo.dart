import 'package:checkmate/tournament.dart';
import 'package:checkmate/widget_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:checkmate/reusable_widgets/reusable_widget.dart';
import 'package:checkmate/reset_password.dart';
import 'package:checkmate/sign_up.dart';
import 'package:flutter/material.dart';

class tournamentInfo extends StatefulWidget {
  const tournamentInfo(
      {Key? key, required this.tournamentId, required this.isCreator})
      : super(key: key);
  final String tournamentId;
  final bool isCreator;
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

            int currentPlayers = res!.players.length;
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
                          'Hosted By',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        subtitle: Text(
                          widget.isCreator ? "Me!" : res!.author_name,
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        )),
                    ListTile(
                        title: const Text(
                          'Tournament name',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        subtitle: Text(
                          res.tournamentName,
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        )),
                    ListTile(
                        title: const Text(
                          'Size',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        subtitle: Text(
                          res.tournamentSize.toString(),
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        )),
                    FutureBuilder(builder: (context, snapshot) {
                      return ListTile(
                          title: const Text(
                            'Current Players',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          subtitle: Text(
                            currentPlayers.toString(),
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ));
                    }),
                    ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      onPressed: () {
                        if (!widget.isCreator &&
                            currentPlayers < res!.tournamentSize) {
                          addPlayer(widget.tournamentId, res.players,
                              FirebaseAuth.instance.currentUser!.uid);
                        }
                      },
                      child: Text(res!.tournamentSize > currentPlayers
                          ? 'Join Tournament'
                          : "Tournament is full"),
                    )
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

  void addPlayer(
      String tournamentId, List<dynamic> playersArray, String userId) {
    if (!playersArray.contains(userId)) {
      playersArray.add(userId);
      FirebaseFirestore.instance
          .collection("tournaments")
          .doc(tournamentId)
          .update({'players': playersArray})
          .then((value) => print("Player Added"))
          .catchError((error) => print("Failed to add player: $error"));

      myTournamentDialog("User Added successfully!");
    } else {
      myTournamentDialog("You have already joined");
    }
  }

  void myTournamentDialog(String displayText) {
    // set up the buttons
    Widget noButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.06,
        child: Column(
          children: [
            Text(displayText),
            const SizedBox(
              height: 14,
            )
          ],
        ),
      ),
      actions: [
        noButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<TourInfo> getTournamentInfo(String tournamentID) async {
    TourInfo info = TourInfo(
        author_id: "nothing now",
        author_name: 'nothing_now',
        tournamentName: 'nothing_now',
        tournamentSize: 0,
        players: []);
    await FirebaseFirestore.instance
        .collection("tournaments")
        .doc(tournamentID)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      var data = documentSnapshot.data() as Map<String, dynamic>;

      info = TourInfo(
          author_id: data['author'],
          author_name: data['authorName'] ?? "Unknown",
          tournamentName: data['name'],
          tournamentSize: data['size'],
          players: data['players']);
      //print(documentSnapshot.data().toString());
    });

    if (info.players.isEmpty == false) {
      info.players.forEach((element) {
        if (element == info.author_id) {}
      });
    }
    return info;
  }
}

class TourInfo {
  final String author_id;
  final String author_name;
  final String tournamentName;
  final int tournamentSize;
  final List<dynamic> players;
  const TourInfo(
      {required this.author_name,
      required this.author_id,
      required this.tournamentName,
      required this.tournamentSize,
      required this.players});

  factory TourInfo.fromJson(Map<String, dynamic> json) {
    return TourInfo(
        author_name: json['authorName'],
        author_id: json['author'],
        tournamentName: json['name'],
        tournamentSize: json['size'],
        players: json['players']);
  }
}
