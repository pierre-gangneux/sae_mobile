import 'package:sqflite/sqflite.dart';

class Restaurant {
  String osmid;
  String nomRestaurant;
  String? telephone;
  String? siret;
  int etoiles;
  String? siteInternet;

  String? vegetarien;
  String? vegan;
  String? livraison;
  String? aEmporter;
  String? drive;
  String? accessInternet;

  String? espaceFumeur;
  String? fauteuilRoulant;
  String? facebook;

  String? longitude;
  String? latitude;

  // Constructeur avec validation des étoiles
  Restaurant({
    required this.osmid,
    required this.nomRestaurant,
    required this.etoiles,
    this.telephone,
    this.siret,
    this.siteInternet,
    this.vegetarien,
    this.vegan,
    this.livraison,
    this.aEmporter,
    this.drive,
    this.accessInternet,
    this.espaceFumeur,
    this.fauteuilRoulant,
    this.facebook,
    this.longitude,
    this.latitude
  });

  // Getters
  String get getOsmid => osmid;
  String get getNomRestaurant => nomRestaurant;
  int get getEtoiles => etoiles;
  String? get getTelephone => telephone;
  String? get getSiret => siret;
  String? get getSiteInternet => siteInternet;

  String? get getVegetarien => vegetarien;
  String? get getVegan => vegan;
  String? get getLivraison => livraison;
  String? get getAEmporter => aEmporter;
  String? get getDrive => drive;
  String? get getAccessInternet => accessInternet;

  String? get getEspaceFumeur => espaceFumeur;
  String? get getFauteuilRoulant => fauteuilRoulant;
  String? get getFacebook => facebook;

  String? get getLongitude => longitude;
  String? get getLatitude => latitude;

  // Méthode statique pour récupérer les restaurants depuis la base de données
  static Future<List<Restaurant>> fromDatabase(Database db) async {
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

    return restaurants;
  }

  // Méthode pour générer des restaurants d'exemple
  static List<Restaurant> generateRestaurant(int i) {
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
    return restaurants;
  }
}
