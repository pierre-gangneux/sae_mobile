import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/Avis/avisRepository.dart';
import '../Model/Avis/avis.dart';
import '../Model/User.dart';

class AvisViewModel extends ChangeNotifier{
  late AvisRepository _avisRepository;

  AvisViewModel(Database database);
  LikeViewModel(Database db){
    _avisRepository = AvisRepository(db);
  }

  Future<List<Avis>> getAvisUser(User user) async{
    List<Avis> avis = await _avisRepository.getAvisUser(user);
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