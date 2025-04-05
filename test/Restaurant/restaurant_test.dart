import 'package:flutter_test/flutter_test.dart';
import 'package:sae_mobile/Model/Restaurant/Restaurant.dart';


void main() {
  group('Restaurant class', () {
    test('constructeur et getteur', () {
      final restaurant = Restaurant(
        osmid: '12345',
        nomRestaurant: 'cha+',
        type: 'Français',
        etoiles: 4,
        telephone: '0123456789',
        siret: '12345678901234',
        siteInternet: 'https://cha+.fr',
        vegetarien: 'oui',
        vegan: 'non',
        livraison: 'oui',
        aEmporter: 'oui',
        drive: 'non',
        accessInternet: 'oui',
        espaceFumeur: 'non',
        fauteuilRoulant: 'oui',
        facebook: 'https://facebook.com/cha+',
        longitude: '2.3488',
        latitude: '48.8534',
      );

      expect(restaurant.getOsmid, '12345');
      expect(restaurant.getNomRestaurant, 'cha+');
      expect(restaurant.getType, 'Français');
      expect(restaurant.getEtoiles, 4);
      expect(restaurant.getTelephone, '0123456789');
      expect(restaurant.getSiret, '12345678901234');
      expect(restaurant.getSiteInternet, 'https://cha+.fr');
      expect(restaurant.getVegetarien, 'oui');
      expect(restaurant.getVegan, 'non');
      expect(restaurant.getLivraison, 'oui');
      expect(restaurant.getAEmporter, 'oui');
      expect(restaurant.getDrive, 'non');
      expect(restaurant.getAccessInternet, 'oui');
      expect(restaurant.getEspaceFumeur, 'non');
      expect(restaurant.getFauteuilRoulant, 'oui');
      expect(restaurant.getFacebook, 'https://facebook.com/cha+');
      expect(restaurant.getLongitude, '2.3488');
      expect(restaurant.getLatitude, '48.8534');
    });

    test('test champs null', () {
      final restaurant = Restaurant(
        osmid: '54321',
        nomRestaurant: 'Chez Vegan',
        type: 'Vegan',
        etoiles: 5,
      );

      expect(restaurant.getTelephone, isNull);
      expect(restaurant.getSiret, isNull);
      expect(restaurant.getSiteInternet, isNull);
      expect(restaurant.getVegetarien, isNull);
      expect(restaurant.getLongitude, isNull);

      expect(restaurant.getOsmid, '54321');
      expect(restaurant.getNomRestaurant, 'Chez Vegan');
      expect(restaurant.getType, 'Vegan');
      expect(restaurant.getEtoiles, 5);
      expect(restaurant.getTelephone, isNull);
      expect(restaurant.getSiret, isNull);
      expect(restaurant.getSiteInternet, isNull);
      expect(restaurant.getVegetarien, isNull);
      expect(restaurant.getVegan, isNull);
      expect(restaurant.getLivraison, isNull);
      expect(restaurant.getAEmporter, isNull);
      expect(restaurant.getDrive, isNull);
      expect(restaurant.getAccessInternet, isNull);
      expect(restaurant.getEspaceFumeur, isNull);
      expect(restaurant.getFauteuilRoulant, isNull);
      expect(restaurant.getFacebook, isNull);
      expect(restaurant.getLongitude, isNull);
      expect(restaurant.getLatitude, isNull);


    });
  });
}
