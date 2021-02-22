import 'package:browniesuppermall/states/authen.dart';
import 'package:browniesuppermall/states/create_account.dart';
import 'package:browniesuppermall/states/my_service_buyer.dart';
import 'package:browniesuppermall/states/my_service_shopper.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => Authen(),
  '/createAccount': (BuildContext context) => CreateAccount(),
  '/myServiceBuyer': (BuildContext context) => MyServiceBuyer(),
  '/myServiceShopper': (BuildContext context) => MyServiceShopper(),
};

String iniRoute = '/authen';

main()=>runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: map,
      title: 'MushroomShop',
      initialRoute: iniRoute,
    );
  }
}
