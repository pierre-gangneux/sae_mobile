import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sae_mobile/ViewModels/LikeViewModel.dart';
import 'package:sae_mobile/ViewModels/connexionViewModel.dart';

import '../../Model/Restaurant/Restaurant.dart';
import '../viewRestaurant.dart';

class FavorisView extends StatefulWidget {
  const FavorisView({super.key});

  @override
  State<FavorisView> createState() => _FavorisViewState();
}

class _FavorisViewState extends State<FavorisView> {

  @override
  Widget build(BuildContext context) {
    final likeViewModel = context.read<LikeViewModel>();
    final connexionViewModel = context.read<ConnexionViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Vos favoris"),
      ),
      body: FutureBuilder<List<Restaurant>>(
        future: likeViewModel.getLike(connexionViewModel.getUsername()!), // Attendre le résultat de getLike
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Afficher un indicateur de chargement pendant le processus
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}')); // Si une erreur se produit
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun favori trouvé.')); // Si aucun favori n'est trouvé
          } else {
            return ViewRestaurant(
              axis: Axis.vertical,
              restaurants: snapshot.data!, // Passer les restaurants obtenus depuis le snapshot
            );
          }
        },
      ),
    );
  }
}
