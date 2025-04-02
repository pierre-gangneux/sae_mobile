import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart' show rootBundle;

// Fonction pour initialiser la base de données
Future<Database> initDatabase() async {
  final databasePath = await getDatabasesPath();
  final path = join(databasePath, 'database.db');  // Fichier DB SQLite

  return openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      // Charger le script SQL depuis les assets
      String sqlScript = await rootBundle.loadString('assets/bd.sql');
      List<String> queries = sqlScript.split(';');

      // Exécuter chaque requête dans le script SQL
      for (String query in queries) {
        if (query.trim().isNotEmpty) {
          await db.execute(query.trim() + ';');  // Assure la fin de la requête
        }
      }
      print("Base de données et tables créées avec succès !");
      showTables(db);
    },
  );
}
Future<void> showTables(Database db) async {
  // Liste les tables dans la base de données SQLite
  List<Map<String, dynamic>> result = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table';");
  result.forEach((table) {
    print('Table: ${table['name']}');
  });
}


Future<Database> populateDatabase() async {
  final Database db = await initDatabase();

  // Charger le fichier JSON depuis les assets
  String jsonString = await rootBundle.loadString('/restaurants.json');
  List<dynamic> jsonData = jsonDecode(jsonString);

  // Insérer les données dans la base de données
  for (var item in jsonData) {
    await insertRestaurant(db, item);
  }
  print("Base de données remplie avec succès !");
  /*showRestaurant(db);*/
  return db;
}

Future<void> insertRestaurant(Database db, Map<String, dynamic> item) async {
  await db.insert(
    'RESTAURANT',
    {
      'osmid': item['osm_id'],
      'nomrestaurant': item['name'],
      'telephone': item['phone'],
      'siret': item['siret'],
      'etoiles': item['stars'],
      'siteinternet': item['website'],
      'codecommune': item['code_commune'],
      'vegetarien': item['vegetarian'],
      'vegan': item['vegan'],
      'livraison': item['delivery'],
      'aemporter': item['takeaway'],
      'drive': item['drive_through'],
      'accessinternet': item['internet_access'] is List ? item['internet_access'].join(', ') : item['internet_access'],
      'capacite': item['capacity'],
      'marque': item['brand'],
      'operateur': item['operator'],
      'type': item['type'],
      'wikidata': item['wikidata'],
      'marquewikidata': item['brand_wikidata'],
      'espacefumeur': item['smoking'],
      'fauteuilroulant': item['wheelchair'],
      'facebook': item['facebook'],
      'longitude': item['geo_point_2d']?['lon'].toString(),
      'latitude': item['geo_point_2d']?['lat'].toString(),
    },
    conflictAlgorithm: ConflictAlgorithm.replace, //Si meme primary key alors mets à jour les données de la primlary key

  );
}


Future<void> showRestaurant(Database db) async {
  // Liste toutes les entrées de la table RESTAURANT
  List<Map<String, dynamic>> result = await db.rawQuery("SELECT * FROM RESTAURANT;");

  // Affiche chaque ligne de la table
  result.forEach((row) {
    // Affiche toutes les colonnes pour chaque ligne
    print('Restaurant: $row');
  });
}
