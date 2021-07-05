import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../users.dart';

class AddScreenModel extends ChangeNotifier {
  String name = '';
  String mail = '';
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future addUserToFirebase() async {
    if (name == "") throw "「UserName」を入力してください";
    await users
        .doc()
        .set({'name': name, 'mail': mail});
    notifyListeners();
  }

  Future updateUsersToFirebase(Users user,) async {
    if (name == "" || mail == "") {
      throw "「UserName」と「MailAddress」を入力してください";
    }
    await users
        .doc(user.documentID)
        .update({'name': name, 'mail': mail});
    notifyListeners();
  }
}
