import 'package:flutter/material.dart';
import 'package:parrot_flutter/components/headerNav.dart';


void main() => runApp(new Record());

class Record extends StatefulWidget{
  @override
  _RecordState createState() => _RecordState();
}

class _RecordState extends State<Record> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: headerNav(title: 'Recording screen'),
      body: Center(

      ),
    );
  }
}
