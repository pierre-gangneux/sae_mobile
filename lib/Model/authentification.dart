import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState extends ChangeNotifier {
  bool _isSignedIn = false;
  String? _username;

  bool get isSignedIn => _isSignedIn;
  String? get username => _username;

  // Fonction qui permet de connecter l'user automatiquement
  void autoLogin(String? savedUsername) {
    if (savedUsername != null) {
      _isSignedIn = true;
      _username = savedUsername;
      notifyListeners();
    }
  }

  // Permet de se connecter et de garder l'user dnas le cache
  Future<void> login(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    _isSignedIn = true;
    _username = username;
    notifyListeners();
  }

  // Pour se déconnecter de l'appli et du cache
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    _isSignedIn = false;
    _username = null;
    notifyListeners();
  }
}
