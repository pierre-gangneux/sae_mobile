import 'package:flutter/cupertino.dart';
import 'package:sae_mobile/Model/listRestaurants.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/Like.dart';
import '../Model/LikeRepository.dart';

class LikeViewModel extends ChangeNotifier{
  late LikeRepository _likeRepository;
  late ListRestaurants _lesRestaurant;
  LikeViewModel(Database db, ListRestaurants lesRestaurant){
    _lesRestaurant = lesRestaurant;
    _likeRepository = LikeRepository(db, _lesRestaurant);
  }

  void addLike(Like like){
    //print(like.username);
    //print(like.osmid);
    _likeRepository.addLike(like);
    notifyListeners();
  }
}