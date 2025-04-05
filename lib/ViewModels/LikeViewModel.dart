

import 'package:flutter/cupertino.dart';
import 'package:sae_mobile/Model/listRestaurants.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/Like.dart';
import '../Model/LikeRepository.dart';
import '../Model/Restaurant.dart';
import '../Model/User.dart';

class LikeViewModel extends ChangeNotifier{
  late LikeRepository _likeRepository;
  late ListRestaurants _lesRestaurant;
  late Database _db;

  LikeViewModel(Database db, ListRestaurants lesRestaurant){
    _lesRestaurant = lesRestaurant;
    _db = db;
    _likeRepository = LikeRepository(db, _lesRestaurant);
  }


  void addLike(Like like){
    //print(like.username);
    //print(like.osmid);
    _likeRepository.addLike(like);
    notifyListeners();
  }

  void removeLike(Like like){
    _likeRepository.removeLike(like);
    print(like);
    print("remove");
    notifyListeners();
  }

  Future<List<Restaurant?>> getLike(String username) {
    return _likeRepository.getLike(_db, username);
  }






}