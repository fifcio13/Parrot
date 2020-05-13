import 'package:flutter/material.dart';
import 'package:parrot_flutter/components/headerNav.dart';
import 'package:parrot_flutter/pages/listen.dart';
import 'package:parrot_flutter/pages/record.dart';
import 'package:parrot_flutter/variables/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubPage extends StatefulWidget {

  @override
  _SubPageState createState() => _SubPageState();
}

class _SubPageState extends State<SubPage> {
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
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
                RawMaterialButton(
                      onPressed: () {
                        navigateToListenPage(context);
                      },
                      elevation: 3.0,
                      fillColor: Colors.white,
                      splashColor: purplecolor,
                      child: Icon(
                        Icons.headset,
                        size: 80.0,
                      ),
                      padding: EdgeInsets.all(15.0),
                      shape: CircleBorder(),
                    ),
                RawMaterialButton(
                    onPressed: () {
                      navigateToRecordPage(context);
                    },
                    elevation: 3.0,
                    fillColor: Colors.white,
                    splashColor: purplecolor,
                    child: Icon(
                      Icons.mic,
                      size: 80.0,
                    ),
                    padding: EdgeInsets.all(15.0),
                    shape: CircleBorder(),
                  ),
            ],
          ),
      ),
    );
  }
}

Future<String> getNamePreference() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final name = prefs.getString('name');

  return name.toString();
}

Future navigateToListenPage(context) async {
  Navigator.push(context, MaterialPageRoute(builder: (context) => ListenPage()));
}
Future navigateToRecordPage(context) async {
  Navigator.push(context, MaterialPageRoute(builder: (context) => AppBody()));
}