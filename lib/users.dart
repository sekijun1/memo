class Users {
  Users({
    required this.documentID,
    required this.name,
    required this.mail,
    this.password,
    this.imageURL,
  });

  final String? documentID;
  final String? name;
  final String? mail;
  final String? password;
  final String? imageURL;
}

