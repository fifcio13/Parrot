import 'package:flutter/material.dart';
import 'package:parrot_flutter/variables/variables.dart';

AppBar headerNav({String title}){
  return AppBar(
    iconTheme: IconThemeData(
      color: purplecolor,
    ),
    title: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            child: Text(title,
              style: TextStyle(
                color: textcolorprimary,
                fontSize: 26.0,
                fontFamily: 'Lato',
              ),
            )),
      ],
    ),
    backgroundColor: navcolor,
    centerTitle: true,
  );
}