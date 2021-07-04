import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'add_screen/add_screen.dart';

class RadioListScreen extends StatefulWidget {
  @override
  _RadioListScreenState createState() => _RadioListScreenState();
}

class _RadioListScreenState extends State<RadioListScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  List<DocumentSnapshot> _usersList = [];

  var _gValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RadioListで表示'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            // _listTitle(),
            // SizedBox(
            //   height: 20,
            // ),
            SingleChildScrollView(
              child: Column(
                children: _usersList.map((document) {
                  return RadioListTile(
                    value: "${document['id']}",
                    title: Text(document['name']),
                    subtitle: Text(document['id']),
                    controlAffinity: ListTileControlAffinity.leading,
                    groupValue: _gValue,
                    onChanged: (value) =>_onRadioSelected(value),
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
                child: Text("リストを表示"),
                onPressed: () async {
                  final snapshot = await users.get();
                  setState(() {
                    _usersList = snapshot.docs;
                    print(_usersList);
                  });
                }),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddScreen()));
                },
                child: Text("編集")),
            Container(
              alignment: Alignment.centerRight,
              child: FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddScreen(),
                            fullscreenDialog: true));
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget _listTitle() {
    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
                child: Text(
              "Name",
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            )),
          ),
          Expanded(
            flex: 1,
            child: Container(
                child: Text(
              "ID",
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            )),
          )
        ],
      ),
    );
  }

  _onRadioSelected(value) {
    setState(() {
      _gValue = value;
      print(_gValue);
    });
  }

  _radioUserData(document) {
    return Container(
      child: Row(
        children: [
          Radio(
              value: "${document['id']}",
              groupValue: _gValue,
              onChanged: (value) => _onRadioSelected(value)),
          Container(
            // color: Colors.red,
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                        // color: Colors.blue,
                        child: Text(
                      '${document['name']}',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ))),
                Expanded(
                    flex: 1,
                    child: Container(
                        child: Text('${document['id']}',
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center))),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AddScreen()));
                    },
                    child: Text("編集")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
