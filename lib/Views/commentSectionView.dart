import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sae_mobile/Model/User.dart';

import '../Model/Avis/avis.dart';
import '../ViewModels/avisViewModel.dart';

class CommentSectionView extends StatefulWidget {
  const CommentSectionView({super.key});

  @override
  State<CommentSectionView> createState() => _CommentSectionViewState();
}

class _CommentSectionViewState extends State<CommentSectionView> {
  @override
  Widget build(BuildContext context) {

    User currentUser = User(username: "DEBUG", mdp: "mdp", estadmin: false);
    Future<List<Avis>> avis = context.watch<AvisViewModel>().getAvisUser(currentUser);

    return SizedBox(
      height: 300,
      child: FutureBuilder<List<Avis>>(
        future: avis,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Erreur lors du chargement des commentaires"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun commentaire pour l'instant"));
          }

          List<Avis> avisList = snapshot.data!;

          return ListView.builder(
            itemCount: avisList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(avisList[index].commentaire),
                leading: const Icon(Icons.comment, color: Colors.blue),
              );
            },
          );
        },
      ),
    );
  }
}
