import 'package:flutter/cupertino.dart';
import 'package:sae_mobile/Model/Restaurant/Restaurant.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/Restaurant/restaurantRepository.dart';


class RestaurantViewModel extends ChangeNotifier{
  late RestaurantRepository restauRep;
  late Database _db;
  late List<String> _listOsmid;

  RestaurantViewModel(Database db){
    restauRep= RestaurantRepository();
    _db = db;
    _listOsmid  = [];
    init(db);
  }


  getViewedOsmid() async {
    _listOsmid = await restauRep.getViewedOsmid();
    notifyListeners();
  }


  Future<void> init(Database db) async {
    await restauRep.fromDatabase(db);
    await getViewedRestaurants();
  }

  Restaurant? getRestaurantById(String restaurantId){
    return restauRep.getRestaurantById(restaurantId);
  }

  List<Restaurant> getRestaurants(){
    return restauRep.lesRestaurants;
  }

  List<Restaurant> getCurrentRestaurants(){
    return restauRep.currentRestaurants;
  }


  Future<void> setRestaurantFiltre(String? nomRestau, String? categorie, List<String>? options, List<String>? cuisinesSelect) async {
    await restauRep.setRestaurantFiltre(_db, nomRestau, categorie, options, cuisinesSelect, null);
    notifyListeners();
  }

  void saveRestaurant(String osmid) async {
    restauRep.saveRestaurant(osmid);
    notifyListeners();
  }


  Future<List<Restaurant>> getViewedRestaurants() async {

    // Récupérer la liste des osmid des restaurants consultés
    await getViewedOsmid();

    // Si la liste est vide, retourner une liste vide de Restaurant
    if (_listOsmid.isEmpty) {
      return [];
    }

    // Utiliser les osmid pour récupérer les informations complètes des restaurants
    List<Restaurant> viewedRestaurants = [];
    for (String osmid in _listOsmid) {
      Restaurant? restaurant = restauRep.getRestaurantById(osmid);
      if (restaurant != null) {
        viewedRestaurants.add(restaurant);
      }
    }

    return viewedRestaurants;
  }



}
