import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sae_mobile/Model/Cuisine/CuisineRepository.dart';
import 'package:sae_mobile/Model/Restaurant/Restaurant.dart';
import 'package:sae_mobile/Model/Restaurant/restaurantRepository.dart';
import 'package:sqflite/sqflite.dart';

import 'restaurantRepository.mocks.dart';



@GenerateMocks([
  Database,
  CuisineRepository,
])
void main() {
  group('RestaurantRepository', () {
    late RestaurantRepository repository;
    late Restaurant restau;

    setUp(() {
      repository = RestaurantRepository();
      restau = Restaurant(
        osmid: '001',
        nomRestaurant: 'Testaurant',
        type: 'fast_food',
        etoiles: 4,
        vegetarien: 'yes',
        vegan: 'no',
        livraison: 'yes',
        aEmporter: 'yes',
        drive: 'no',
        accessInternet: 'yes',
        fauteuilRoulant: 'yes',
        espaceFumeur: 'no',
      );

      repository.lesRestaurants.add(restau);
    });

    test('test de sameCategorie', () {
      expect(repository.sameCategorie("Fast_food", "fast_food"), true);
      expect(repository.sameCategorie("Café", "cafe"), true);
      expect(repository.sameCategorie("", "cafe"), true);
      expect(repository.sameCategorie("Brasserie", "fast_food"), false);
    });

    test('test optionPresent', () {
      expect(repository.optionPresent(restau, ["vegetarien", "livraison"]), true);
      expect(repository.optionPresent(restau, ["vegan"]), false);
      expect(repository.optionPresent(restau, ["fauteuilroulant"]), true);
      expect(repository.optionPresent(restau, ["drive"]), false);
    });

    test('test cuisinePresent', () {
      List<String> cuisines = ["Italienne", "Française", "Japonaise"];

      expect(repository.cuisinePresent(cuisines, null), true);
      expect(repository.cuisinePresent(cuisines, []), true);
      expect(repository.cuisinePresent(cuisines, ["Française"]), true);
      expect(repository.cuisinePresent(cuisines, ["Chinoise"]), false);
    });

    test('test getRestaurantById', () {
      final result = repository.getRestaurantById('001');
      expect(result, isNotNull);
      expect(result!.nomRestaurant, 'Testaurant');

      final nullResult = repository.getRestaurantById('999');
      expect(nullResult, isNull);
    });
  });


  test('setRestaurantFiltre filters by nomRestaurant', () async {
    // Mock Database
    final mockDb = MockDatabase();

    // Mock CuisineRepository
    final mockCuisineRepo = MockCuisineRepository();
    when(mockCuisineRepo.getCuisinesRestaurant()).thenReturn(['Italien']);
    when(mockCuisineRepo.loadCuisinesRestaurant(any)).thenAnswer((_) async {});

    // Créer une instance du repository
    final repo = RestaurantRepository();

    // Injecter les restaurants manuellement
    repo.lesRestaurants.addAll([
      Restaurant(
        osmid: '001',
        nomRestaurant: 'Le Bon Burger',
        type: 'fast_food',
        etoiles: 3,
        vegetarien: 'yes',
        vegan: 'no',
        livraison: 'yes',
        aEmporter: 'yes',
        drive: 'no',
        accessInternet: 'yes',
        fauteuilRoulant: 'yes',
        latitude: "0",
        longitude: "0",
      ),
      Restaurant(
        osmid: '002',
        nomRestaurant: 'Chez Veganou',
        type: 'restaurant',
        etoiles: 5,
        vegetarien: 'yes',
        vegan: 'yes',
        livraison: 'no',
        aEmporter: 'yes',
        drive: 'no',
        accessInternet: 'yes',
        fauteuilRoulant: 'no',
        latitude: "0",
        longitude: "0",
      ),
    ]);

    // Appeler la méthode à tester avec le mock CuisineRepository injecté
    await repo.setRestaurantFiltre(
      mockDb,
      'burger', // On cherche "burger"
      null, // Pas de filtre sur la catégorie
      null, // Pas d'options
      null, // Pas de cuisine spécifique
      mockCuisineRepo, // Injection du mock de CuisineRepository ici
    );

    // Vérification
    expect(repo.currentRestaurants.length, 1);  // Un seul restaurant correspondant
    expect(repo.currentRestaurants.first.nomRestaurant, contains('Burger'));  // Il doit contenir "Burger"
  });


  test('setRestaurantFiltre filters by categorie', () async {
    // Mock Database
    final mockDb = MockDatabase();

    // Mock CuisineRepository
    final mockCuisineRepo = MockCuisineRepository();
    when(mockCuisineRepo.getCuisinesRestaurant()).thenReturn(['Italien']);
    when(mockCuisineRepo.loadCuisinesRestaurant(any)).thenAnswer((_) async {});

    // Créer une instance du repository
    final repo = RestaurantRepository();

    // Injecter les restaurants manuellement
    repo.lesRestaurants.addAll([
      Restaurant(
        osmid: '001',
        nomRestaurant: 'Le Bon Burger',
        type: 'fast_food',
        etoiles: 3,
        vegetarien: 'yes',
        vegan: 'no',
        livraison: 'yes',
        aEmporter: 'yes',
        drive: 'no',
        accessInternet: 'yes',
        fauteuilRoulant: 'yes',
        latitude: "0",
        longitude: "0",
      ),
      Restaurant(
        osmid: '002',
        nomRestaurant: 'Chez Veganou',
        type: 'restaurant',
        etoiles: 5,
        vegetarien: 'yes',
        vegan: 'yes',
        livraison: 'no',
        aEmporter: 'yes',
        drive: 'no',
        accessInternet: 'yes',
        fauteuilRoulant: 'no',
        latitude: "0",
        longitude: "0",
      ),
    ]);

    // Appeler la méthode à tester avec le mock CuisineRepository injecté
    await repo.setRestaurantFiltre(
      mockDb,
      null, // Pas de filtre sur le nom
      'restaurant', // Filtrer par "restaurant"
      null, // Pas d'options
      null, // Pas de cuisine spécifique
      mockCuisineRepo, // Injection du mock de CuisineRepository ici
    );

    // Vérification
    expect(repo.currentRestaurants.length, 1);  // Un seul restaurant de type "restaurant"
    expect(repo.currentRestaurants.first.nomRestaurant, 'Chez Veganou');  // Le restaurant doit être "Chez Veganou"
  });


  test('setRestaurantFiltre filters by options', () async {
    // Mock Database
    final mockDb = MockDatabase();

    // Mock CuisineRepository
    final mockCuisineRepo = MockCuisineRepository();
    when(mockCuisineRepo.getCuisinesRestaurant()).thenReturn(['Italien']);
    when(mockCuisineRepo.loadCuisinesRestaurant(any)).thenAnswer((_) async {});


    // Créer une instance du repository
    final repo = RestaurantRepository();

    // Injecter les restaurants manuellement
    repo.lesRestaurants.addAll([
      Restaurant(
        osmid: '001',
        nomRestaurant: 'Le Bon Burger',
        type: 'fast_food',
        etoiles: 3,
        vegetarien: 'yes',
        vegan: 'no',
        livraison: 'yes',
        aEmporter: 'yes',
        drive: 'no',
        accessInternet: 'yes',
        fauteuilRoulant: 'yes',
        latitude: "0",
        longitude: "0",
      ),
      Restaurant(
        osmid: '002',
        nomRestaurant: 'Chez Veganou',
        type: 'restaurant',
        etoiles: 5,
        vegetarien: 'no',
        vegan: 'yes',
        livraison: 'no',
        aEmporter: 'yes',
        drive: 'no',
        accessInternet: 'yes',
        fauteuilRoulant: 'no',
        latitude: "0",
        longitude: "0",
      ),
    ]);

    // Appeler la méthode à tester avec le mock CuisineRepository injecté
    await repo.setRestaurantFiltre(
      mockDb,
      null, // Pas de filtre sur le nom
      null, // Pas de filtre sur la catégorie
      ['vegetarien'], // Filtrer les restaurants végétariens
      null, // Pas de cuisine spécifique
      mockCuisineRepo, // Injection du mock de CuisineRepository ici
    );

    // Vérification
    expect(repo.currentRestaurants.length, 1);  // Un seul restaurant végétarien
    expect(repo.currentRestaurants.first.nomRestaurant, 'Le Bon Burger');  // Il doit être "Le Bon Burger"
  });

  test('setRestaurantFiltre filters by selectCuisines', () async {
    // Mock Database
    final mockDb = MockDatabase();

    // Mock CuisineRepository
    final mockCuisineRepo = MockCuisineRepository();
    when(mockCuisineRepo.getCuisinesRestaurant()).thenReturn(['Italien']);
    when(mockCuisineRepo.loadCuisinesRestaurant(any)).thenAnswer((_) async {});

    // Créer une instance du repository
    final repo = RestaurantRepository();

    // Injecter les restaurants manuellement
    repo.lesRestaurants.addAll([
      Restaurant(
        osmid: '001',
        nomRestaurant: 'Le Bon Burger',
        type: 'fast_food',
        etoiles: 3,
        vegetarien: 'yes',
        vegan: 'no',
        livraison: 'yes',
        aEmporter: 'yes',
        drive: 'no',
        accessInternet: 'yes',
        fauteuilRoulant: 'yes',
        latitude: "0",
        longitude: "0",
      ),
      Restaurant(
        osmid: '002',
        nomRestaurant: 'Chez Veganou',
        type: 'restaurant',
        etoiles: 5,
        vegetarien: 'yes',
        vegan: 'yes',
        livraison: 'no',
        aEmporter: 'yes',
        drive: 'no',
        accessInternet: 'yes',
        fauteuilRoulant: 'no',
        latitude: "0",
        longitude: "0",
      ),
    ]);

    // Appeler la méthode à tester avec le mock CuisineRepository injecté
    await repo.setRestaurantFiltre(
      mockDb,
      null, // Pas de filtre sur le nom
      null, // Pas de filtre sur la catégorie
      null, // Pas d'options
      ['Italien'], // Filtrer par cuisine "Italien"
      mockCuisineRepo, // Injection du mock de CuisineRepository ici
    );

    // Vérification
    expect(repo.currentRestaurants.length, 2);  // Un seul restaurant avec la cuisine "Italien"
  });




}
