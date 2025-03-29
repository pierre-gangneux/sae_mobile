import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sae_mobile/Model/Restaurant.dart';
import 'package:sqflite/sqflite.dart';


class RestaurantViewModel extends ChangeNotifier{
  late List<Restaurant> liste;

  RestaurantViewModel(Database db){
    liste=[];
    //generateRestaurant();
    init(db);
  }

  void generateRestaurant(){
    liste = Restaurant.generateRestaurant(50);
    notifyListeners();
  }

  Future<void> init(Database db) async {
    liste = await Restaurant.fromDatabase(db);
    notifyListeners();  // Notifie les écouteurs pour que l'UI se mette à jour
  }

  Restaurant? getRestaurantById(String id) {
    return liste.firstWhere((restaurant) => restaurant.osmid == id, orElse: null);
  }
}