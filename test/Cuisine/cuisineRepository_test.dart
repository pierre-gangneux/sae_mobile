import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sae_mobile/Model/Cuisine/CuisineRepository.dart';
import 'package:sae_mobile/Model/Restaurant/Restaurant.dart';

import '../Restaurant/restaurantRepository.mocks.dart';

void main() {
  group('CuisineRepository', () {
    // Mock Database
    final mockDb = MockDatabase();

    // Test pour la méthode getCuisines
    test('test getCuisines', () async {
      // Setup du mock pour retourner des données simulées
      when(mockDb.rawQuery('SELECT nomcuisine FROM CUISINE;'))
          .thenAnswer((_) async => [
        {'nomcuisine': 'Italien'},
        {'nomcuisine': 'Français'},
      ]);

      final cuisineRepo = CuisineRepository(mockDb);

      // Appel de loadCuisines pour charger les données
      await cuisineRepo.loadCuisines();

      // Vérification que les cuisines sont bien récupérées
      expect(cuisineRepo.getCuisines(), ['Italien', 'Français']);
    });

    // Test pour la méthode getCuisinesRestaurant
    test('test getCuisinesRestaurant', () async {
      final mockRestaurant = Restaurant(
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
        latitude: '0',
        longitude: '0',
      );

      // Setup du mock pour retourner des cuisines simulées pour un restaurant
      when(mockDb.rawQuery('SELECT nomcuisine FROM CUISINE_RESTAURANT WHERE osmid=001;'))
          .thenAnswer((_) async => [
        {'nomcuisine': 'Italien'},
        {'nomcuisine': 'Fast_food'},
      ]);

      final cuisineRepo = CuisineRepository(mockDb);

      // Appel de loadCuisinesRestaurant pour charger les cuisines pour ce restaurant
      await cuisineRepo.loadCuisinesRestaurant(mockRestaurant);

      // Vérification que les cuisines du restaurant sont bien récupérées
      expect(cuisineRepo.getCuisinesRestaurant(), ['Italien', 'Fast_food']);
    });
  });
}
