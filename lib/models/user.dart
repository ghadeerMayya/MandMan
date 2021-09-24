import 'package:flutter/cupertino.dart';

class User {
  final String imagePath;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String pharmaLocation;

  User(
      {required this.imagePath,
      required this.username,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.pharmaLocation});
}
