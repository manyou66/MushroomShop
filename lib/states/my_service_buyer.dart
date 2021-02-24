import 'package:browniesuppermall/utility/my_style.dart';
import 'package:flutter/material.dart';

class MyServiceBuyer extends StatefulWidget {
  @override
  _MyServiceBuyerState createState() => _MyServiceBuyerState();
}

class _MyServiceBuyerState extends State<MyServiceBuyer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buyer'),
      ),
      drawer: Drawer(
        child: MyStyle().buildSignOut(context),
      ),
      backgroundColor: MyStyle().primaryColor,
    );
  }
  
}