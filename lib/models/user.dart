import 'dart:convert';

import 'package:location/location.dart';

class User {
  User(this.name, this.bio, this.age, this.abilityLevel);
  late String? id;
  late String name;
  late String bio;
  late String? email;
  late int age;
  late List<dynamic> imagePaths;
  late Enum abilityLevel;
  late String location;

  User.fromJSON(Map<dynamic, dynamic> json)
      : id = json["uid"] ?? "0",
        name = json["username"] ?? "John Dow",
        bio = json["bio"] ?? "",
        email = json["email"] ?? "0",
        age = json["age"] ?? 0,
        imagePaths = json["imagePaths"] ?? List.empty(),
        abilityLevel = json["abilityLevel"] ?? "beginner",
        location = json["location"] ?? "0";

  Map<String, dynamic> toJson() => {
        'uid': id,
        'username': name,
        'bio': bio,
        'email': email,
        // 'age': age,
        // 'imagePaths': imagePaths,
        // 'abilityLevel' : abilityLevel,
        // 'location' : location
      };
}

 enum chessAbility { Beginner, Intermediate, Experienced, Master }
