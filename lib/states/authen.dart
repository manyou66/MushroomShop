import 'package:browniesuppermall/utility/my_style.dart';
import 'package:flutter/material.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  double screen;

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width; //adjust size
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildLogo(),
            MyStyle().titleH1('Mushroomshop'),
            buildUser(),
            buildPassword(),
          ],
        ),
      ),
    );
  }

  Container buildUser() {
    return Container(
      margin: EdgeInsets.only(top: 18),
      width: screen * 0.6,
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.perm_identity,
            color: MyStyle().darkColor,
          ),
          labelStyle: TextStyle(
            color: MyStyle().darkColor,
          ),
          labelText: 'User :',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: MyStyle().darkColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: MyStyle().lightColor,
            ),
          ),
        ),
      ),
    );
  }

  Container buildPassword() {
    return Container(
      margin: EdgeInsets.only(top: 18),
      width: screen * 0.6,
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock_outline,
            color: MyStyle().darkColor,
          ),
          labelStyle: TextStyle(
            color: MyStyle().darkColor,
          ),
          labelText: 'Password :',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: MyStyle().darkColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: MyStyle().lightColor,
            ),
          ),
        ),
      ),
    );
  }

  Container buildLogo() {
    return Container(
      width: screen * 0.3,
      child: MyStyle().showLogo(),
    );
  }
}
