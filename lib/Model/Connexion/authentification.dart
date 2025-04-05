import 'package:flutter/foundation.dart';

//Class pour verifier si l'utilisateur est connecté ou pas
class AuthState extends ChangeNotifier {
  bool _isSignedIn = false;

  bool get isSignedIn => _isSignedIn;

  void signIn() {
    _isSignedIn = true;
    notifyListeners();
  }

  void signOut() {
    _isSignedIn = false;
    notifyListeners();
  }
}
