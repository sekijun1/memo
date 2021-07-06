import 'package:flutter/material.dart';
import 'package:memo/home/home_screen.dart';
import 'package:memo/list_view/list_view_model.dart';
import 'package:memo/login/login_screen.dart';
import 'package:memo/profile/profile_screen.dart';
import 'package:memo/signup/signup_screen.dart';
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
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.autorenew),
              onPressed: () => model.fetchUsers(),
            ),
            title: Text('UsersList'),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.lightBlueAccent,
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text(
                        "Your Mail：",
                        style: TextStyle(fontSize: 20,),
                      ),
                      if (model.currentLogInUser == null)
                        Text("Null", style: TextStyle(fontSize: 20)),
                      if (model.currentLogInUser != null)
                        InkWell(
                          child: Text(model.currentLogInUser!.email.toString(),
                              style: TextStyle(fontSize: 20)),
                          // onTap: ()=>ProfileScreen(selectedUser: model.currentLogInUserData,logInUser: model.currentLogInUser,),
                        ),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Example UserData',style: TextStyle(fontSize: 25),),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade300
                        ),
                        child: ListTile(
                          title: Text('UserName', style: TextStyle(fontSize: 25)),
                          subtitle: Text('Mail', style: TextStyle(fontSize: 20)),
                          leading: Icon(Icons.person, size: 35),
                          trailing: IconButton(
                              icon: Icon(Icons.add, size: 30),
                              onPressed: () async {
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUpScreen(),
                                        fullscreenDialog: true));
                              }),
                        ),
                      ),
                      SizedBox(height: 30),
                      Text('UsersList',style: TextStyle(fontSize: 25),),
                      SingleChildScrollView(
                        child: Column(
                            children: model.usersList.map((user) {
                              return userListTiles(context, model, user);
                        }).toList()),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
  Widget userListTiles(BuildContext context,ListViewModel model,user){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade300
      ),
      child: ListTile(
        title: Text('${user.name}',
            style: TextStyle(fontSize: 25)),
        subtitle: Text('${user.mail}',
            style: TextStyle(fontSize: 20)),
        leading: IconButton(
          icon: Icon(Icons.person, size: 35),
          onPressed: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfileScreen(selectedUser: user,logInUser: model.currentLogInUser,),
                    fullscreenDialog: true));
          },
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit, size: 30),
          onPressed: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SignUpScreen(user: user),
                    fullscreenDialog: true));
          },
        ),
        onLongPress: () async =>
            model.onPushDeleteUserFromFirebase(context, user),
      ),
    );

  }
}
