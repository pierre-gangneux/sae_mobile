import 'package:sqflite/sqflite.dart';

import 'Restaurant.dart';

class ListRestaurants{

  List<Restaurant> _currentRestaurants;
  List<Restaurant> _lesRestaurants;

  ListRestaurants() : _lesRestaurants = [], _currentRestaurants = [];

  List<Restaurant> get lesRestaurants => _lesRestaurants;
  List<Restaurant> get currentRestaurants => _currentRestaurants;


  // récupérer les restaurants depuis la base de données
  Future<List<Restaurant>> fromDatabase(Database db) async {
    // Exécuter la requête pour récupérer les données de la table RESTAURANT
    List<Map<String, dynamic>> result = await db.rawQuery('SELECT * FROM RESTAURANT;');

    // Convertir les résultats en instances de Restaurant
    List<Restaurant> restaurants = result.map((row) {
      return Restaurant(
        osmid: row['osmid'],
        nomRestaurant: row['nomrestaurant'],
        etoiles: row['etoiles'] ?? 0,
        telephone: row['telephone'],
        siret: row['siret'],
        siteInternet: row['siteinternet'],
        vegetarien: row['vegetarien'],
        vegan: row['vegan'],
        livraison: row['livraison'],
        aEmporter: row['aemporter'],
        drive: row['drive'],
        accessInternet: row['accessinternet'],
        espaceFumeur: row['espacefumeur'],
        fauteuilRoulant: row['fauteuilroulant'],
        facebook: row['facebook'],
        longitude: row['longitude'],
        latitude: row['latitude'],
      );
    }).toList();
    _lesRestaurants = restaurants;
    _currentRestaurants = restaurants;
    return restaurants;
  }

  // Méthode pour générer des restaurants d'exemple
  List<Restaurant> generateRestaurant(int i) {
    List<Restaurant> restaurants = [];
    for (int n = 0; n < i; n++) {
      restaurants.add(
        Restaurant(
          osmid: n.toString(),
          nomRestaurant: "Restaurant Exemple",
          etoiles: 5,
          telephone: "0102030405",
          siteInternet: "https://www.restaurantexemple.com",
          facebook: "https://www.facebook.com/restaurantexemple",
          vegetarien: "yes",
          vegan: "no",
          livraison: "yes",
          latitude: "48.8566",
          longitude: "2.3522",
        ),
      );
    }
    _lesRestaurants = restaurants;
    _currentRestaurants = restaurants;

    return restaurants;
  }


  Restaurant? getRestaurantById(String id) {
    return lesRestaurants.firstWhere((restaurant) => restaurant.osmid == id, orElse: null);
  }


  void setRestaurantFiltre(String nomRestau) {
    List<Restaurant> res = [];
    for (Restaurant restau in _lesRestaurants) {
      if (restau.nomRestaurant.toLowerCase().contains(nomRestau.toLowerCase())) {
        res.add(restau);
      }
    }
    _currentRestaurants = res;
  }



}
