import 'package:flutter_test/flutter_test.dart';
import 'package:sae_mobile/Model/Cuisine/Cuisine.dart';

void main() {
  group('Cuisine', () {
    test('test constructeur et getteurs', () {
      // Création d'un objet Cuisine
      final cuisine = Cuisine(nomCuisine: 'Italien');

      // Vérification que le nom de la cuisine est bien retourné
      expect(cuisine.getNomCuisine, 'Italien');
    });
  });
}
