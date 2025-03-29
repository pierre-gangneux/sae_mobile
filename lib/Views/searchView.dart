import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:sae_mobile/Views/viewRestaurant.dart';

import '../ViewModels/restaurantViewModel.dart';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("IUTable"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: "search",
                    decoration: InputDecoration(
                      hintText: "Rechercher...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Aligner les 3 FormBuilderDropdown horizontalement
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: FormBuilderDropdown(
                          name: 'categorie',
                          decoration: InputDecoration(
                            labelText: "Catégorie",
                            border: OutlineInputBorder(),
                          ),
                          items: ['Restaurant', 'Café', 'Bar', 'Pub', 'Fast food'].map((option) {
                            return DropdownMenuItem(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(width: 10), // Espace entre les deux Dropdowns
                      Expanded(
                        child: FormBuilderDropdown(
                          name: 'prix',
                          decoration: InputDecoration(
                            labelText: "Prix",
                            border: OutlineInputBorder(),
                          ),
                          items: ['€', '€€', '€€€'].map((option) {
                            return DropdownMenuItem(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: FormBuilderDropdown(
                          name: 'note',
                          decoration: InputDecoration(
                            labelText: "Note",
                            border: OutlineInputBorder(),
                          ),
                          items: ['⭐', '⭐⭐', '⭐⭐⭐', '⭐⭐⭐⭐', '⭐⭐⭐⭐⭐'].map((option) {
                            return DropdownMenuItem(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.saveAndValidate()) {
                        print("Valeurs sélectionnées : ${_formKey.currentState!.value}");
                        var value = _formKey.currentState!.value;
                        context.read<RestaurantViewModel>().setRestaurantFiltre(value["search"], value["categorie"]);
                      }
                    },
                    child: Text("Filtrer"),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: ViewRestaurant(axis: Axis.vertical, restaurants: context.watch<RestaurantViewModel>().getRestaurants(),)),
        ],
      ),
    );
  }
}
