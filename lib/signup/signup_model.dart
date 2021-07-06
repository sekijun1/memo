import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignUpModel extends ChangeNotifier {
  String name = '';
  String mail = '';
  String password = '';
  String imageURL = '';
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  // File imageFile;

  // Future showImagePicker() async {
  //   final ImagePicker picker = ImagePicker();
  //   final PickedFile? pickedFile =
  //       await picker.getImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {imageFile = File(pickedFile.path);}
  //   else {print('pickedFileがNullです');}
  //   notifyListeners();
  // }

  Future addUserToAuth() async {
    if (name == "" || mail == "" || password == "") {
      throw "「UserName」と「MailAddress」と「Password」を入力してください";
    }
    print(auth);
    print(name);
    print(mail);
    print(password);
    print(imageURL);

    await auth.createUserWithEmailAndPassword(
      email: mail,
      password: password,
    );

    final result = await auth.signInWithEmailAndPassword(
      email: mail,
      password: password,
    );
    await FirebaseFirestore.instance
        .collection('users')
        .add({'name': name, 'mail': mail,'password':password,'imageURL':imageURL});
    return result;
  }
  Future updateUsers(user) async {
    if (name == "") {
      throw "「UserName」を入力してください";
    }
    await users
        .doc(user.documentID)
        .update({'name': name,'imageURL':imageURL});

    final result = await auth.signInWithEmailAndPassword(
      email: mail,
      password: password,
    );
    return result;
  }
}
