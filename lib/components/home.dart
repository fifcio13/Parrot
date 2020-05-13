import 'package:flutter/material.dart';
import 'package:parrot_flutter/variables/variables.dart';
import 'headerNavHome.dart';
import 'package:parrot_flutter/main.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {


  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var activityOne = 'Activity 1';

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
                child: Text(
                  activityOne,
                  style: TextStyle(
                    color: purplecolor,
                    fontSize: 26.0,
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
            title: Text('TextField in Dialog'),
            content: TextField(
              controller: _changeActivityName,
              decoration: InputDecoration(hintText: "TextField in Dialog"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();

                },
              ),
              new FlatButton(
                child: new Text('Save'),
                onPressed: () {
                  setState(() {
                    activityOne = _changeActivityName.text;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

}
