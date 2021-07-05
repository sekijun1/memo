import 'package:flutter/material.dart';
import 'package:memo/add_screen/add_model.dart';
import 'package:memo/list_view/list_view_screen.dart';
import 'package:provider/provider.dart';

import 'login_model.dart';

class LogInScreen extends StatelessWidget {

  // final nameController =TextEditingController();
  final mailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // print(isUpdate);
    // print(nameController.text);
    // print(idController.text);

    return ChangeNotifierProvider<LogInModel>(
        create: (_) => LogInModel(),
        child: Consumer<LogInModel>(builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text("LogIn"),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text("UserName", style: TextStyle(fontSize: 25)),
                  // nameInputTextField(model),
                  SizedBox(height: 50),
                  Text("Mail", style: TextStyle(fontSize: 25)),
                  _mailInputTextField(model),
                  SizedBox(height: 50),
                  Text("Password", style: TextStyle(fontSize: 25)),
                  _passwordInputTextField(model),
                  SizedBox(height: 50),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      ElevatedButton.icon(
                          icon: Icon(Icons.login),
                          label:
                          Text("LogIn", style: TextStyle(fontSize: 20)),
                          onPressed: () async => onPushLogIn(model, context)),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
    );
  }


  Widget _mailInputTextField(model) {
    return TextField(
      controller: mailController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(hintText: 'example@sekijun.com'),
      style: TextStyle(fontSize: 20),
      onChanged:(text) => model.mail =text,
    );
  }

  Widget _passwordInputTextField(model) {
    return TextField(
      controller: passwordController,
      keyboardType: TextInputType.text,
      obscureText: true,
      style: TextStyle(fontSize: 20),
      onChanged: (text)=>model.password=text,
    );
  }

  Future onPushLogIn(LogInModel model,BuildContext context) async {
    try {
      await model.logInAuth();
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
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ListViewScreen(logInUser: model.auth.currentUser,)));
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
