import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memo/home/home_screen.dart';
import 'package:memo/login/login_screen.dart';
import 'package:memo/users.dart';

class ProfileModel extends ChangeNotifier {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  FirebaseAuth auth = FirebaseAuth.instance;
  List<Users> usersList = [];
  User? currentLogInUser = FirebaseAuth.instance.currentUser;

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
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
    notifyListeners();
  }

  onPushLogIn(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LogInScreen()));
    notifyListeners();
  }
}
