import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _username = 'username';

  // Garder l'user connecté
  static Future<void> saveUser(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_username, username);
  }

  static Future<String?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_username);
  }

  // Pour déconnecter
  static Future<void> clearUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_username);
  }
}
