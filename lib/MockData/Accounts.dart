import 'dart:convert';

import 'package:checkmate/models/user.dart';

class MockAccounts {
  static List<User> accounts = [
    User.fromJSON(jsonDecode(user1Json)),
    User.fromJSON(jsonDecode(user2Json)),
    User.fromJSON(jsonDecode(user3Json))

  ];

  static String user1Json = """
  {
    "id": "1",
    "name": "John Burke",
    "bio": "Love to play chess",
    "email": "burkej15@tcd.ie",
    "age": 22,
    "imagePaths": [
      "assets/test/tinderSample1.jpg",
      "assets/test/tinderSample2.jpg"
    ],
    "abilityLevel": "Beginner"
  }
  """;

  static String user2Json = """
  {
    "id": "2",
    "name": "Homer Simpson",
    "bio": "Chess is life",
    "email": "chessguy55@gmail.com",
    "age": 42,
    "imagePaths": [
      "assets/test/tinderSample3.jpg",
      "assets/test/tinderSample4.jpg"
    ],
    "abilityLevel": "Experienced"
  }
  """;

  static String user3Json = """
  {
    "id": "3",
    "name": "John Burke Again",
    "bio": "Chessssssssssss",
    "email": "burkej16@tcd.ie",
    "age": 21,
    "imagePaths": [
      "assets/test/tinderSample2.jpg",
      "assets/test/tinderSample4.jpg"
    ],
    "abilityLevel": "Intermediate"
  }
  """;

}

// "assets/test/tinderSample1.jpg",
// "assets/test/tinderSample2.jpg",
// "assets/test/tinderSample3.jpg",
// "assets/test/tinderSample4.jpg",

