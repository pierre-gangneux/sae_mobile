import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:sqflite/sqflite.dart';

import 'User.dart';

class LoginModel {
  String? _username;
  String? _password;
  User? _user;

  LoginModel({
    String? username,
    String? password,
  })  : _username = username,
        _password = password;

  // Getters
  String? get username => _username;
  String? get password => _password;
  User? get user => _user;

  // Setters
  set username(String? value) {
    _username = value;
  }

  set password(String? value) {
    _password = value;
  }

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
        // Tout est déja initialisée
      },
    );

    String hashedPassword = hashPassword(_password!);

    try {
      // Recherche de l'utilisateur dans la base de données
      final List<Map<String, dynamic>> users = await db.query(
        'UTILISATEUR',
        where: 'username = ? AND mdp = ?',
        whereArgs: [username, hashedPassword],
      );



      if (users.isNotEmpty) {
        // Utilisateur Trouvé
        _user=new User(username: username!, mdp: hashedPassword, estadmin: false);
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



