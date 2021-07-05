import 'package:flutter/material.dart';
import 'package:memo/add_screen/add_model.dart';
import 'package:provider/provider.dart';

class AddScreen extends StatelessWidget {
  final user;
  AddScreen({this.user});

  final nameController = TextEditingController();
  // final mailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bool isUpdate = user != null;

    if (isUpdate) {
      nameController.text = user.name;
      // mailController.text = user.mail;
    }
    print(isUpdate);
    print(nameController.text);
    // print(mailController.text);

    return ChangeNotifierProvider<AddScreenModel>(
        create: (_) => AddScreenModel(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(isUpdate ? "ユーザー情報を編集" : "ユーザー情報を追加"),
            centerTitle: true,
          ),
          body: Consumer<AddScreenModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  Text("User Name", style: TextStyle(fontSize: 25)),
                  nameInputTextField(model),
                  SizedBox(height: 50),
                  // Text("Mail", style: TextStyle(fontSize: 25)),
                  // mailInputTextField(model),
                  // SizedBox(height: 50),
                  ElevatedButton(
                    child: Text(isUpdate ? "更新する" : "追加する"),
                    onPressed: () async {
                      if (isUpdate) {
                        await model.onPushEditUser(context,user);
                      } else {
                        await model.onPushAddUser(context);
                      }
                    },
                  )
                ],
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
      onChanged:(text)=> model.name = text,

    );
  }

  // Widget mailInputTextField(model) {
  //   return TextField(
  //     controller: mailController,
  //     keyboardType: TextInputType.text,
  //     decoration: InputDecoration(hintText: 'example@sekijun.com'),
  //     style: TextStyle(fontSize: 20),
  //     onChanged:(text)=> model.mail = text,
  //   );
  // }


}
