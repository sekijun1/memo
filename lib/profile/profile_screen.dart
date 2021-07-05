import 'package:flutter/material.dart';
import 'package:memo/add_screen/add_screen.dart';
import 'package:memo/home/home_screen.dart';
import 'package:memo/login/login_screen.dart';
import 'package:memo/profile/profile_model.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../users.dart';

class ProfileScreen extends StatelessWidget {
  final Users selectedUser;
  final logInUser;

  ProfileScreen({required this.selectedUser, this.logInUser});

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
    print(selectedUser.name);
    print(selectedUser.documentID);
    print(selectedUser.mail);
    print(selectedUser.password);
    print(selectedUser.imageURL);

    return ChangeNotifierProvider<ProfileModel>(
      create: (_) => ProfileModel(),
      child: Consumer<ProfileModel>(builder: (context, model, child) {
        print(model.currentLogInUser);
        return Scaffold(
          appBar: AppBar(
            title: Text('プロフィール'),
            actions:[ IconButton(
              icon: Icon(Icons.edit, size: 30),
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddScreen(user: selectedUser),
                        fullscreenDialog: true));
              },
            ),]
          ),
          body: Column(
            children: [
              Container(
                color: Colors.lightBlueAccent,
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      "ログインユーザー：",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    if (model.currentLogInUser == null)
                      Text("Null", style: TextStyle(fontSize: 20)),
                    if (model.currentLogInUser != null)
                      Text(model.currentLogInUser!.email.toString(),
                          style: TextStyle(fontSize: 20)),
                    Expanded(child: SizedBox()),
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
                child: Container(
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade300
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(selectedUser.imageURL != null) Container(
                        height: 250,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(20),
                        child: Image.network('${selectedUser.imageURL}')
                      ),
                      if(selectedUser.imageURL == null) Container(
                        height: 250,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(20),
                          child: Image.network('https://www.nicepng.com/png/detail/136-1366211_group-of-10-guys-login-user-icon-png.png')
                      ),
                      profileTile('UserName', selectedUser.name),
                      profileTile('DocumentID', selectedUser.documentID),
                      profileTile('Mail', selectedUser.mail),
                      profileTile('Password', selectedUser.password),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget profileTile(String label, userParameter) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: 160,
              child: Text('$label:', style: TextStyle(fontSize: 25))),
          Row(
            children: [
              SizedBox(width: 50),
              Text(userParameter ?? 'Nullだよ！！', style: TextStyle(fontSize: 20)),
            ],
          ),
        ],
      ),
    );
  }
}
