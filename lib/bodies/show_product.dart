import 'package:browniesuppermall/models/product_model.dart';
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
  List<ProductModel> productModels = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readData();
  }

  Future<Null> readData() async {
    if (productModels.length != 0) {
      productModels.clear();
    }

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
            for (var item in event.docs) {
              ProductModel model = ProductModel.fromMap(item.data());
              setState(() {
                haveProduct = true;
                load = false;
                productModels.add(model);
              });
            }
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/addProduct')
              .then((value) => readData()),
          child: Text('Add Product')),
      body: load
          ? MyStyle().showProgress()
          : haveProduct
              ? buildListView()
              : Center(child: MyStyle().titleH1('No Product')),
    );
  }

  ListView buildListView() {
    return ListView.builder(
      itemCount: productModels.length,
      itemBuilder: (context, index) => Card(color: index%2==0 ? Colors.green[100]: Colors.white ,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyStyle().titleH1(productModels[index].nameProduct),
                  MyStyle().titleH2Dark(
                      'ราคา ${productModels[index].price} บาท/${productModels[index].unit}')
                ],
            ),
            Row(
                children: [
                  Expanded(flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(productModels[index].pathProduct),
                    ),
                  ),
                  Expanded(flex: 1,
                    child: Text(productModels[index].detail),
                  ),
                ],
            )
          ],
        ),
              ),
      ),
    );
  }
}
