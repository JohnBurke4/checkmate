import 'dart:convert';

import 'package:location/location.dart';

class User {
  User(String name, String bio) {
    this.name = name;
    this.bio = bio;
    this.imagePaths = List.empty();
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
        name = json["username"] ?? "John Dow",
        bio = json["bio"] ?? "",
        email = json["email"] ?? "0",
        age = json["age"] ?? 0,
        imagePaths = json["imagePaths"] ?? List.empty(),
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