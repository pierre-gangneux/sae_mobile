import 'package:sae_mobile/Model/Restaurant/Restaurant.dart';
import 'package:sqflite/sqflite.dart';

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

}
