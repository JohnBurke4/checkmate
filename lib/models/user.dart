import 'dart:convert';
import 'dart:io';

import 'package:location/location.dart';

class User {
  User(String name, String bio) {
    this.name = name;
    this.bio = bio;
    this.imagePaths = <String>[];
    this.age = 0;
    this.abilityLevel = "Beginner";
    searchRange = 30;
  }
  late String? id;
  late String name;
  late String bio;
  late String? email;
  late int age;
  late List<dynamic> imagePaths;
  late String abilityLevel;
  late String chessDotComELO;
  late int searchRange;

  User.fromJSON(Map<dynamic, dynamic> json)
      : id = json["uid"] ?? "0",
        name = json["username"] ?? "John Doe",
        bio = json["bio"] ?? "",
        email = json["email"] ?? "0",
        age = json["age"] ?? 0,
        imagePaths = json["imagePaths"] ?? <String>[],
        abilityLevel = json["abilityLevel"] ?? "beginner",
        chessDotComELO = json["chessDotComELO"] ?? "Not Available";

  Map<String, Object?> toJson() => {
        'uid': id,
        'username': name,
        'bio': bio,
        'email': email,
        'age': age,
        'imagePaths': imagePaths,
        'abilityLevel': abilityLevel,
        'chessDotComELO': chessDotComELO
      };
}
