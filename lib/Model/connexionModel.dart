import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authentification.dart';

class LoginModel {
  String username;
  String password;

  LoginModel({
    required this.username,
    required this.password,
  });

  // Hashage du mot de passe avec SHA-256
  String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  // Vérifie si l'user existe
  Future<bool> loginUser(BuildContext context, String dbPath) async {
    final Database db = await openDatabase(
      dbPath,
      version: 1,
    );

    String hashedPassword = hashPassword(password);

    try {
      final List<Map<String, dynamic>> users = await db.query(
        'UTILISATEUR',
        where: 'username = ? AND mdp = ?',
        whereArgs: [username, hashedPassword],
      );

      if (users.isNotEmpty) {
        // Si l'user existe on le mets dans la session
        await context.read<AuthState>().login(username);
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
