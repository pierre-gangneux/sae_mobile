import 'package:flutter/cupertino.dart';
import 'package:sae_mobile/Model/Restaurant.dart';


class RestaurantViewModel extends ChangeNotifier{
  late List<Restaurant> liste;

  RestaurantViewModel(){
    liste=[];
    generateRestaurant();
  }

  void generateRestaurant(){
    liste = Restaurant.generateRestaurant(50);
    notifyListeners();
  }

  Restaurant? getRestaurantById(String id) {
    return liste.firstWhere((restaurant) => restaurant.osmid == id, orElse: null);
  }
}