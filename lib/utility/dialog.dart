import 'package:browniesuppermall/main.dart';
import 'package:browniesuppermall/utility/my_style.dart';
import 'package:flutter/material.dart';

Future<Null> normalDialog(
    BuildContext context, String title, String message) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: ListTile(
        leading: MyStyle().showLogo(),
        title: MyStyle().titleH1(title),
        subtitle: MyStyle().titleH3Button(message),
      ),
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('OK'),
        )
      ],
    ),
  );
}
