import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/Avis/avisRepository.dart';
import '../Model/Avis/avis.dart';

import '../Model/Restaurant/Restaurant.dart';

class AvisViewModel extends ChangeNotifier{
  late AvisRepository _avisRepository;

  AvisViewModel(Database db){
    _avisRepository = AvisRepository(db);
  }

  Future<List<Avis>> getAvisUser(String username) async{
    List<Avis> avis = await _avisRepository.getAvisUser(username);
    return avis;
  }

  Future<List<Avis>> getAvisRestaurant(Restaurant restaurant) async{
    List<Avis> avis = await _avisRepository.getAvisRestaurants(restaurant);
    return avis;
  }

  void addAvis(Avis avis){
    _avisRepository.addAvis(avis);
    notifyListeners();
  }

  void removeAvis(Avis avis){
    _avisRepository.removeAvis(avis);
    notifyListeners();
  }

  void editAvis(Avis avis){
    _avisRepository.editAvis(avis);
    notifyListeners();
  }
}