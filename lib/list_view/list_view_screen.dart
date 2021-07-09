import 'package:flutter/material.dart';
import 'package:memo/list_view/list_view_model.dart';
import 'package:memo/profile/profile_screen.dart';
import 'package:provider/provider.dart';

class ListViewScreen extends StatelessWidget {
  final String? logInUserUid;

  ListViewScreen({this.logInUserUid});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ListViewModel>(
      create: (_) => ListViewModel()
        ..fetchUsers()
        ..isCurrentUser(context),
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
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      model.currentUserMail(),
                      Expanded(child: SizedBox()),
                      IconButton(
                          icon: Icon(Icons.logout),
                          onPressed: () => model.logOutButton(context)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Example UserData',
                        style: TextStyle(fontSize: 25),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade300),
                        child: ListTile(
                          title:
                              Text('UserName', style: TextStyle(fontSize: 25)),
                          subtitle:
                              Text('Mail', style: TextStyle(fontSize: 20)),
                          leading: Icon(Icons.person, size: 35),
                          trailing: IconButton(
                              icon: Icon(Icons.add, size: 30),
                              onPressed: () =>
                                  model.onPushSignUpScreen(context)),
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        'UsersList',
                        style: TextStyle(fontSize: 25),
                      ),
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

  Widget userListTiles(BuildContext context, ListViewModel model, user) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.grey.shade300),
      child: ListTile(
        title: Text('${user.name}', style: TextStyle(fontSize: 25)),
        subtitle: Text('${user.mail}', style: TextStyle(fontSize: 20)),
        leading: IconButton(
          icon: Icon(Icons.person, size: 35),
          onPressed: () => model.onPushProfileScreen(context, user),
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit, size: 30),
          onPressed: () => model.onPushEditUserScreen(context, user),
        ),
        onLongPress: () async =>
            model.onPushDeleteUserFromFirebase(context, user),
      ),
    );
  }
}
