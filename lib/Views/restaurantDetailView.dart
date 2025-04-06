import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sae_mobile/Views/Avis/avisSectionView.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Model/Like/Like.dart';
import '../Model/Restaurant/Restaurant.dart';
import '../ViewModels/LikeViewModel.dart';
import '../ViewModels/connexionViewModel.dart';
import '../ViewModels/restaurantViewModel.dart';

class RestaurantDetailView extends StatefulWidget {
  final Restaurant restaurant;


  const RestaurantDetailView({super.key, required this.restaurant});

  @override
  State<RestaurantDetailView> createState() => _RestaurantDetailViewState();
}

class _RestaurantDetailViewState extends State<RestaurantDetailView> {
  late Future<List<Restaurant?>> _likedFuture;

  @override
  void initState() {
    super.initState();

    final username = context.read<ConnexionViewModel>().getUsername()!;
    _likedFuture = context.read<LikeViewModel>().getLike(username);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final restaurantViewModel = context.read<RestaurantViewModel>();
      restaurantViewModel.saveRestaurant(widget.restaurant.osmid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final username = context.read<ConnexionViewModel>().getUsername()!;
    final likeViewModel = context.read<LikeViewModel>();
    debugPrint('rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurant.nomRestaurant),
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
                        widget.restaurant.nomRestaurant,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),


                      // Bouton Like
                      FutureBuilder<List<Restaurant?>>(

                        future: _likedFuture,
                        builder: (context, snapshot) {
                          final likedRestaurants = snapshot.data ?? [];
                          final isLiked = likedRestaurants.any(
                                (like) => like!.osmid == widget.restaurant.osmid,
                          );

                          return ElevatedButton(
                            onPressed: () {
                              Like like = Like(username: username, osmid: widget.restaurant.osmid);
                              if (isLiked) {
                                likeViewModel.removeLike(like);
                              } else {
                                likeViewModel.addLike(like);
                              }

                              setState(() {
                                _likedFuture = likeViewModel.getLike(username); //  Rebuild le FutureBuilder quand le bouton like change
                              });
                            },
                            child: Icon(
                              Icons.favorite,
                              color: isLiked ? Colors.red : Colors.grey,
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.all(12),
                              backgroundColor: isLiked ? Colors.red[100] : Colors.grey[200],
                            ),
                          );
                        },
                      )

                    ],
                  ),

                  SizedBox(height: 8),

                  // Téléphone et site internet
                  if (widget.restaurant.telephone != null)
                    _buildInfoRow(
                      Icons.phone,
                      widget.restaurant.telephone!,
                      onTap: () {
                        launchUrl(Uri.parse("tel:${widget.restaurant.telephone}"));
                      },
                    ),
                  if (widget.restaurant.siteInternet != null)
                    _buildInfoRow(
                      Icons.language,
                      "Site web",
                      onTap: () {
                        launchUrl(Uri.parse(widget.restaurant.siteInternet!));
                      },
                    ),
                  if (widget.restaurant.facebook != null)
                    _buildInfoRow(
                      Icons.facebook,
                      "Facebook",
                      onTap: () {
                        launchUrl(Uri.parse(widget.restaurant.facebook!));
                      },
                    ),

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
                      if (widget.restaurant.vegetarien == "yes") _buildChip("Végétarien"),
                      if (widget.restaurant.vegan == "yes") _buildChip("Vegan"),
                      if (widget.restaurant.livraison == "yes") _buildChip("Livraison"),
                      if (widget.restaurant.aEmporter == "yes") _buildChip("À Emporter"),
                      if (widget.restaurant.drive == "yes") _buildChip("Drive"),
                      if (widget.restaurant.accessInternet == "yes") _buildChip("Wi-Fi Gratuit"),
                      if (widget.restaurant.espaceFumeur == "yes") _buildChip("Espace Fumeur"),
                      if (widget.restaurant.fauteuilRoulant == "yes") _buildChip("Accès PMR"),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Localisation
                  if (widget.restaurant.latitude != null && widget.restaurant.longitude != null)
                    ElevatedButton.icon(
                      onPressed: () {
                        launchUrl(Uri.parse(
                            "https://www.google.com/maps/search/?api=1&query=${widget.restaurant.latitude},${widget.restaurant.longitude}"));
                      },
                      icon: Icon(Icons.map),
                      label: Text("Voir sur Google Maps"),
                    ),
                  SizedBox(height: 32),
                  AvisSectionView(restaurant: widget.restaurant),
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
