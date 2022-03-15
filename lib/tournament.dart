import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:geocoder/geocoder.dart';

class Tournament {
  // TODO: add details to firebase
  // final double lat - done;
  // final double lon - done;
  // final String userId - done;
  // final String tournamentName;
  // final int numPlayer;
  // final String address;

  Tournament();

  void onTapFunc() {
    //TODO:
  }

  void onLongPressFunc(BuildContext context, String userId, double lat,
      double lon, bool userTournamentExist) {
    if (userTournamentExist) {
      deleteTournamentAlertDialog(context, userId, lat, lon);
    } else {
      createTournamentAlertDialog(context, userId, lat, lon);
    }
  }

  Future<bool> isUserTournamentExistHere(
      String userId, double lat, double lon) async {
    return await FirebaseFirestore.instance
        .collection("tournaments")
        .where("author", isEqualTo: userId)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (isTournamentExistInRange(lat, lon, doc['lat'], doc['lon'])) {
          return true;
        }
      }
      return false;
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

  void createTournament(String userId, double lat, double lon) {
    FirebaseFirestore.instance
        .collection("tournaments")
        .add({
          'author': userId,
          'createdAt': DateTime.now(),
          'lat': lat,
          'lon': lon,
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
    // set up the buttons
    Widget yesButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        createTournament(userId, lat, lon);
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
      content: Text("Would you like to create a new tournament?"),
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

  void showTournament() {
    // TODO:
  }

  void updateTournament() {
    // TODO:
  }
}
