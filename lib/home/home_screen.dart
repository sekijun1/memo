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
              child: Center(
                child: Column(
                  children: [
                    Container(
                      color: Colors.lightBlueAccent,
                      height: 100,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                              icon: Icon(Icons.login),
                              label:
                                  Text("LogIn", style: TextStyle(fontSize: 20)),
                              onPressed: () => model.onPushLogIn(context)),
                          SizedBox(
                            width: 50,
                          ),
                          ElevatedButton.icon(
                              icon: Icon(Icons.person_add),
                              label: Text("SignUp",
                                  style: TextStyle(fontSize: 20)),
                              onPressed: () => model.onPushSignUp(context)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: ListTile(
                        title: Text('UserName', style: TextStyle(fontSize: 25)),
                        subtitle: Text('Mail', style: TextStyle(fontSize: 20)),
                        leading: Icon(Icons.person, size: 35),
                        trailing: IconButton(
                            icon: Icon(Icons.add, size: 30), onPressed: () {}),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
