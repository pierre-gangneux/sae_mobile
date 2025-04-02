import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authentification.dart'; // Assurez-vous d'importer AuthState

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
  Future<bool> loginUser(BuildContext context, String dbPath) async {
    final Database db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        // Tout est déja initialisée
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
        // Utilisateur trouvé, mettre à jour l'état de connexion
        Provider.of<AuthState>(context, listen: false).signIn();
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
