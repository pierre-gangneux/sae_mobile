import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState with ChangeNotifier {
  bool _isSignedIn = false;

  bool get isSignedIn => _isSignedIn;


  // Méthode pour enregistrer l'état de la session après l'inscription
  Future<void> _saveUserSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true); // Enregistrer l'utilisateur comme connecté
  }

  // Méthode pour vérifier l'état de la connexion au démarrage
  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isSignedIn = prefs.getBool('isSignedIn') ?? false;  // Si la clé n'existe pas, retourne false
    notifyListeners();
  }

  // Méthode pour se connecter
  Future<void> signIn(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSignedIn', true);  // Enregistre l'état de la connexion
    _isSignedIn = true;
    notifyListeners();
  }

  // Méthode pour se déconnecter
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSignedIn', false);  // Réinitialise l'état de la connexion
    _isSignedIn = false;
    notifyListeners();
  }

}
