import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import '../../Model/Avis/avis.dart';
import '../../ViewModels/avisViewModel.dart';

Widget avisCard(Avis avis, BuildContext context) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            avis.username,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                Icons.star,
                color: index < avis.note ? Colors.amber : Colors.grey[300],
                size: 20,
              );
            }),
          ),
          const SizedBox(height: 12),
          Text(
            avis.commentaire,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    ),
  );
}

Widget avisFormCard({
  required GlobalKey<FormBuilderState> formKey,
  required Future<List<Avis>> avisFuture,
  required String username,
  required String osmid
}) {
  return FutureBuilder<List<Avis>>(
    future: avisFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text("Erreur lors du chargement de l'avis"));
      }

      Avis? avis = snapshot.hasData ? avisUser(snapshot.data!, username) : null;

      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FormBuilder(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  avis != null ? "Modifier votre avis" : "Laisser un avis",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                FormBuilderField<int>(
                  name: 'note',
                  initialValue: avis?.note ?? 5,
                  validator: FormBuilderValidators.required(errorText: "Note requise"),
                  builder: (FormFieldState<int?> field) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Note"),
                        RatingBar.builder(
                          initialRating: (field.value)!.toDouble(),
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemCount: 5,
                          itemSize: 32,
                          unratedColor: Colors.grey[300],
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            field.didChange(rating.toInt());
                          },
                        ),
                        if (field.hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              field.errorText ?? '',
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 16),

                FormBuilderTextField(
                  name: 'commentaire',
                  initialValue: avis?.commentaire ?? '',
                  decoration: const InputDecoration(
                    labelText: 'Commentaire',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          if (formKey.currentState?.saveAndValidate() ?? false) {
                            final int note = formKey.currentState!.value['note'];
                            final String commentaire = formKey.currentState!.value['commentaire'];
                            var newAvis = Avis(username, osmid, note, commentaire);
                            var avisViewModel = Provider.of<AvisViewModel>(context, listen: false);
                            if (avis != null) {
                              avisViewModel.editAvis(newAvis);
                            } else {
                              avisViewModel.addAvis(newAvis);
                            }
                          }
                        },
                        icon: const Icon(Icons.send),
                        label: Text(avis != null? 'Modifier' : 'Envoyer'),
                      ),
                      if (avis != null)
                        const SizedBox(width: 16),
                      if (avis != null)
                        ElevatedButton.icon(
                          onPressed: () {
                            Provider.of<AvisViewModel>(context, listen: false).removeAvis(avis);
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text("Supprimer"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Avis? avisUser(List<Avis> avisList, String username){
  for (Avis avis in avisList){
    if (avis.username == username){
      return avis;
    }
  }
  return null;
}