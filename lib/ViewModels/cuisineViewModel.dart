import 'package:flutter/foundation.dart'; // Pour ChangeNotifier
import 'package:sqflite/sqflite.dart';
import '../Model/Cuisine/CuisineRepository.dart';


class CuisineViewModel extends ChangeNotifier {
  late CuisineRepository cuisineRepository;
  List<String> cuisines = [];


  CuisineViewModel(Database db) {
    cuisineRepository = CuisineRepository(db);
    loadCuisines();
  }

  Future<void> loadCuisines() async {
    await cuisineRepository.loadCuisines();
    cuisines = cuisineRepository.getCuisines();
    notifyListeners();
  }


}
