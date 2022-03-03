import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'dart:developer';

class UserCoordinate<T1, T2> {
  final String userId;
  final T1 lat;
  final T2 lon;

  UserCoordinate(this.userId, this.lat, this.lon);
}

class UserLocation {
  final List<UserCoordinate> coordinates = [];

  LocationData? _currentPosition;
  Location location = new Location();
  String location_id = 'X722uMAdIefDkVj3nqam';

  UserLocation({Key? key});

  List<UserCoordinate> getCoordinates() {
    return coordinates;
  }

  fetchLocation(String userId, bool isUserExist) async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentPosition = await location.getLocation();

    if (isUserExist) {
      // Existed User
      print("User ID exists in firebase.");
      FirebaseFirestore.instance
          .collection("location")
          .doc(location_id)
          .collection("user_location")
          .where("author", isEqualTo: userId)
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.update({
            'createdAt': DateTime.now(),
            'lat': _currentPosition!.latitude,
            'lon': _currentPosition!.longitude,
          });
        }
        print("User location updated.");
      }).catchError((error) => print("Failed to update user location: $error"));
    } else {
      // New User
      FirebaseFirestore.instance
          .collection("location")
          .doc(location_id)
          .collection("user_location")
          .add({
            'author': userId,
            'createdAt': DateTime.now(),
            'lat': _currentPosition!.latitude,
            'lon': _currentPosition!.longitude,
          })
          .then((value) => print("User Location Added"))
          .catchError((error) => print("Failed to add user location: $error"));
    }
  }

  Future<UserCoordinate> loadCurrentUserLocation(String userId) async {
    UserCoordinate currentUser = UserCoordinate(userId, 0, 0); // Default
    await FirebaseFirestore.instance
        .collection("location")
        .doc(location_id)
        .collection("user_location")
        .where("author", isEqualTo: userId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        currentUser = UserCoordinate(doc['author'], doc["lat"], doc["lon"]);
      }
    });
    return currentUser;
  }

  Future<List> loadOtherUsersLocation(String userId) async {
    List<UserCoordinate> data = [];
    await FirebaseFirestore.instance
        .collection("location")
        .doc(location_id)
        .collection("user_location")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['author'] != userId) {
          data.add(UserCoordinate(doc['author'], doc["lat"], doc["lon"]));
        }
      }
    });
    return data;
  }

  Future<bool> isUserExists(String userId) async {
    print("Checking user existence.");
    return await FirebaseFirestore.instance
        .collection("location")
        .doc(location_id)
        .collection("user_location")
        .where("author", isEqualTo: userId)
        .get()
        .then((value) => value.size > 0 ? true : false);
  }

  double deg2rad(deg) {
    return deg * (pi / 180);
  }

  double calculateDistance(UserCoordinate u1, UserCoordinate u2) {
    var R = 6371; // Radius of the earth in km
    var dLat = deg2rad(u2.lat - u1.lat); // deg2rad below
    var dLon = deg2rad(u2.lon - u1.lon);
    var a = sin(dLat / 2) * sin(dLat / 2) +
        cos(deg2rad(u1.lat)) *
            cos(deg2rad(u2.lat)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var d = R * c; // Distance in km
    return d;
  }
}
