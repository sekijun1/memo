
import 'package:flutter/cupertino.dart';

class Users {

  Users({
    required this.documentID,
    required this.name,
    required this.mail,
    this.password,
    this.image,
  });

  final String? documentID;
  final String? name;
  final String? mail;
  final String? password;
  final Image? image;

}
