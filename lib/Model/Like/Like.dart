

class Like {
  String username;
  String osmid;


  Like({
    required this.username,
    required this.osmid,
  });

  // Getters
  String get getUsername => username;
  String get getOsmid => osmid;

  Map<String, Object?> toMap(){
    return  {
      'username':username,
      'osmid':osmid,
    };
  }
}
