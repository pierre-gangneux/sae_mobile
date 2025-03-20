import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<Database> initDatabase() async {
  final databasePath = await getDatabasesPath();
  final path = join(databasePath, 'bd.sql');

  return openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      String sqlScript = await rootBundle.loadString('bd.sql');
      List<String> queries = sqlScript.split(';');
      for (String query in queries) {
        if (query.trim().isNotEmpty) {
          await db.execute(query);
        }
      }
    },
  );
}
