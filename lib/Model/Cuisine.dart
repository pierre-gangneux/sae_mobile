import 'package:sqflite/sqflite.dart';

import 'Restaurant.dart';

class Cuisine {
  String nomCuisine;


  Cuisine({
    required this.nomCuisine,
  });

  // Getters
  String get getNomCuisine => nomCuisine;

}
