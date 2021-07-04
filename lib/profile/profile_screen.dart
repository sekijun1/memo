import 'package:flutter/material.dart';
import 'package:memo/home/home_screen.dart';
import 'package:memo/login/login_screen.dart';
import 'package:memo/profile/profile_model.dart';
import 'package:provider/provider.dart';
import '../add_screen/add_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  final selectedUser;
  final logInUser;
  ProfileScreen({required this.selectedUser,this.logInUser});

  @override
  Widget build(BuildContext context) {
    final bool isCurrentUser = FirebaseAuth.instance.currentUser != null;
    if (isCurrentUser) {
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('ログインしてください'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            );
          });
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LogInScreen()));
    }

    return ChangeNotifierProvider<ProfileModel>(
      create: (_) => ProfileModel(),
      child: Consumer<ProfileModel>(builder: (context, model, child) {
        print(model.currentLogInUser);
        return Scaffold(
          appBar: AppBar(
            title: Text('プロフィール'),
          ),
          body: Column(
            children: [
              Container(
                color: Colors.lightBlueAccent,
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "ログインユーザー：",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: 20),
                    (() {
                      if (model.currentLogInUser == null) {
                        return Text(
                          "Null",
                          style: TextStyle(fontSize: 20),
                        );
                      } else {
                        return Text(
                          model.currentLogInUser!.email.toString(),
                          style: TextStyle(fontSize: 20),
                        );
                      }
                    })(),
                    IconButton(
                        icon: Icon(Icons.logout),
                        onPressed: () async {
                          await model.onPushLogOut(context);
                          if (model.auth.currentUser == null) {
                            await Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()));
                          }
                        })
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    ListTile(
                      title: Text('UserName', style: TextStyle(fontSize: 25)),
                      subtitle: Text('Mail', style: TextStyle(fontSize: 20)),
                      leading: Icon(Icons.person, size: 35),
                      trailing: IconButton(
                          icon: Icon(Icons.add, size: 30),
                          onPressed: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddScreen(),
                                    fullscreenDialog: true));
                          }),
                    ),
                    SizedBox(height: 20),
                    Column(
                        children: model.usersList.map((user) {
                          return ListTile(
                            title: Text('${user.name}',
                                style: TextStyle(fontSize: 25)),
                            subtitle: Text('${user.mail}',
                                style: TextStyle(fontSize: 20)),
                            contentPadding:
                            EdgeInsets.only(left: 16, right: 16, bottom: 10),
                            leading: IconButton(
                              icon: Icon(Icons.person, size: 35),
                              onPressed: () async {
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen(),
                                        fullscreenDialog: true));
                              },
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.edit, size: 30),
                              onPressed: () async {
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddScreen(user: user),
                                        fullscreenDialog: true));
                              },
                            ),
                            onLongPress: () async =>
                                model.onPushDeleteUserFromFirebase(context, user),
                          );
                        }).toList()),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () => print(model.currentLogInUser),
                        child: Text("currentLogInUser"))
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
