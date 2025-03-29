import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sae_mobile/Model/Restaurant.dart';
import 'package:sae_mobile/Model/listRestaurants.dart';
import 'package:sqflite/sqflite.dart';


class RestaurantViewModel extends ChangeNotifier{
  late ListRestaurants listeRestaux;

  RestaurantViewModel(Database db){
    listeRestaux= new ListRestaurants();
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

  void setRestaurantFiltre(String? nomRestau, String? categorie){
    listeRestaux.setRestaurantFiltre(nomRestau, categorie);
    notifyListeners();
  }



}
