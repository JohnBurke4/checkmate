import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Tournament {
  // final double lat;
  // final double lon;
  // final String userId;
  // final int numPlayer;

  Tournament();

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
        double latDif = (doc['lat'] - lat).abs();
        double lonDif = (doc['lon'] - lon).abs();
        if (latDif < 0.0003 && lonDif < 0.0005) {
          doc.reference.delete();
        }
      }
      print("Tournamet updated for user: $userId");
    }).catchError((error) => print("Failed to update tournamet: $error"));
  }
}
