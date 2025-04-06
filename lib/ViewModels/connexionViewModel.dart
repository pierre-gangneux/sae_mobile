import 'package:flutter/cupertino.dart';
import '../Model/Connexion/connexionModel.dart';

class ConnexionViewModel extends ChangeNotifier{
  late LoginModel connexion;

  ConnexionViewModel(){
    connexion = LoginModel();
    notifyListeners();
  }

  setUsername(String username){
    connexion.username = username;
    notifyListeners();
  }

  setPassword(String password){
    connexion.password = password;
    notifyListeners();
  }

  loginUser(BuildContext context, String dbPath) async {
    bool co = await connexion.loginUser(context, dbPath);
    notifyListeners();
    return co;
  }

  String? getUsername(){
    return connexion.username;
  }


}