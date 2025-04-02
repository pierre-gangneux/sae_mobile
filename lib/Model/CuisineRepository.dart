import 'package:sqflite/sqflite.dart';

class CuisineRepository {
  final Database db;
  List<String> cuisines = [];

  CuisineRepository(this.db);

  Future<void> loadCuisines() async {
    List<Map<String, dynamic>> result = await db.rawQuery('SELECT nomcuisine FROM CUISINE;');
    cuisines = result.map((row) => row['nomcuisine'] as String).toList();
  }

  List<String> getCuisines() {
    return cuisines;
  }
}
