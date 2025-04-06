// ignore_for_file: unused_import

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sae_mobile/Model/Like/Like.dart';

import '../Restaurant/restaurantRepository.mocks.dart';

void main() {
  group('Like class Tests', () {
    final mockDb = MockDatabase();
    final like = Like(username: 'user1', osmid: '001');

    // Test du constructeur et des getters
    test('Test du constructeur et des getters', () {
      // Vérifier que les propriétés sont initialisées correctement
      expect(like.getUsername, 'user1');
      expect(like.getOsmid, '001');
    });

    // Test de la méthode `toMap`
    test('Test de la méthode `toMap`', () {
      // Act
      Map<String, Object?> result = like.toMap();

      // Assert
      expect(result['username'], 'user1');
      expect(result['osmid'], '001');
    });
  });
}