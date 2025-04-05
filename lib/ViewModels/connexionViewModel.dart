

import 'package:flutter/cupertino.dart';
import 'package:sae_mobile/Model/listRestaurants.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/Like.dart';
import '../Model/LikeRepository.dart';
import '../Model/User.dart';
import '../Model/connexionModel.dart';

class ConnexionViewModel extends ChangeNotifier{
  late LoginModel connexion;

  ConnexionViewModel(){
    connexion = new LoginModel();
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