import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sae_mobile/Model/Restaurant.dart';
import 'package:sae_mobile/Model/listRestaurants.dart';
import 'package:sqflite/sqflite.dart';


class RestaurantViewModel extends ChangeNotifier{
  late ListRestaurants listeRestaux;
  late Database _db;

  RestaurantViewModel(Database db){
    listeRestaux= new ListRestaurants();
    _db = db;
    init(db);
  }


  void generateRestaurant(){
    listeRestaux.generateRestaurant(50);
    notifyListeners();
  }

  Future<void> init(Database db) async {
    await listeRestaux.fromDatabase(db);
    notifyListeners();  // Notifie les écouteurs pour que l'UI se mette à jour
  }

  Restaurant? getRestaurantById(String restaurantId){
    return listeRestaux.getRestaurantById(restaurantId);
  }

  List<Restaurant> getRestaurants(){
    return listeRestaux.currentRestaurants;
  }



  Future<void> setRestaurantFiltre(String? nomRestau, String? categorie, List<String>? options, List<String>? cuisinesSelect) async {
    await listeRestaux.setRestaurantFiltre(_db, nomRestau, categorie, options, cuisinesSelect);
    notifyListeners();
  }



}
