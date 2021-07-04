import 'package:flutter/material.dart';
import 'package:memo/home/home_screen.dart';
import 'package:memo/list_view/list_view_model.dart';
import 'package:memo/login/login_screen.dart';
import 'package:provider/provider.dart';
import '../add_screen/add_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ListViewScreen extends StatelessWidget {
  final logInUser;

  ListViewScreen({this.logInUser});

  @override
  Widget build(BuildContext context) {
    final bool isCurrentUser = FirebaseAuth.instance.currentUser != null;
    if (isCurrentUser) {
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('LogInしてください'),
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

    return ChangeNotifierProvider<ListViewModel>(
      create: (_) => ListViewModel()..fetchUsers(),
      child: Consumer<ListViewModel>(builder: (context, model, child) {
        print(model.currentLogInUser);
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.autorenew),
              onPressed: () => model.fetchUsers(),
            ),
            title: Text('ListViewで表示'),
            actions: [
              IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () async {
                    await model.onPushLogOut(context);
                    if(model.auth.currentUser==null) {
                      await Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) =>
                          HomeScreen()));
                    }})
            ],
          ),
          body: Column(
            children: [
              (() {
                if (model.currentLogInUser == null) {
                  return Text("Null",style: TextStyle(fontSize: 20),);
                } else {
                  return Text(model.currentLogInUser!.email.toString(),style: TextStyle(fontSize: 20),);
                }
              })(),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    ListTile(
                      title: Text('UserName', style: TextStyle(fontSize: 20)),
                      subtitle: Text('Mail', style: TextStyle(fontSize: 15)),
                      leading: Icon(Icons.person),
                      trailing: IconButton(
                          icon: Icon(Icons.add),
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
                            style: TextStyle(fontSize: 20)),
                        subtitle: Text('${user.mail}',
                            style: TextStyle(fontSize: 15)),
                        leading: Icon(Icons.person),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
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
