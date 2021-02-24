import 'package:browniesuppermall/models/typeuser.dart';
import 'package:browniesuppermall/states/add_information.dart';
import 'package:browniesuppermall/states/authen.dart';
import 'package:browniesuppermall/states/create_account.dart';
import 'package:browniesuppermall/states/my_service_buyer.dart';
import 'package:browniesuppermall/states/my_service_shopper.dart';
import 'package:browniesuppermall/utility/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => Authen(),
  '/createAccount': (BuildContext context) => CreateAccount(),
  '/myServiceBuyer': (BuildContext context) => MyServiceBuyer(),
  '/myServiceShopper': (BuildContext context) => MyServiceShopper(),
  '/addInformation':(BuildContext context) => AddInformatin(),
};

String iniRoute = '/authen';

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized(); //connect to firebase first
  await Firebase.initializeApp().then((value) async {
    await FirebaseAuth.instance.authStateChanges().listen((event) async {
      if (event != null) {
        String uid = event.uid;
        await FirebaseFirestore.instance
            .collection('typeuser')
            .doc(uid)
            .snapshots()
            .listen((event) {
          TypeUserModel model = TypeUserModel.fromMap(event.data());
          String typeuser = model.typeuser;
          print('uid ==> $uid, typeuser ==>$typeuser');
          iniRoute = Api().findKeyByTypeUser(typeuser);
          runApp(MyApp());
        });

        // TypeUserModel model = await Api().findTypeUserByUid(uid);
        // iniRoute = Api().findKeyByTypeUser(model.typeuser);
        // //iniRoute = model.typeuser;
        // runApp(MyApp());
      } else {
        runApp(MyApp());
      }
    });
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      routes: map,
      title: 'MushroomShop',
      initialRoute: iniRoute,
    );
  }
}
