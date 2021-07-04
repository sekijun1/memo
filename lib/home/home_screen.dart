import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memo/home/home_model.dart';
import 'package:provider/provider.dart';
// user@sekijun.com

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeModel>(
      create: (_) => HomeModel(),
      child: Scaffold(
        appBar: AppBar(title: Text('UsersDataBase')),
        body: Consumer<HomeModel>(
          builder: (context, model, child) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Center(
                  child: Row(
                    children: [
                      ElevatedButton(
                          onPressed: () => model.onPushLogIn(context),
                          child: Text("SignIn")),
                      ElevatedButton(
                          onPressed: () => model.onPushSignUp(context),
                          child: Text("SignUp")),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
