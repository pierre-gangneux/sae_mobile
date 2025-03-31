import 'package:sqflite/sqflite.dart';

import 'Restaurant.dart';
import 'User.dart';
import 'listRestaurants.dart';


class UserRepository{
  final Database db;
  final ListRestaurants lesRestaurant;

  const UserRepository(this.db, this.lesRestaurant);



  Future<List<Restaurant?>> getLike(Database db, User user) async {
    // Exécuter la requête pour récupérer les données de la table RESTAURANT_FAVORIS pour l'utilisateur
    List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT osmid FROM RESTAURANT_FAVORIS WHERE username=${user.username};'
    );

    // Convertir les résultats en instances de Restaurant
    List<Restaurant?> restaurants = result.map((row) {
      return lesRestaurant.getRestaurantById(row['osmid']);
    }).toList();
    return restaurants;
  }




}
