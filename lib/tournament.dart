import 'package:checkmate/reusable_widgets/reusable_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:geocoder/geocoder.dart';

class Tournament {
  // TODO: add details to firebase
  late double lat;
  late double lon;
  late String author;
  // late String tournamentName;
  late DateTime createdAt;
  // late int numPlayer;
  // late String address;

  Tournament();

  void onTapFunc(BuildContext context, String userId, double lat, double lon,
      String? userTournamentId) async {
    if (userTournamentId != null) {
      String name = await FirebaseFirestore.instance
          .collection("tournaments")
          .doc(userTournamentId)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          var data = documentSnapshot.data() as Map<String, dynamic>;
          return data['name'] ?? "Tournament";
        } else {
          return "Tournament";
        }
      });
      myTournamentDialog(context, name, userTournamentId);
    }
  }

  void onLongPressFunc(BuildContext context, String userId, double lat,
      double lon, String? userTournamentId) {
    if (userTournamentId != null) {
      deleteTournamentAlertDialog(context, userId, lat, lon);
    } else {
      createTournamentAlertDialog(context, userId, lat, lon);
    }
  }

  Future<String?> isUserTournamentExistHere(
      String userId, double lat, double lon) async {
    return await FirebaseFirestore.instance
        .collection("tournaments")
        .where("author", isEqualTo: userId)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (isTournamentExistInRange(lat, lon, doc['lat'], doc['lon'])) {
          return doc.id;
        }
      }
      return null;
    }).catchError(
            (error) => print("Failed to check tournament existence: $error"));
  }

  bool isTournamentExistInRange(
      double userLat, double userLon, double tourLat, double tourLon) {
    double iconWidth = 0.0003;
    double iconHeight = 0.0005;
    double latDif = (tourLat - userLat).abs();
    double lonDif = (tourLon - userLon).abs();
    if (latDif < iconWidth && lonDif < iconHeight) {
      return true;
    }
    return false;
  }

  void createTournament(String userId, double lat, double lon, String name, int size) {
    FirebaseFirestore.instance
        .collection("tournaments")
        .add({
          'author': userId,
          'createdAt': DateTime.now(),
          'lat': lat,
          'lon': lon,
          'name': name,
          'size' : size,
        })
        .then((value) => print("Tournaments Location Added: $userId"))
        .catchError(
            (error) => print("Failed to add tournaments location: $error"));
  }

  void deleteTournament(String userId, double lat, double lon) {
    FirebaseFirestore.instance
        .collection("tournaments")
        .where("author", isEqualTo: userId)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (isTournamentExistInRange(lat, lon, doc['lat'], doc['lon'])) {
          doc.reference.delete();
        }
      }
      print("Tournamet deleted for user: $userId");
    }).catchError((error) => print("Failed to delete tournamet: $error"));
  }

  createTournamentAlertDialog(
      BuildContext context, String userId, double lat, double lon) {
    TextEditingController _tournamentNameController = TextEditingController();
    TextEditingController _tournamentSizeController = TextEditingController();
    // set up the buttons
    Widget yesButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        print(_tournamentNameController.text);
        if (_tournamentNameController.text.isNotEmpty && _tournamentSizeController.text.isNotEmpty) {
          var size = int.tryParse(_tournamentSizeController.text);
          if (size == null || size < 1 || size > 32){

          }
          else{
            createTournament(userId, lat, lon, _tournamentNameController.text, size);
            Navigator.of(context).pop();
          }

        }
      },
    );
    Widget noButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("New Tournament"),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        child: Column(
          children: [
            Text("Would you like to start a new tournament?"),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _tournamentNameController,
              decoration: InputDecoration(hintText: "Tournament Name"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              controller: _tournamentSizeController,
              decoration: InputDecoration(hintText: "Size"),
            )
          ],
        ),
      ),
      actions: [
        yesButton,
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

  deleteTournamentAlertDialog(
      BuildContext context, String userId, double lat, double lon) {
    // set up the buttons
    Widget yesButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        deleteTournament(userId, lat, lon);
        Navigator.of(context).pop();
      },
    );
    Widget noButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text("Would you like to delete your tournament?"),
      actions: [
        yesButton,
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

  myTournamentDialog(
      BuildContext context, String tournamentName, String tournamentId) {
    // set up the buttons
    Widget yesButton = FlatButton(
      child: Text("View"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget noButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(tournamentName),
      content: Text("Would you like to view this tournament?"),
      actions: [
        yesButton,
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

  void showTournament() {
    // TODO:
  }

  void updateTournament() {
    // TODO:
  }
}
