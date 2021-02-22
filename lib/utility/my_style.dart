import 'package:flutter/material.dart';

class MyStyle {
  Color darkColor = Color(0xffc50e29);
  Color primaryColor = Color(0xffff5252);
  Color lightColor = Color(0xffff867f);

  Widget showLogo() => Image(image: AssetImage('images/logo.png'));
  Widget titleH1(String string) => Text(
        string,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: darkColor,
        ),
      );

  MyStyle();
}
