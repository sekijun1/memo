import 'package:flutter/material.dart';
import 'package:memo/signup/signup_model.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  final user;

  SignUpScreen({this.user});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignUpModel>(
      create: (_) => SignUpModel()..isUpdateCheck(user),
      child: Scaffold(
        appBar: AppBar(
          title: Text("SignUp"),
          centerTitle: true,
        ),
        body: Consumer<SignUpModel>(
          builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50),
                  Text("UserName", style: TextStyle(fontSize: 25)),
                  nameInputTextField(model),
                  SizedBox(height: 50),
                  Text("Mail", style: TextStyle(fontSize: 25)),
                  model.isUpdate == true
                      ? Text(model.mail, style: TextStyle(fontSize: 20))
                      : mailInputTextField(model),
                  SizedBox(height: 50),
                  Text("Password", style: TextStyle(fontSize: 25)),
                  model.isUpdate == true
                      ? Text(model.password, style: TextStyle(fontSize: 20))
                      : passwordInputTextField(model),
                  SizedBox(height: 50),
                  Center(
                    child: Column(
                      children: [
                        // SizedBox(
                        //   width: 150,
                        //   height: 100,
                        //   child: model.isUpdate == true
                        //       ? model.imageURL != ''
                        //           ? Image.network(model.imageURL)
                        //           : Text('No Image Selected')
                        //       : Text('No Image Selected'),
                        // ),
                        // IconButton(
                        //     onPressed: () {
                        //       model.imageURL =
                        //           'https://toppng.com/uploads/preview/icons-logos-emojis-user-icon-png-transparent-11563566676e32kbvynug.png';
                        //     },
                        //     icon: Icon(Icons.library_add)),
                        Column(
                          children: [
                            SizedBox(
                              width: 150,
                              height: 100,
                              child: model.imageFile == null
                                  ? Text('No Image Selected.')
                                  : Image.file(model.imageFile!),
                            ),
                            IconButton(
                              icon: Icon(Icons.library_add),
                              onPressed: () async => model.showImagePicker(),
                            )
                          ],
                        ),
                        ElevatedButton.icon(
                          icon: Icon(
                            model.isUpdate ? Icons.edit : Icons.login,
                            size: 20,
                          ),
                          label: Text(
                              model.isUpdate
                                  ? "Update & LogIn"
                                  : "SignUp & LogIn",
                              style: TextStyle(fontSize: 15)),
                          onPressed: () async {
                            model.isUpdate
                                ? model.onPushUpdate(context, user)
                                : model.onPushSignUp(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget nameInputTextField(model) {
    return TextField(
      controller: model.nameController,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      onChanged: (text) => model.name = text,
    );
  }

  Widget mailInputTextField(model) {
    return TextField(
      controller: model.mailController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(hintText: 'example@sekijun.com'),
      style: TextStyle(fontSize: 20),
      onChanged: (text) => model.mail = text,
    );
  }

  Widget passwordInputTextField(model) {
    return TextField(
      controller: model.passwordController,
      keyboardType: TextInputType.text,
      obscureText: true,
      style: TextStyle(fontSize: 20),
      onChanged: (text) => model.password = text,
    );
  }
}
