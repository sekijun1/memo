import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpModel extends ChangeNotifier {
  String name = '';
  String mail = '';
  String password = '';
  FirebaseAuth auth = FirebaseAuth.instance;

  Future addUserToAuth() async {
    if (name == "" || mail == "" || password == "") {
      throw "「UserName」と「MailAddress」と「Password」を入力してください";
    }
    // final name = nameController.text;
    // final mail = mailController.text;
    // final password = passwordController.text;

    print(auth);
    print(name);
    print(mail);
    print(password);

    final UserCredential user = await auth.createUserWithEmailAndPassword(
      email: mail,
      password: password,
    );

    final result = await auth.signInWithEmailAndPassword(
      email: mail,
      password: password,
    );
    await FirebaseFirestore.instance
        .collection('users')
        .add({'name': name, 'mail': mail});

    return result;
  }


}
