import 'package:location/location.dart';

class User{
  late String imagePath;
  late String name;
  late String bio;
  late String _email;

  late int age;
  late int _ID;

  late chessAbility abilityLevel;

  late Location location;
}

enum chessAbility{
  beginner,
  intermediate,
  experienced
}