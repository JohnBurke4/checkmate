import 'package:location/location.dart';

class User{
  User(String name, String bio){
    this.name = name;
    this.bio = bio;
  }
  late String id;
  late String name;
  late String bio;
  late String email;
  late int age;
  late List<String> imagePaths;
  late String abilityLevel;
  late String location;

  User.fromJSON(Map<dynamic, dynamic> json):
        id = json["id"] ?? "0",
        name = json["name"] ?? "John Dow",
        bio = json["bio"] ?? "",
        email = json["email"] ?? "0",
        age = json["age"] ?? 0,
        imagePaths = List<String>.from(json["imagePaths"]),
        abilityLevel = json["abilityLevel"] ?? "beginner",
        location = json["location"] ?? "0";
}

enum chessAbility{
  beginner,
  intermediate,
  experienced
}