import 'package:sqflite/sqflite.dart';

import 'Like.dart';
import 'Restaurant.dart';
import 'User.dart';
import 'listRestaurants.dart';


class CuisineRepository{
  final Database db;

  const CuisineRepository(this.db);



  Future<List<String?>> getCuisine(Database db) async {
    // Exécuter la requête pour récupérer les données de la table CUISINE
    List<Map<String, dynamic>> result = await db.rawQuery('SELECT nomcuisine FROM CUISINE;');

    // Convertir les résultats en une liste de noms de cuisine
    List<String?> cuisines = result.map((row) => row['nomcuisine'] as String?).toList();

    return cuisines;
  }





}
