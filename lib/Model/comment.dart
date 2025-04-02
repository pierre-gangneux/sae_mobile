class Comment {
  final String _osmid;
  final String _username;
  String _comment;
  int _rating;

  Comment(this._username, this._osmid, this._comment, this._rating);

  // Getters
  String get username => _username;
  String get osmid => _osmid;
  String get comment => _comment;
  int get rating => _rating;

  // Setters
  void set comment(String comment) => _comment = comment;
  void set rating(int rating) => {if (0 <= rating && rating <= 5){this._rating = rating}};

  Map<String, Object?> toMap(){
    return  {
      'username': _username,
      'osmid': _osmid,
      'comment': _comment,
      'rating': _rating,
    };
  }
}
