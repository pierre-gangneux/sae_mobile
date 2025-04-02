import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Model/Like.dart';
import '../Model/Restaurant.dart';
import '../ViewModels/LikeViewModel.dart';
import '../ViewModels/connexionViewModel.dart';

class RestaurantDetailView extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantDetailView({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.nomRestaurant),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom du restaurant et like
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        restaurant.nomRestaurant,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      /*Row(
                        children: List.generate(
                          restaurant.etoiles,
                              (index) => Icon(Icons.star, color: Colors.amber),
                        ),
                      ),*/
                      ElevatedButton(
                        onPressed: () {
                          Like like = new Like(username: context.read<ConnexionViewModel>().getUser()!.username, osmid: restaurant.osmid);
                          context.read<LikeViewModel>().addLike(like);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // Facultatif pour arrondir
                          ),
                          padding: EdgeInsets.all(12), // Ajuste l'espace interne
                        ),
                        child: Icon(Icons.favorite),
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

                  // Localisation
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
  }

  // Widget pour afficher une ligne d'information cliquable
  Widget _buildInfoRow(IconData icon, String text, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(text),
      onTap: onTap,
    );
  }

  // Widget pour afficher un badge de service
  Widget _buildChip(String label) {
    return Chip(
      label: Text(label, style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.blue,
    );
  }
}
