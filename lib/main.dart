import 'package:flutter/material.dart';
import 'package:parrot_flutter/components/headerNavHome.dart';
import 'package:parrot_flutter/variables/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parrot_flutter/pages/act1.dart';
import 'dart:async';

void main() => runApp(MaterialApp(
  home: Parrot(),
));

class Parrot extends StatefulWidget {
  @override
  _ParrotState createState() => _ParrotState();
}

class _ParrotState extends State<Parrot> {

  @override
  void initState() {
    super.initState();
    getNamePreference().then((name){
      setState(() {
        if(data != null) {
          data = name;
        } else {
          data = 'Activity 1';
        }
      });
    });
  }

  String data = 'Activity 1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: headerNavHome(
        title: 'Parrot',
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 0.0),
                child: GestureDetector(
                  onTap: () {
                    navigateToSubPage(context);
                  },
                  child: Text(
                    data,
                    style: TextStyle(
                      color: purplecolor,
                      fontSize: 26.0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        _displayDialog(context);
                      },
                      icon: Icon(Icons.edit, color: Colors.grey[700],),
                    ),
                    IconButton(
                      onPressed: () {
                      },
                      icon: Icon(Icons.delete, color: Colors.grey[700],),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(height: 20.0,),
        ],
      ),
      backgroundColor: bgcolor,
    );
  }
  TextEditingController _changeActivityName = TextEditingController();

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Edit Activity'),
            content: TextField(
              controller: _changeActivityName,
              autofocus: true,
              maxLength: 20,
              maxLines: 1,
              decoration: InputDecoration(hintText: "Activity name",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: purplecolor)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: purplecolor))
              ),

            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _changeActivityName.clear();
                },
              ),
              new FlatButton(
                child: new Text('Save'),
                onPressed: () {
                  setState(() {
                    data = _changeActivityName.text;
                  });
                  saveNamePreference(data);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}

Future<String> saveNamePreference(String name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('name', name);

  print(name);
  return prefs.getString(name);
}

Future<String> getNamePreference() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final name = prefs.getString('name');


  return name.toString();
}

Future navigateToSubPage(context) async {
  Navigator.push(context, MaterialPageRoute(builder: (context) => SubPage()));
}