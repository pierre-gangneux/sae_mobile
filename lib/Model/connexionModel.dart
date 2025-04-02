import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:sqflite/sqflite.dart';

class LoginModel {
  String username;
  String password;

  LoginModel({
    required this.username,
    required this.password,
  });

  // Hashage
  String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  // Vérifie les informations d'identification dans la base de données
  Future<bool> loginUser(String dbPath) async {
    final Database db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        // Tout est déja initialisé
      },
    );

    String hashedPassword = hashPassword(password);

    try {
      // Recherche de l'utilisateur dans la base de données
      final List<Map<String, dynamic>> users = await db.query(
        'UTILISATEUR',
        where: 'username = ? AND mdp = ?',
        whereArgs: [username, hashedPassword],
      );

      if (users.isNotEmpty) {
        // Utilisateur Trouvé
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Erreur lors de la connexion : $e");
      return false;
    }
  }
}
