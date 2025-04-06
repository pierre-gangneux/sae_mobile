import 'package:sqflite/sqflite.dart';

import '../Restaurant/Restaurant.dart';
import 'avis.dart';


class AvisRepository{
  final Database db;

  const AvisRepository(this.db);

  Future<List<Avis>> getAvisUser(String username) async {
    List<Map<String, dynamic>> result = await db.query(
      'AVIS',
      columns: [
        'osmid', 'note', 'commentaire'
      ],
      where: 'username = ?',
      whereArgs: [username]
    );
    List<Avis> avis = result.map((row) {
      Avis avis = Avis(username, row['osmid'], row['note'], row['commentaire']);
      return avis;
    }).toList();
    return avis;
  }

  Future<List<Avis>> getAvisRestaurants(Restaurant restaurant) async {
    List<Map<String, dynamic>> result = await db.query(
      'AVIS',
      columns: [
        'username', 'note', 'commentaire'
      ],
      where: 'osmid = ?',
      whereArgs: [restaurant.osmid]
    );
    List<Avis> avis = result.map((row) {
      return Avis(row['username'], restaurant.osmid, row['note'], row['commentaire']);
    }).toList();
    return avis;
  }

  Future<void> addAvis(Avis avis) async {
    await db.insert(
      'AVIS',
      avis.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeAvis(Avis avis) async {
    await db.delete(
      'AVIS',
      where: 'username = ? and osmid = ?',
      whereArgs: [avis.username, avis.osmid]
    );
  }

  Future<void> editAvis(Avis avis) async {
    await db.update(
      'AVIS',
      avis.toMap(),
      where: 'username = ? and osmid = ?',
      whereArgs: [avis.username, avis.osmid],
    );
  }
}
