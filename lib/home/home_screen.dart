import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memo/home/home_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeModel>(
      create: (_) => HomeModel(),
      child: Consumer<HomeModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text('UsersDataBase'),
              actions: [
                IconButton(
                    onPressed: () => model.onPushListView(context),
                    icon: Icon(Icons.login))
              ],
            ),
            body: SingleChildScrollView(
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
                        SizedBox(width: 50),
                        ElevatedButton.icon(
                            icon: Icon(Icons.person_add),
                            label:
                                Text("SignUp", style: TextStyle(fontSize: 20)),
                            onPressed: () => model.onPushSignUp(context)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('UsersListを表示', style: TextStyle(fontSize: 25)),
                        _userListTiles(),
                        _userListTiles(),
                        _userListTiles(),
                        SizedBox(
                          height: 20,
                        ),
                        Text('UserProfileを表示', style: TextStyle(fontSize: 25)),
                        Container(
                          padding: EdgeInsets.only(left: 30, right: 30),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.shade300),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  height: 200,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(20),
                                  child: Image.network(
                                      'https://www.nicepng.com/png/detail/136-1366211_group-of-10-guys-login-user-icon-png.png')),
                              profileTile('UserName', 'UserName'),
                              profileTile('DocumentID', 'DocumentID'),
                              profileTile('Mail', 'Mail'),
                              profileTile('Password', 'Password'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _userListTiles() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.grey.shade300),
      child: ListTile(
        title: Text('UserName', style: TextStyle(fontSize: 25)),
        subtitle: Text('Mail', style: TextStyle(fontSize: 20)),
        leading: Icon(Icons.person, size: 35),
        trailing: IconButton(icon: Icon(Icons.add, size: 30), onPressed: () {}),
      ),
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
              Text(userParameter, style: TextStyle(fontSize: 20)),
            ],
          ),
        ],
      ),
    );
  }
}
