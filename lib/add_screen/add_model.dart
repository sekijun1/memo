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
  Future onPushAddUser(BuildContext context) async {
    try {
      await addUserToFirebase();
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('保存しました'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                )
              ],
            );
          });
      Navigator.of(context).pop();
    } catch (e) {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(e.toString()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                )
              ],
            );
          });
    }
  }

  Future onPushEditUser(BuildContext context,user) async {
    try {
      await updateUsersToFirebase(user);
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('保存しました'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                )
              ],
            );
          });
      Navigator.of(context).pop();
    } catch (e) {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(e.toString()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                )
              ],
            );
          });
    }
  }
}
