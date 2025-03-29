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





}
