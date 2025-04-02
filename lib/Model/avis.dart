class Avis {
  final String _osmid;
  final String _username;
  int _note;
  String _commentaire;

  Avis(this._username, this._osmid, this._note, this._commentaire);

  // Getters
  String get username => _username;
  String get osmid => _osmid;
  int get note => _note;
  String get commentaire => _commentaire;

  // Setters
  void set note(int note) => {if (0 <= note && note <= 5){this._note = note}};
  void set commentaire(String commentaire) => _commentaire = commentaire;

  Map<String, Object?> toMap(){
    return  {
      'username': _username,
      'osmid': _osmid,
      'note': _note,
      'commentaire': _commentaire,
    };
  }
}
