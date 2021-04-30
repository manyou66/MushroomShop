import 'package:browniesuppermall/models/product_model.dart';
import 'package:browniesuppermall/models/sqlite_model.dart';
import 'package:browniesuppermall/models/typeuser.dart';
import 'package:browniesuppermall/utility/dialog.dart';
import 'package:browniesuppermall/utility/my_style.dart';
import 'package:browniesuppermall/utility/sulite_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ShowProductUser extends StatefulWidget {
  //class recive data
  final TypeUserModel typeUserModel;
  final String uidShop;
  ShowProductUser({@required this.typeUserModel, @required this.uidShop});
  @override
  _ShowProductUserState createState() => _ShowProductUserState();
}

class _ShowProductUserState extends State<ShowProductUser> {
  TypeUserModel typeUserModel;
  String uidShop;
  bool load = true, haveData;
  List<ProductModel> productModels = [];
  List<String> idProducts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    typeUserModel = widget.typeUserModel;
    uidShop = widget.uidShop;
    readData();
  }

  Future<Null> readData() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('typeuser')
          .doc(uidShop)
          .collection('product')
          .snapshots()
          .listen((event) {
        if (event.docs.length == 0) {
          setState(() {
            haveData = false;
            load = false;
          });
        } else {
          for (var item in event.docs) {
            String idProduct = item.id;
            idProducts.add(idProduct);
            ProductModel model = ProductModel.fromMap(item.data());
            setState(() {
              haveData = true;
              load = false;
              productModels.add(model);
            });
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyStyle().primaryColor,
        title: Text(typeUserModel.name),
      ),
      body: load
          ? MyStyle().showProgress()
          : haveData
              ? buildListView()
              : Center(child: MyStyle().titleH1('No Product')),
    );
  }

  Future<Null> addCartDialog(
      ProductModel productModel, String idProduct) async {
    int amount = 1;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => SimpleDialog(
          title: ListTile(
            leading: Image.network(productModel.pathProduct),
            title: MyStyle().titleH1(productModel.nameProduct),
            subtitle: MyStyle().titleH2Dark(
                'ราคา ${productModel.price} บาท/${productModel.unit}'),
          ),
          children: [
            Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: MyStyle().titleH2Dark('รายละเอียด')),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Text(productModel.detail)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.add_circle_rounded,
                    color: Colors.green[300],
                  ),
                  onPressed: () {
                    setState(() {
                      amount++;
                      print('### amount = $amount');
                    });
                  },
                ),
                MyStyle().titleH1('$amount'),
                IconButton(
                  icon: Icon(
                    Icons.remove_circle_rounded,
                    color: Colors.red[700],
                  ),
                  onPressed: () {
                    if (amount <= 1) {
                      amount = 1;
                    } else {
                      setState(() {
                        amount--;
                        print('### amount = $amount');
                      });
                    }
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    processAddCart(productModel, amount, idProduct);
                  },
                  child: Text('Add Cart'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.red[700],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> processAddCart(
      ProductModel productModel, int amount, String idProduct) async {
    print('### You Order ${productModel.nameProduct} amount ==> $amount');
    int priceInt = int.parse(productModel.price);
    int sum = priceInt * amount;
    SQLiteModel sqLiteModel = SQLiteModel(
        idShop: uidShop,
        nameShop: typeUserModel.name,
        idProduct: idProduct,
        nameProduct: productModel.nameProduct,
        price: productModel.price,
        amount: amount.toString(),
        sum: sum.toString());

    await SQLiteHelper().readAllData().then((value) async {
      if (value.length == 0) {
        await SQLiteHelper()
            .insertValueToSQLite(sqLiteModel)
            .then((value) => print('### insert Success ###'));
      } else {
        String idShopSQLite;
        for (var item in value) {
          idShopSQLite = item.idShop;
        }
        if (idShopSQLite != uidShop) {
          normalDialog(context, 'ยังเลือกร้านนี้ไม่ได้',
              'กรุณา Order ร้านเดิมให้จบก่อน');
        } else {
          await SQLiteHelper()
              .insertValueToSQLite(sqLiteModel)
              .then((value) => print('### insert Success ###'));
        }
      }
    });
  }

  ListView buildListView() {
    return ListView.builder(
      itemCount: productModels.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () => addCartDialog(productModels[index], idProducts[index]),
        child: Card(
          color: index % 2 == 0 ? Colors.green[100] : Colors.white,
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
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(productModels[index].pathProduct),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(productModels[index].detail),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
