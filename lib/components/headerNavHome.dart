import 'package:flutter/material.dart';
import 'package:parrot_flutter/variables/variables.dart';

AppBar headerNavHome({String title}){
  return AppBar(
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
        Image.asset(
          'assets/appbar/logo.png',
          fit: BoxFit.contain,
          height: 46,
        ),
      ],
    ),
    backgroundColor: navcolor,
    centerTitle: true,
  );
}