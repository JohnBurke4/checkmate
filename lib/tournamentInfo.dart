import 'package:checkmate/firebase_options.dart';
import 'package:checkmate/models/user.dart' as customUser;
import 'package:checkmate/tournament.dart';
import 'package:checkmate/ui/views/targetPage.dart';
import 'package:checkmate/widget_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:checkmate/reusable_widgets/reusable_widget.dart';
import 'package:checkmate/reset_password.dart';
import 'package:checkmate/sign_up.dart';
import 'package:flutter/cupertino.dart';
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
              appBar: AppBar(
                title: Center(child: Text("Tournament")),
                actions: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: (widget.isCreator)
                          ? GestureDetector(
                              onTap: () async {
                                await deleteTournamentDialog(
                                    widget.tournamentId);
                              },
                              child: const Icon(
                                Icons.delete,
                                size: 30.0,
                              ),
                            )
                          : Text("")),
                ],
              ),
              body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                          res.tournamentName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        left: 10.0,
                        right: 10.0,
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black12,
                          ),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: Column(
                        children: [
                          sectionTitle(context, 'Host'),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                res!.author_name,
                                style: TextStyle(
                                  color: Color(0xFF9f9f9f),
                                ),
                              ),
                            ),
                          ),
                          sectionTitle(context, 'Max Players'),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                res.tournamentSize.toString(),
                                style: TextStyle(
                                  color: Color(0xFF9f9f9f),
                                ),
                              ),
                            ),
                          ),
                          sectionTitle(context, 'Current Players'),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                currentPlayers.toString(),
                                style: TextStyle(
                                  color: Color(0xFF9f9f9f),
                                ),
                              ),
                            ),
                          ),
                          sectionTitle(context, 'Date'),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                res.date.toString(),
                                style: TextStyle(
                                  color: Color(0xFF9f9f9f),
                                ),
                              ),
                            ),
                          ),
                          sectionTitle(context, 'Other Details'),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                res.details.toString(),
                                style: TextStyle(
                                  color: Color(0xFF9f9f9f),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    sectionTitle(context, (res.players.contains(
                        FirebaseAuth.instance.currentUser?.uid) ||
                        widget.isCreator)
                        ? "Current Players"
                        : "Join to find the current players"),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                        // Let the ListView know how many items it needs to build.
                        itemCount: (res.players.contains(
                                    FirebaseAuth.instance.currentUser?.uid) ||
                                widget.isCreator)
                            ? res.players.length
                            : 0,
                        // Provide a builder function. This is where the magic happens.
                        // Convert each item into a widget based on the type of item it is.
                        itemBuilder: (context, index) {
                          final item = res.players[index];

                          return FutureBuilder(
                            future: DefaultFirebaseOptions.getOtherUserDetails(
                                item),
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (snapshot.hasData) {
                                customUser.User? data =
                                    snapshot.data as customUser.User?;
                                return ListTile(
                                  title: Row(
                                    children: [
                                      Text(
                                        data != null ? data.name : "Hidden",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      GestureDetector(
                                        onLongPress: () {
                                          if (widget.isCreator) {
                                            removeFromTournamentDialog(
                                                data?.name ?? "Error",
                                                data?.id ?? "Error",
                                                widget.tournamentId ?? "Error",
                                                res.players);
                                          }
                                        },
                                        onTap: () {
                                          if (FirebaseAuth
                                                      .instance.currentUser ==
                                                  null ||
                                              data == null) {
                                            return;
                                          }
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return SafeArea(
                                                child: TargetPage(
                                                    uid: FirebaseAuth.instance
                                                            .currentUser?.uid ??
                                                        "Error",
                                                    targetUid:
                                                        data.id ?? "Error"));
                                          }));
                                        },
                                        child: const Icon(
                                          Icons.account_box,
                                          size: 30.0,
                                          color: Colors.blue,
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        onPressed: () {
                          if (currentPlayers < res!.tournamentSize) {
                            addPlayer(widget.tournamentId, res.players,
                                FirebaseAuth.instance.currentUser!.uid);
                          }
                        },
                        child: Text(res!.tournamentSize > currentPlayers
                            ? 'Join Tournament'
                            : "Tournament is full"),
                      ),
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
      setState(() {});
    } else {
      myTournamentDialog("You have already joined");
    }
  }

  void removePlayer(
      String tournamentId, List<dynamic> playersArray, String userId) {
    print(playersArray);
    print(userId);
    if (playersArray.contains(userId)) {
      playersArray.remove(userId);
      FirebaseFirestore.instance
          .collection("tournaments")
          .doc(tournamentId)
          .update({'players': playersArray})
          .then((value) => print("Player Added"))
          .catchError((error) => print("Failed to add player: $error"));

      myTournamentDialog("User Added Removed!");
      setState(() {});
    } else {
      myTournamentDialog("Player already removed");
    }
  }

  void myTournamentDialog(String displayText) {
    // set up the buttons
    Widget noButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
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

  void removeFromTournamentDialog(String username, String userId,
      String tournamentId, List<dynamic> playersArray) async {
    // set up the buttons
    Widget noButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget yesButton = FlatButton(
      child: Text("Confirm"),
      onPressed: () {
        Navigator.of(context).pop();
        removePlayer(tournamentId, playersArray, userId);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Are you sure?"),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.06,
        child: Column(
          children: [
            Text("Are you sure you wish to remove " + username + "?"),
            const SizedBox(
              height: 14,
            )
          ],
        ),
      ),
      actions: [noButton, yesButton],
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
        details: "",
        date: "TBD",
        players: []);
    await FirebaseFirestore.instance
        .collection("tournaments")
        .doc(tournamentID)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      var data = documentSnapshot.data() as Map<String, dynamic>;

      info = TourInfo(
          details: data['details'] ?? "",
          date: data['date'] ?? "TBD",
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

  Future<bool> deleteTournament(String tournamentId) async {
    bool result = true;
    await FirebaseFirestore.instance
        .collection("tournaments")
        .doc(tournamentId)
        .delete()
        .catchError((error) {
      result = false;
      print("Failed to delete tournamet: $error");
    });
    return result;
  }

  Future deleteTournamentDialog(String tournamentId) async {
    // set up the buttons
    Widget noButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget yesButton = FlatButton(
      child: Text("Confirm"),
      onPressed: () async {
        Navigator.of(context).pop();
        bool res = await deleteTournament(tournamentId);
        if (res) {
          Navigator.of(context).pop();
        }
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Are you sure?"),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.06,
        child: Column(
          children: const [
            Text("Are you sure you that wish to delete this tournament?"),
            SizedBox(
              height: 14,
            )
          ],
        ),
      ),
      actions: [noButton, yesButton],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class TourInfo {
  final String author_id;
  final String author_name;
  final String tournamentName;
  final String date;
  final String details;
  final int tournamentSize;
  final List<dynamic> players;
  const TourInfo(
      {required this.author_name,
      required this.author_id,
      required this.tournamentName,
      required this.tournamentSize,
      required this.players,
      required this.date,
      required this.details});

  factory TourInfo.fromJson(Map<String, dynamic> json) {
    return TourInfo(
        author_name: json['authorName'],
        author_id: json['author'],
        tournamentName: json['name'],
        tournamentSize: json['size'],
        details: json['details'] ?? "",
        date: json['date'] ?? "TBD",
        players: json['players']);
  }
}
