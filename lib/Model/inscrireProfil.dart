import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:sqflite/sqflite.dart';

class RegisterModel {
  String username;
  String password;
  String confirmPassword;

  RegisterModel({
    required this.username,
    required this.password,
    required this.confirmPassword,
  });

  bool isPasswordValid() {
    return getPasswordStrength(password) >= 0.3;
  }

  bool isPasswordConfirmed() {
    return password == confirmPassword;
  }

  double getPasswordStrength(String password) {
    if (password.isEmpty) return 0.0;

    int score = 0;
    if (password.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[a-z]').hasMatch(password)) score++;
    if (RegExp(r'\d').hasMatch(password)) score++;
    if (RegExp(r'[\W]').hasMatch(password)) score++;

    return score / 5.0;
  }

  String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  Future<bool> registerUser(String dbPath) async {
    if (!isPasswordValid() || !isPasswordConfirmed()) {
      return false; // Mot de passe invalide ou confirmation incorrecte
    }

    final Database db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        // La table est déjà supposée exister dans la base, pas besoin de CREATE TABLE ici
      },
    );

    String hashedPassword = hashPassword(password);

    try {
      await db.insert(
        'UTILISATEUR',
        {
          'username': username,
          'mdp': hashedPassword,
          'estadmin': 0,
        },
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
      return true;
    } catch (e) {
      print("Erreur lors de l'inscription : $e");
      return false;
    }
  }
}
