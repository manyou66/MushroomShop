import 'dart:io';
import 'dart:math';

import 'package:browniesuppermall/models/product_model.dart';
import 'package:browniesuppermall/utility/dialog.dart';
import 'package:browniesuppermall/utility/my_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  double screen;
  File file;
  String nameProduct, detail, price, unit, stock;

  Container buildStock() {
    return Container(
      margin: EdgeInsets.only(top: 18, left: 4),
      width: screen * 0.4,
      child: TextField(
        keyboardType: TextInputType.number,
        onChanged: (value) => stock = value.trim(),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.book,
            color: MyStyle().darkColor,
          ),
          labelStyle: TextStyle(
            color: MyStyle().darkColor,
          ),
          labelText: 'Stock :',
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

  Container buildNameProduct() {
    return Container(
      margin: EdgeInsets.only(top: 18),
      width: screen * 0.6,
      child: TextField(
        onChanged: (value) => nameProduct = value.trim(),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.add_box,
            color: MyStyle().darkColor,
          ),
          labelStyle: TextStyle(
            color: MyStyle().darkColor,
          ),
          labelText: 'Name Product :',
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

  Container buildPrice() {
    return Container(
      margin: EdgeInsets.only(top: 18),
      width: screen * 0.4,
      child: TextField(
        keyboardType: TextInputType.number,
        onChanged: (value) => price = value.trim(),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.money,
            color: MyStyle().darkColor,
          ),
          labelStyle: TextStyle(
            color: MyStyle().darkColor,
          ),
          labelText: 'Price :',
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

  Container buildUnit() {
    return Container(
      margin: EdgeInsets.only(top: 18, left: 4),
      width: screen * 0.4,
      child: TextField(
        onChanged: (value) => unit = value.trim(),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.ac_unit,
            color: MyStyle().darkColor,
          ),
          labelStyle: TextStyle(
            color: MyStyle().darkColor,
          ),
          labelText: 'Unit :',
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

  Container buildDetail() {
    return Container(
      margin: EdgeInsets.only(top: 18),
      width: screen * 0.6,
      child: TextField(
        onChanged: (value) => detail = value.trim(),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.details,
            color: MyStyle().darkColor,
          ),
          labelStyle: TextStyle(
            color: MyStyle().darkColor,
          ),
          labelText: 'Detail :',
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

  Future<Null> getImage(ImageSource source) async {
    try {
      var result = await ImagePicker().getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        file = File(result.path);
      });
    } catch (e) {}
  }

  Container buildImage() {
    return Container(
        width: screen * 0.5,
        height: screen * 0.5,
        child: file == null ? MyStyle().showImage() : Image.file(file));
  }

  Row buildRowImage() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.add_a_photo),
          onPressed: () => getImage(ImageSource.camera),
        ),
        buildImage(),
        IconButton(
          icon: Icon(Icons.add_photo_alternate),
          onPressed: () => getImage(ImageSource.gallery),
        ),
      ],
    );
  }

  Container buildAddProduct() {
    return Container(
      margin: EdgeInsets.only(top: 8),
      width: screen * 0.6,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: MyStyle().primaryColor,
        ),
        onPressed: () {
          if ((nameProduct?.isEmpty ?? true) ||
              (detail?.isEmpty ?? true) ||
              (price?.isEmpty ?? true) ||
              (unit?.isEmpty ?? true) ||
              (stock?.isEmpty ?? true)) {
            normalDialog(context, 'Have Space', 'Please Fill Every Blank');
          } else if (file == null) {
            normalDialog(context, 'No Image', 'Please Choose Image ?');
          } else {
            uploadAndInsertData();
          }
        },
        child: Text('Add Product'),
      ),
    );
  }

  Future<Null> uploadAndInsertData() async {
    int i = Random().nextInt(1000000);
    String nameFile = 'product$i.jpg';

    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        String uid = event.uid;
        Reference reference =
            FirebaseStorage.instance.ref().child('product/$nameFile');
        UploadTask task = reference.putFile(file);
        await task.whenComplete(() async {
          await reference.getDownloadURL().then((value) async {
            String urlImage = value;

            ProductModel model = ProductModel(
              uidShop: uid,
              nameProduct: nameProduct,
              price: price,
              unit: unit,
              detail: detail,
              stock: stock,
              pathProduct: urlImage,
            );
            Map<String, dynamic> data = model.toMap();

            await FirebaseFirestore.instance
                .collection('typeuser')
                .doc(uid)
                .collection('product')
                .doc()
                .set(data)
                .then((value) => Navigator.pop(context));
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyStyle().primaryColor,
        title: Text('Add Product'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildRowImage(),
            buildNameProduct(),
            buildDetail(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildPrice(),
                buildUnit(),
              ],
            ),
            buildStock(),
            buildAddProduct(),
          ],
        ),
      ),
    );
  }
}
