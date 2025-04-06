import 'package:sae_mobile/Model/Restaurant/Restaurant.dart';
import 'package:sqflite/sqflite.dart';

import 'Cuisine.dart';

class CuisineRepository {
  final Database db;
  List<String> cuisines = [];
  List<String> cuisinesRestaurant = [];

  CuisineRepository(this.db);

  Future<void> loadCuisines() async {
    List<Map<String, dynamic>> result = await db.rawQuery('SELECT nomcuisine FROM CUISINE;');
    cuisines = result.map((row) => row['nomcuisine'] as String).toList();
  }

  Future<void> loadCuisinesRestaurant(Restaurant restaurant) async {
    List<Map<String, dynamic>> result = await db.rawQuery('SELECT nomcuisine FROM CUISINE_RESTAURANT WHERE osmid=${restaurant.osmid};');
    cuisinesRestaurant = result.map((row) => row['nomcuisine'] as String).toList();
  }

  List<String> getCuisines() {
    return cuisines;
  }

  List<String> getCuisinesRestaurant() {
    return cuisinesRestaurant;
  }


  Future<Set<String>> getOsmidRestaurants(List<String> selectCuisines) async {
    final Set<String> restaux = {};

    for (var cuisine in selectCuisines) {
      final List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT osmid FROM CUISINE_RESTAURANT WHERE nomcuisine = ?',
        [cuisine],
      );

      for (var row in result) {
        restaux.add(row['osmid'].toString());
      }
    }

    return restaux;
  }

}
