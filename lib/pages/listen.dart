import 'package:flutter/material.dart';
import 'package:parrot_flutter/components/headerNav.dart';


void main() => runApp(new Listen());

class Listen extends StatefulWidget{
  @override
  _RecordState createState() => _RecordState();
}

class _RecordState extends State<Listen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: headerNav(title: 'Listening screen'),
      body: Center(

      ),
    );
  }
}
