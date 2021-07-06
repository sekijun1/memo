import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memo/list_view/list_view_screen.dart';
import 'package:memo/signup/signup_model.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  final user;

  SignUpScreen({this.user});

  final nameController = TextEditingController();
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  final imageURLController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bool isUpdate = user != null;
    if (isUpdate) {
      nameController.text = user.name;
      mailController.text = user.mail;
      passwordController.text = user.password;
      imageURLController.text = user.imageURL;

      FirebaseAuth.instance.signOut();
    }

    return ChangeNotifierProvider<SignUpModel>(
        create: (_) => SignUpModel(),
        child: Scaffold(
          appBar: AppBar(
            title: Text("SignUp"),
            centerTitle: true,
          ),
          body: Consumer<SignUpModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(30.0),
              child: Center(
                child: Column(
                  children: [
                    Text("UserName", style: TextStyle(fontSize: 25)),
                    nameInputTextField(model),
                    SizedBox(height: 50),
                    Text("Mail", style: TextStyle(fontSize: 25)),
                    // if (isUpdate == true)
                    //   Text(mailController.text, style: TextStyle(fontSize: 20)),
                    // if (isUpdate == false)
                      mailInputTextField(model),
                    SizedBox(height: 50),
                    Text("Password", style: TextStyle(fontSize: 25)),
                    // if (isUpdate == true)
                    //   Text(passwordController.text,
                    //       style: TextStyle(fontSize: 20)),
                    // if (isUpdate == false)
                      passwordInputTextField(model),
                    SizedBox(height: 50),
                    SizedBox(
                      width: 150,
                      height: 100,
                      child: isUpdate == true
                          ? imageURLController.text != ""
                              ? Image.network(imageURLController.text)
                              : Text('No Image Selected')
                          : Text('No Image Selected'),
                    ),
                    IconButton(
                        onPressed: () {
                          model.imageURL =
                              'https://toppng.com/uploads/preview/icons-logos-emojis-user-icon-png-transparent-11563566676e32kbvynug.png';
                          print(model.imageURL);
                        },
                        icon: Icon(Icons.library_add)),

                    // SizedBox(
                    //   width: 150,
                    //   height: 100,
                    //   child: model.imageFile == null
                    //       ? Text('No Image Selected.')
                    //       : Image.file(model.imageFile),
                    // ),
                    // IconButton(
                    //   icon: Icon(Icons.library_add),
                    //   onPressed: () async {
                    //     await model.showImagePicker();
                    //   },
                    // ),
                    ElevatedButton.icon(
                      icon: Icon(
                        isUpdate ? Icons.edit : Icons.login,
                        size: 20,
                      ),
                      label: Text(
                        isUpdate ? "Update & LogIn" : "SignUp & LogIn",
                        style: TextStyle(fontSize: 15),
                      ),
                      onPressed: () async {
                        isUpdate
                            ? onPushUpdate(model, context, user)
                            : onPushSignUp(model, context);
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
        ));
  }

  Widget nameInputTextField(model) {
    return TextField(
      controller: nameController,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      onChanged: (text) => model.name = text,
    );
  }

  Widget mailInputTextField(model) {
    return TextField(
      controller: mailController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(hintText: 'example@sekijun.com'),
      style: TextStyle(fontSize: 20),
      onChanged: (text) => model.mail = text,
    );
  }

  Widget passwordInputTextField(model) {
    return TextField(
      controller: passwordController,
      keyboardType: TextInputType.text,
      obscureText: true,
      style: TextStyle(fontSize: 20),
      onChanged: (text) => model.password = text,
    );
  }

  Future onPushSignUp(SignUpModel model, BuildContext context) async {
    try {
      await model.addUserToAuth();
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('登録しました'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                )
              ],
            );
          });
      print(model.auth.currentUser);
      Navigator.of(context).pop();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ListViewScreen(
                    logInUser: model.auth.currentUser,
                  )));
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

  Future onPushUpdate(SignUpModel model, BuildContext context, user) async {
    try {
      await model.updateUsers(user);
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('保存しました'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                )
              ],
            );
          });
      Navigator.of(context).pop();
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
