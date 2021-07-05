import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memo/users.dart';

class ListViewModel extends ChangeNotifier {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  FirebaseAuth auth = FirebaseAuth.instance;
  List<Users> usersList = [];
  User? currentLogInUser = FirebaseAuth.instance.currentUser;
  var currentLogInUserData;

  Future fetchUsers() async {
    final snapshot = await users.get();
    // if(currentLogInUser != null) currentLogInUserData = users.where('mail' == currentLogInUser!.email);
    // print(currentLogInUserData);
    this.usersList = snapshot.docs
        .map(
          (user) => Users(
            documentID: user.id,
            name: user['name'],
            mail: user['mail'],
            password: user['password'],
            imageURL: user['imageURL'],
          ),
        )
        .toList();
    notifyListeners();
  }

  Future onPushLogOut(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('LogOutしますか？'),
            actions: [
              TextButton(
                child: Text('Back'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () => logOut(context),
              )
            ],
          );
        });
    notifyListeners();
  }

  Future logOut(BuildContext context) async {
    await auth.signOut();
    print(auth.currentUser);
    currentLogInUser = auth.currentUser;
    print(currentLogInUser);
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('LogOutしました'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
    Navigator.of(context).pop();
    notifyListeners();
  }

  Future onPushDeleteUserFromFirebase(BuildContext context, Users user) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('削除しますか？'),
            actions: [
              TextButton(
                child: Text('Back'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () => deleteUserFromFirebase(user, context),
              )
            ],
          );
        });
  }

  Future deleteUserFromFirebase(Users user, BuildContext context) async {
    await users.doc(user.documentID).delete();
    Navigator.of(context).pop();
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('削除しました'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
    Navigator.of(context).pop();
    notifyListeners();
  }
}
