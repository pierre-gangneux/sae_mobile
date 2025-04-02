

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
  }

  setUsername(String username){
    connexion.username = username;
  }

  setPassword(String password){
    connexion.password = password;
  }

  loginUser(String dbPath) async {
    bool co = await connexion.loginUser(dbPath);
    notifyListeners();
    return co;
  }

  User? getUser(){
    return connexion.user;
  }






}