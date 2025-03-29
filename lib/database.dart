import 'package:flutter/material.dart';
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
