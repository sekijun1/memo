import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogInModel extends ChangeNotifier {
  String mail = '';
  String password = '';
  FirebaseAuth auth = FirebaseAuth.instance;

  Future logInAuth() async {
    if (mail == "" || password == "") {
      throw "「MailAddress」と「Password」を入力してください";
    }
    final result = await auth.signInWithEmailAndPassword(
      email: mail,
      password: password,
    );

    print('${result.user}');
    print('${result.user!.uid}');
    print('${result.user!.email}');
    print('${result.user!.displayName}');


    return result;
  }


}
