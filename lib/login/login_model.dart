import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memo/list_view/list_view_screen.dart';

class LogInModel extends ChangeNotifier {
  String mail = '';
  String password = '';
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;


  Future onPushLogIn(BuildContext context) async {
    try {
      if (mail == "" || password == "") {
        throw "「MailAddress」と「Password」を入力してください";
      }
      final result = await auth.signInWithEmailAndPassword(
        email: mail,
        password: password,
      );
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('LogInしました'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                )
              ],
            );
          });
      Navigator.of(context).pop();
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => ListViewScreen(logInUserUid:result.user!.uid)));
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

  Future logInAuth() async {
    if (mail == "" || password == "") {
      throw "「MailAddress」と「Password」を入力してください";
    }
    final result = await auth.signInWithEmailAndPassword(
      email: mail,
      password: password,
    );
    return result;
  }

}
