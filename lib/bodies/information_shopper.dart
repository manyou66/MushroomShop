import 'package:browniesuppermall/models/typeuser.dart';
import 'package:browniesuppermall/utility/my_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class InformationShopper extends StatefulWidget {
  @override
  _InformationShopperState createState() => _InformationShopperState();
}

class _InformationShopperState extends State<InformationShopper> {
  double screen;
  TypeUserModel typeUserModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUserByUid();
  }

  Future<Null> findUserByUid() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        await FirebaseFirestore.instance
            .collection('typeuser')
            .doc(event.uid)
            .snapshots()
            .listen((event) {
          setState(() {
            typeUserModel = TypeUserModel.fromMap(event.data());
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: buildEdit(context),
      body: Center(
        child: Column(
          children: [
            buildImage(),
            MyStyle()
                .titleH1(typeUserModel == null ? 'Name' : typeUserModel.name),
          ],
        ),
      ),
    );
  }

  FloatingActionButton buildEdit(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, '/addInformation'),
      child: MyStyle().titleH3Dark('Edit'),
    );
  }

  Container buildImage() {
    return Container(
      width: screen * 0.5,
      height: screen * 0.5,
      child: typeUserModel.urlshopper == null
          ? MyStyle().showImage()
          : Image.network(typeUserModel.urlshopper),
    );
  }
}
