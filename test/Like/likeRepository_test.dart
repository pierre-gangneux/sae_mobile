import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sae_mobile/Model/Like/Like.dart';
import 'package:sae_mobile/Model/Like/LikeRepository.dart';
import 'package:sae_mobile/Model/Restaurant/Restaurant.dart';
import 'package:sae_mobile/Model/Restaurant/restaurantRepository.dart';
import 'package:sqflite/sqflite.dart';

import '../Restaurant/restaurantRepository.mocks.dart';

class MockRestaurantRepository extends Mock implements RestaurantRepository {}

void main() {
  group('LikeRepository Tests', () {
    final mockDb = MockDatabase();
    final mockRestaurantRepo = MockRestaurantRepository();
    final likeRepo = LikeRepository(mockDb, mockRestaurantRepo);

    test('test getLike', () async {
      // Arrange
      const username = 'user1';
      final restaurant1 = Restaurant(
        osmid: '001',
        nomRestaurant: 'Restaurant 1',
        type: 'fast_food',
        etoiles: 4,
        vegetarien: 'yes',
        vegan: 'no',
        livraison: 'yes',
        aEmporter: 'no',
        drive: 'yes',
        accessInternet: 'yes',
        fauteuilRoulant: 'no',
        latitude: '0',
        longitude: '0',
      );
      final restaurant2 = Restaurant(
        osmid: '002',
        nomRestaurant: 'Restaurant 2',
        type: 'restaurant',
        etoiles: 5,
        vegetarien: 'no',
        vegan: 'yes',
        livraison: 'no',
        aEmporter: 'yes',
        drive: 'no',
        accessInternet: 'no',
        fauteuilRoulant: 'yes',
        latitude: '0',
        longitude: '0',
      );

      // Simuler la réponse de la base de données
      when(mockDb.rawQuery(any, any)).thenAnswer((_) async => [
        {'osmid': '001'},
        {'osmid': '002'}
      ]);
      when(mockRestaurantRepo.getRestaurantById('001')).thenReturn(restaurant1);
      when(mockRestaurantRepo.getRestaurantById('002')).thenReturn(restaurant2);

      // Act
      final result = await likeRepo.getLike(mockDb, username);

      // Assert
      expect(result.length, 2);
      expect(result[0].nomRestaurant, 'Restaurant 1');
      expect(result[1].nomRestaurant, 'Restaurant 2');
    });

    test('test addLike', () async {
      // Arrange
      final like = Like(username: 'user1', osmid: '001');

      // Simuler l'insertion dans la base de données
      when(mockDb.insert(
        'RESTAURANT_FAVORIS',
        like.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      )).thenAnswer((_) async => 1); // Retourne un int comme si 1 ligne avait été insérée.

      // Act
      await likeRepo.addLike(like);

      // Assert
      verify(mockDb.insert('RESTAURANT_FAVORIS', like.toMap(), conflictAlgorithm: ConflictAlgorithm.replace)).called(1);
    });

    test('test removeLike', () async {
      // Arrange
      final like = Like(username: 'user1', osmid: '001');

      // Simuler la suppression de la base de données
      when(mockDb.delete(
        'RESTAURANT_FAVORIS',
        where: 'username = ? AND osmid = ?',
        whereArgs: [like.username, like.osmid],
      )).thenAnswer((_) async => 1); // Retourne un int comme si 1 ligne avait été supprimée.

      // Act
      await likeRepo.removeLike(like);

      // Assert
      verify(mockDb.delete('RESTAURANT_FAVORIS', where: 'username = ? AND osmid = ?', whereArgs: [like.username, like.osmid])).called(1);
    });
  });
}
