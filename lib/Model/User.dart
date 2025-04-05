import 'package:sqflite/sqflite.dart';

import 'Restaurant/Restaurant.dart';

class User {
  String username;
  String mdp;
  bool estadmin;


  User({
    required this.username,
    required this.mdp,
    required this.estadmin
  });

  // Getters
  String get getUsername => username;
  String get getMdp => mdp;
  bool get isAdmin => estadmin;







}
