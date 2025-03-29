import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<Database> initDatabase() async {
  final databasePath = await getDatabasesPath();
  final path = join(databasePath, 'database.db');  // Fichier DB SQLite

  return openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      String sqlScript = await rootBundle.loadString('assets/bd.sql');
      List<String> queries = sqlScript.split(';');

      for (String query in queries) {
        if (query.trim().isNotEmpty) {
          await db.execute(query.trim() + ';');  // Assure la fin de requête
        }
      }
    },
  );
}
