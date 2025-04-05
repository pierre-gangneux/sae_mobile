import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:sae_mobile/Views/viewRestaurant.dart';

import '../ViewModels/cuisineViewModel.dart';
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
                  ExpansionTile(
                    title: Text("Filtres"),
                    initiallyExpanded: false, // Filtres fermés par défaut
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            FormBuilderDropdown(
                              name: 'categorie',
                              decoration: InputDecoration(
                                labelText: "Catégorie",
                                border: OutlineInputBorder(),
                              ),
                              items: ['','Restaurant', 'Café', 'Bar', 'Pub', 'Fast food'].map((option) {
                                return DropdownMenuItem(
                                  value: option,
                                  child: Text(option),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 20),
                            ExpansionTile(
                                title: Text("Cuisine"),
                                initiallyExpanded: false, // Filtres fermés par défaut
                                children:[ FormBuilderFilterChip(
                                  name: 'cuisine',
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  options: context.watch<CuisineViewModel>().cuisines.map((cuisine) =>
                                      FormBuilderChipOption(value: cuisine, child: Text(cuisine))
                                  ).toList(),

                                  alignment: WrapAlignment.start,
                                  runSpacing: 12.0,
                                  spacing: 30.0,
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                ),]
                            ),
                            SizedBox(height: 20),
                            ExpansionTile(
                              title: Text("Options"),
                              initiallyExpanded: false, // Filtres fermés par défaut
                              children:[ FormBuilderFilterChip(
                                name: 'options',
                                decoration: InputDecoration(
                                  //labelText: "Options",
                                  border: OutlineInputBorder(),
                                ),
                                options: [
                                  FormBuilderChipOption(value: 'vegetarien', child: Text('Végétarien')),
                                  FormBuilderChipOption(value: 'vegan', child: Text('Vegan')),
                                  FormBuilderChipOption(value: 'espaceFumeur', child: Text('Fumeur')),
                                  FormBuilderChipOption(value: 'livraison', child: Text('Livraison')),
                                  FormBuilderChipOption(value: 'aEmporter', child: Text('À emporter')),
                                  FormBuilderChipOption(value: 'drive', child: Text('Drive')),
                                  FormBuilderChipOption(value: 'accessInternet', child: Text('Accès Internet')),
                                  FormBuilderChipOption(value: 'fauteuilroulant', child: Text('Fauteuil roulant')),
                                ],
                                alignment: WrapAlignment.start,
                                runSpacing: 12.0,
                                spacing: 30.0,
                                crossAxisAlignment: WrapCrossAlignment.start,
                              ),]
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.saveAndValidate()) {
                        print("Valeurs sélectionnées : ${_formKey.currentState!.value}");
                        var value = _formKey.currentState!.value;
                        context.read<RestaurantViewModel>().setRestaurantFiltre(value["search"], value["categorie"], value["options"], value["cuisine"]);
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
