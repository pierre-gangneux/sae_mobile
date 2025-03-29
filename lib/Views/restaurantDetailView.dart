import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Model/Restaurant.dart';

class RestaurantDetailView extends StatelessWidget {
  final String restaurantId;

  const RestaurantDetailView({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Restaurant>(
      future: _getRestaurantById(restaurantId),  // Charger le restaurant par ID
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());  // Afficher un indicateur de chargement
        }

        if (snapshot.hasError) {
          return Center(child: Text("Erreur: ${snapshot.error}"));
        }

        final restaurant = snapshot.data;

        if (restaurant == null) {
          return Center(child: Text("Restaurant non trouvé"));
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(restaurant.nomRestaurant),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Image.network(
                 // "https://source.unsplash.com/400x300/?restaurant,food",
                  //fit: BoxFit.cover,
                  //width: double.infinity,
                  //height: 200,
                //),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nom du restaurant et étoiles
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            restaurant.nomRestaurant,
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: List.generate(
                              restaurant.etoiles,
                                  (index) => Icon(Icons.star, color: Colors.amber),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      // Téléphone et site internet
                      if (restaurant.telephone != null)
                        _buildInfoRow(Icons.phone, restaurant.telephone!, onTap: () {
                          launchUrl(Uri.parse("tel:${restaurant.telephone}"));
                        }),
                      if (restaurant.siteInternet != null)
                        _buildInfoRow(Icons.language, "Site web", onTap: () {
                          launchUrl(Uri.parse(restaurant.siteInternet!));
                        }),
                      if (restaurant.facebook != null)
                        _buildInfoRow(Icons.facebook, "Facebook", onTap: () {
                          launchUrl(Uri.parse(restaurant.facebook!));
                        }),
                      SizedBox(height: 16),
                      // Services disponibles
                      Text(
                        "Services Disponibles",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 10,
                        children: [
                          if (restaurant.vegetarien == "yes") _buildChip("Végétarien"),
                          if (restaurant.vegan == "yes") _buildChip("Vegan"),
                          if (restaurant.livraison == "yes") _buildChip("Livraison"),
                          if (restaurant.aEmporter == "yes") _buildChip("À Emporter"),
                          if (restaurant.drive == "yes") _buildChip("Drive"),
                          if (restaurant.accessInternet == "yes") _buildChip("Wi-Fi Gratuit"),
                          if (restaurant.espaceFumeur == "yes") _buildChip("Espace Fumeur"),
                          if (restaurant.fauteuilRoulant == "yes") _buildChip("Accès PMR"),
                        ],
                      ),
                      SizedBox(height: 16),
                      if (restaurant.latitude != null && restaurant.longitude != null)
                        ElevatedButton.icon(
                          onPressed: () {
                            launchUrl(Uri.parse(
                                "https://www.google.com/maps/search/?api=1&query=${restaurant.latitude},${restaurant.longitude}"));
                          },
                          icon: Icon(Icons.map),
                          label: Text("Voir sur Google Maps"),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(text),
      onTap: onTap,
    );
  }

  Widget _buildChip(String label) {
    return Chip(
      label: Text(label, style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.blue,
    );
  }

  // Fonction pour récupérer le restaurant par ID
  Future<Restaurant> _getRestaurantById(String id) async {
    //await Future.delayed(Duration(seconds: 2)); // Simuler un délai

    // Retourne un restaurant fictif
    return Restaurant(
      osmid: id,
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
    );
  }
}
