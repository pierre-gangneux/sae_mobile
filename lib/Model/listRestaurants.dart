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
        type: row["type"],
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
          type: "Restaurant",
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


  void setRestaurantFiltre(String? nomRestau, String? categorie, List<String>?options) {
    List<Restaurant> res = [];
    for (Restaurant restau in _lesRestaurants) {
      if (
      (nomRestau == null || restau.nomRestaurant.toLowerCase().contains(nomRestau.toLowerCase()))
      && (categorie == null || sameCategorie(categorie, restau.type))
      && (options == null || optionPresent(restau, options))
      ) {
        res.add(restau);
      }
    }
    _currentRestaurants = res;
  }

  bool sameCategorie(String viewCat, String  modType){
    if (viewCat.toLowerCase() == modType.toLowerCase()){
      return true;
    }
    else if(
      (modType == "cafe" && viewCat == "Café")
      || (modType == "fast_food" && viewCat == "Fast_food")
      || viewCat == ""
    ){
      return true;
    }
    return false;
  }

  bool optionPresent(Restaurant restau, List<String> options) {
    print(restau.fauteuilRoulant);
    if (options.contains("vegetarien") && (restau.vegetarien != "yes")) return false;
    if (options.contains("vegan") && (restau.vegan != "yes")) return false;
    if (options.contains("espaceFumeur") && (restau.espaceFumeur != "yes")) return false;
    if (options.contains("livraison") && (restau.livraison != "yes")) return false;
    if (options.contains("aEmporter") && (restau.aEmporter != "yes")) return false;
    if (options.contains("drive") && (restau.drive != "yes")) return false;
    if (options.contains("accessInternet") && (restau.accessInternet != "yes")) return false;
    if (options.contains("fauteuilroulant") && (restau.fauteuilRoulant != "yes")) return false;

    return true; // Si aucune condition n'a retourné false, alors toutes les options sont respectées.
  }


}
