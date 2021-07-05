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

  @override
  Widget build(BuildContext context) {
    final bool isUpdate = user != null;

    if (isUpdate) {
      nameController.text = user.name;
      mailController.text = user.mail;
      passwordController.text = user.password;
    }
    print(isUpdate);
    print(nameController.text);
    print(mailController.text);
    print(passwordController.text);

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
                  mailInputTextField(model),
                  SizedBox(height: 50),
                  Text("Password", style: TextStyle(fontSize: 25)),
                  passwordInputTextField(model),
                  SizedBox(height: 50),
                  SizedBox(
                    width: 150,
                    height: 100,
                    child: Text('No Image Selected'),
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
              ElevatedButton(
                child: Text("登録する"),
                onPressed: () async {
                  onPushSignUp(model, context);
                },
              )
              ],
            ),)
            ,
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
              builder: (context) =>
                  ListViewScreen(
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
}
