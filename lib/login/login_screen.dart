import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login_model.dart';

class LogInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LogInModel>(
      create: (_) => LogInModel(),
      child: Consumer<LogInModel>(builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(title: Text("LogIn"), centerTitle: true),
          body: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        label: Text("LogIn", style: TextStyle(fontSize: 20)),
                        onPressed: () async => model.onPushLogIn(context)),
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
      controller: model.mailController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(hintText: 'example@sekijun.com'),
      style: TextStyle(fontSize: 20),
      onChanged: (text) => model.mail = text,
    );
  }

  Widget _passwordInputTextField(model) {
    return TextField(
      controller: model.passwordController,
      keyboardType: TextInputType.text,
      obscureText: true,
      style: TextStyle(fontSize: 20),
      onChanged: (text) => model.password = text,
    );
  }
}
