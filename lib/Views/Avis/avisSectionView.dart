import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../../Model/Avis/avis.dart';
import '../../Model/Restaurant/Restaurant.dart';
import '../../ViewModels/avisViewModel.dart';
import '../../ViewModels/connexionViewModel.dart';
import '../../ViewModels/restaurantViewModel.dart';
import 'AvisCard.dart';

class AvisSectionView extends StatefulWidget {
  final Restaurant? restaurant;
  const AvisSectionView({super.key, this.restaurant});

  @override
  State<AvisSectionView> createState() => _AvisSectionViewState();
}

class _AvisSectionViewState extends State<AvisSectionView> {
  double noteMoyenne(List<Avis> avisList) {
    if (avisList.isEmpty) return 0.0;
    double sommeNotes = 0;
    for (var avis in avisList) {
      sommeNotes += avis.note.toDouble();
    }
    return sommeNotes / avisList.length;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.restaurant == null) {
      String username = context.read<ConnexionViewModel>().getUsername()!;
      Future<List<Avis>> avisFuture = context.watch<AvisViewModel>().getAvisUser(username);

      return FutureBuilder<List<Avis>>(
        future: avisFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Erreur lors du chargement de vos avis"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Vous n'avez laissé aucun avis."));
          }

          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final avis = snapshot.data![index];
              final formKey = GlobalKey<FormBuilderState>();

              return avisFormCard(
                  formKey: formKey,
                  avisFuture: avisFuture,
                  username: avis.username,
                  osmid: avis.osmid,
                  title: context.read<RestaurantViewModel>().getRestaurantById(avis.osmid)?.nomRestaurant
              );
            },
          );
        },
      );
    }

    final formKey = GlobalKey<FormBuilderState>();
    final avisFuture = context.watch<AvisViewModel>().getAvisRestaurant(widget.restaurant!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Avis sur ${widget.restaurant!.nomRestaurant}",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.justify,
        ),
        FutureBuilder<List<Avis>>(
          future: avisFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text("Erreur lors du chargement des avis"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const SizedBox(); // Pas de note moyenne à afficher si pas d'avis
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 8),
                  Text(
                    'Note moyenne : ${noteMoyenne(snapshot.data!).toString()}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        avisFormCard(
            formKey: formKey,
            avisFuture: avisFuture,
            osmid: widget.restaurant!.osmid,
            username: context.read<ConnexionViewModel>().getUsername()!
        ),
        const SizedBox(height: 10),
        Container(
          constraints: const BoxConstraints(minHeight: 300),
          child: FutureBuilder<List<Avis>>(
            future: avisFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Erreur lors du chargement des avis"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("Aucun avis pour l'instant"));
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return avisCard(snapshot.data![index], context);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
