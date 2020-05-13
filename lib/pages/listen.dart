import 'package:flutter/material.dart';
import 'package:parrot_flutter/components/headerNav.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListenPage extends StatefulWidget {
  @override
  _ListenPageState createState() => _ListenPageState();
}

class _ListenPageState extends State<ListenPage> {

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
      appBar: headerNav(
        title: data,
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('t'),
            ],
          ),

        ],
      ),
    );
  }
}

Future<String> getNamePreference() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final name = prefs.getString('name');

  return name.toString();
}