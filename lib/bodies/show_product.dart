import 'package:browniesuppermall/utility/my_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ShowProduct extends StatefulWidget {
  @override
  _ShowProductState createState() => _ShowProductState();
}

class _ShowProductState extends State<ShowProduct> {
  bool load = true, haveProduct;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readData();
  }

  Future<Null> readData() async {
    await Firebase.initializeApp().then((value) async {
      FirebaseAuth.instance.authStateChanges().listen((event) async {
        await FirebaseFirestore.instance
            .collection('typeuser')
            .doc(event.uid)
            .collection('product')
            .snapshots()
            .listen((event) {
          if (event.docs.length == 0) {
            setState(() {
              haveProduct = false;
              load = false;
            });
          } else {
            setState(() {
              haveProduct = true;
              load = false;
            });
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/addProduct'),
          child: Text('Add Product')),
      body: load
          ? MyStyle().showProgress()
          : haveProduct
              ? Text('Have Product')
              : Center(child: MyStyle().titleH1('No Product')),
    );
  }
}
