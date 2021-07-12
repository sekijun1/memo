import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memo/list_view/list_view_screen.dart';

class SignUpModel extends ChangeNotifier {
  String name = '';
  String mail = '';
  String password = '';
  String imageURL = '';
  final nameController = TextEditingController();
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  late final bool isUpdate;
  File? imageFile;


  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  isUpdateCheck(user) {
    isUpdate = user != null;
    if (isUpdate) {
      nameController.text = user.name;
      name=user.name;
      mail = user.mail;
      password = user.password;
      imageURL = user.imageURL;
    }
  }

  Future showImagePicker() async {
    final ImagePicker picker = ImagePicker();
    final PickedFile? pickedFile =
        await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      this.imageFile = File(pickedFile.path);
    } else {
      print('pickedFileがNullです');
    }
    notifyListeners();
  }

  Future onPushSignUp(BuildContext context) async {
    try {
      if (name == "" || mail == "" || password == "") {
        throw "「UserName」と「MailAddress」と「Password」を入力してください";
      }
      await auth.createUserWithEmailAndPassword(
        email: mail,
        password: password,
      );
      final result = await auth.signInWithEmailAndPassword(
        email: mail,
        password: password,
      );
      await FirebaseFirestore.instance.collection('users').add({
        'name': name,
        'mail': mail,
        'password': password,
        'imageURL': imageURL
      });
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('登録しました'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              )
            ],
          );
        },
      );
      print(auth.currentUser);
      Navigator.of(context).pop();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ListViewScreen(
                    logInUserUid: result.user!.uid,
                  )));
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
        },
      );
    }
  }

  Future onPushUpdate(BuildContext context, user) async {
    try {
      if (name == "") {
        throw "「UserName」を入力してください";
      }
      await users
          .doc(user.documentID)
          .update({'name': name, 'imageURL': imageURL});

      final result = await auth.signInWithEmailAndPassword(
        email: mail,
        password: password,
      );
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
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ListViewScreen(
                    logInUserUid: result.user!.uid,
                  )));
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
        },
      );
    }
  }
}
