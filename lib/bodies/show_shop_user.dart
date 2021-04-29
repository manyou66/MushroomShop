import 'package:browniesuppermall/models/typeuser.dart';
import 'package:browniesuppermall/utility/my_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ShowShopUser extends StatefulWidget {
  @override
  _ShowShopUserState createState() => _ShowShopUserState();
}

class _ShowShopUserState extends State<ShowShopUser> {
  bool load = true;
  List<TypeUserModel> typeUserModels = [];
  List<Widget> widgets = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readData();
  }

  Future<Null> readData() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('typeuser')
          .snapshots()
          .listen((event) {
        setState(() {
          for (var item in event.docs) {
            TypeUserModel model = TypeUserModel.fromMap(item.data());
            if (model.typeuser == 'shopper') {
              setState(() {
                typeUserModels.add(model);
                widgets.add(createWiget(model));
              });
            }
          }
          load = false;
        });
      });
    });
  }

  Widget createWiget(TypeUserModel model) {
    return Card(
      color: MyStyle().lightColor,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              child: model.urlshopper == null
                  ? Image.asset('images/image.png')
                  : Image.network(model.urlshopper),
            ),
            MyStyle().titleH3White(model.name),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load
          ? MyStyle().showProgress()
          : GridView.extent(
              maxCrossAxisExtent: 160,
              children: widgets,
            ),
    );
  }
}
