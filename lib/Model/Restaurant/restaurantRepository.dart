import 'package:sqflite/sqflite.dart';

import '../Cuisine/CuisineRepository.dart';
import 'Restaurant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantRepository{

  List<Restaurant> _currentRestaurants;
  List<Restaurant> _lesRestaurants;

  RestaurantRepository() : _lesRestaurants = [], _currentRestaurants = [];

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



  Restaurant? getRestaurantById(String id) {
    for (var restaurant in lesRestaurants) {
      if (restaurant.osmid == id) {
        return restaurant;
      }
    }
    return null;
  }





  Future<void> setRestaurantFiltre(Database db, String? nomRestau, String? categorie, List<String>?options, List<String>? selectCuisines, CuisineRepository? injectedCR) async { // Paramètre optionnel pour l'injection test
    // Si injectedCR est null, on crée une nouvelle instance de CuisineRepository
    CuisineRepository CR = injectedCR ?? CuisineRepository(db);
    List<Restaurant> res = [];
    for (Restaurant restau in _lesRestaurants) {
      await CR.loadCuisinesRestaurant(restau);
      List<String> cuisinesRestau = CR.getCuisinesRestaurant();
      if (
      (nomRestau == null || restau.nomRestaurant.toLowerCase().contains(nomRestau.toLowerCase()) )
      && (categorie == null || sameCategorie(categorie, restau.type))
      && (options == null || optionPresent(restau, options))
      && cuisinePresent(cuisinesRestau ,selectCuisines)
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

  bool cuisinePresent(List<String> cuisines, List<String>? selectCuisines) {
    if (selectCuisines == null || selectCuisines.isEmpty) {
      return true; // Aucun filtre appliqué sur les cuisines
    }

    for (String selected in selectCuisines) {
      if (cuisines.contains(selected)) {
        return true; // Une correspondance trouvée
      }
    }
    return false; // Aucune correspondance trouvée
  }



  void saveRestaurant(String osmid) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    List<String> viewedRestaurants = await getViewedOsmid();

    // Si le restaurant existe déjà, on le supprime de la liste avant de le remettre au début
    if (viewedRestaurants.contains(osmid)) {
      viewedRestaurants.remove(osmid);  // Supprime l'élément existant
    }

    // Ajouter le restaurant (osmid) au début de la liste
    viewedRestaurants.insert(0, osmid);

    // Sauvegarder la liste mise à jour dans SharedPreferences
    await sharedPreferences.setStringList('viewedRestaurants', viewedRestaurants);
  }


  Future<List<String>> getViewedOsmid() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // Récupérer la liste des restaurants consultés ou une liste vide si aucune donnée n'est disponible
    List<String> viewedOsmid = sharedPreferences.getStringList('viewedRestaurants') ?? [];

    return viewedOsmid;
  }

  List<Restaurant> getRestaurantsInBounds({
    required double minLatitude,
    required double maxLatitude,
    required double minLongitude,
    required double maxLongitude,
  }) {
    return _lesRestaurants.where((restaurant) {
      final double? latitude = double.tryParse(restaurant.latitude ?? '');
      final double? longitude = double.tryParse(restaurant.longitude ?? '');

      if (latitude == null || longitude == null) {
        return false; // Skip restaurants with invalid coordinates
      }

      return latitude >= minLatitude &&
          latitude <= maxLatitude &&
          longitude >= minLongitude &&
          longitude <= maxLongitude;
    }).toList();
  }

}
