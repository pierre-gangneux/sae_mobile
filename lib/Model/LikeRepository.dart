import 'package:sqflite/sqflite.dart';

import 'Like.dart';
import 'Restaurant.dart';
import 'User.dart';
import 'listRestaurants.dart';


class LikeRepository{
  final Database db;
  final ListRestaurants lesRestaurant;

  const LikeRepository(this.db, this.lesRestaurant);



  Future<List<Restaurant?>> getLike(Database db, String username) async {
    // Exécuter la requête pour récupérer les données de la table RESTAURANT_FAVORIS pour l'utilisateur
    List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT osmid FROM RESTAURANT_FAVORIS WHERE username=?;',
      [username], // Paramètre pour remplacer le ?
    );

    // Convertir les résultats en instances de Restaurant
    List<Restaurant?> restaurants = result.map((row) {
      return lesRestaurant.getRestaurantById(row['osmid']);
    }).toList();

    return restaurants;
  }


  Future<void> addLike(Like like) async {
    await db.insert(
        'RESTAURANT_FAVORIS',
        like.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeLike(Like like) async {
    await db.delete(
      'RESTAURANT_FAVORIS',
      where: 'username = ? AND osmid = ?',
      whereArgs: [like.username, like.osmid],
    );
  }





}
