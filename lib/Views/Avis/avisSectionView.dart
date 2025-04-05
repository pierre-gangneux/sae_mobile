import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../../Model/Avis/avis.dart';
import '../../Model/Restaurant.dart';
import '../../ViewModels/avisViewModel.dart';
import 'AvisCard.dart';

class AvisSectionView extends StatefulWidget {
  final Restaurant? restaurant;
  const AvisSectionView({super.key, this.restaurant});

  @override
  State<AvisSectionView> createState() => _AvisSectionViewState();
}

class _AvisSectionViewState extends State<AvisSectionView> {

  @override
  Widget build(BuildContext context) {
    if (widget.restaurant == null) {
      return const Center(
        child: Text("Aucun restaurant sélectionné."),
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
        const SizedBox(height: 10),
        avisFormCard(
            formKey: formKey,
            avisFuture: avisFuture,
            osmid: widget.restaurant!.osmid,
            username: 'test'
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
