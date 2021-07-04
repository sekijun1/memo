import 'package:flutter/material.dart';
import 'package:memo/login/login_screen.dart';
import 'package:memo/signup/signup_screen.dart';

class HomeModel extends ChangeNotifier {

  onPushLogIn(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LogInScreen()));
    notifyListeners();
  }

  onPushSignUp(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUpScreen()));
    notifyListeners();
  }
}
