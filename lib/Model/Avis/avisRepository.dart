import 'package:sqflite/sqflite.dart';

import '../Like.dart';
import '../Restaurant.dart';
import '../User.dart';
import 'avis.dart';
import '../listRestaurants.dart';


class AvisRepository{
  final Database db;

  const AvisRepository(this.db);

  Future<List<Avis>> getAvisUser(User user) async {
    // Exécuter la requête pour récupérer les données de la table AVIS pour l'utilisateur
    List<Map<String, dynamic>> result = await this.db.rawQuery(
        'SELECT osmid, note, commentaire FROM AVIS WHERE username=${user.username};'
    );

    List<Avis> avis = result.map((row) {
      Avis avis = Avis(user.username, row['osmid'], row['note'], row['commentaire']);
      return avis;
    }).toList();
    return avis;
  }

  Future<List<Avis?>> getAvisRestaurants(Restaurant restaurant) async {
    // Exécuter la requête pour récupérer les données de la table AVIS pour les restaurants
    List<Map<String, dynamic>> result = await this.db.rawQuery(
        'SELECT username, note, commentaire FROM AVIS WHERE osmid=${restaurant.osmid};'
    );

    // Convertir les résultats en instances de Restaurant
    List<Avis?> avis = result.map((row) {
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
      where: 'username = ${avis.username} and osmid = ${avis.osmid}'
    );
  }

  Future<void> editAvis(Avis avis) async {
    await db.update(
        'AVI',
        avis.toMap(),
        where: 'username = ${avis.username} and osmid = ${avis.osmid}'
    );
  }
}
