import 'package:browniesuppermall/models/order_model.dart';
import 'package:browniesuppermall/models/sqlite_model.dart';
import 'package:browniesuppermall/models/typeuser.dart';
import 'package:browniesuppermall/utility/my_style.dart';
import 'package:browniesuppermall/utility/sulite_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ShowCartUser extends StatefulWidget {
  @override
  _ShowCartUserState createState() => _ShowCartUserState();
}

class _ShowCartUserState extends State<ShowCartUser> {
  List<SQLiteModel> sqliterModels = [];
  bool load = true, haveData;
  int total = 0;
  List<String> namerProducts = [];
  List<String> prices = [];
  List<String> sums = [];
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readSQLite();
  }

  Future<Null> readSQLite() async {
    if (sqliterModels.length != 0) {
      sqliterModels.clear();
      total = 0;
    }
    await SQLiteHelper().readAllData().then((value) {
      print('### value ==> $value');
      setState(() {
        load = false;
      });
      for (var item in value) {
        int sumInt = int.parse(item.sum);
        setState(() {
          total = total + sumInt;
          sqliterModels = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: buildFloatingActionButton(),
      body: load
          ? MyStyle().showProgress()
          : sqliterModels.length == 0
              ? Center(child: MyStyle().titleH1('Empty Cart'))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyStyle().titleH1(sqliterModels[0].nameShop),
                      buildHead(),
                      buildListView(),
                      Divider(
                        thickness: 3,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                MyStyle().titleH2Dark('Total : '),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: MyStyle().titleH2Dark(total.toString()),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
    );
  }

  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => processOrder(),
      child: Text('Order'),
    );
  }

  Future<Null> processOrder() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        String uidBuyer = event.uid;

        await FirebaseFirestore.instance
            .collection('typeuser')
            .doc(uidBuyer)
            .snapshots()
            .listen((event) {
          TypeUserModel typeUserModel = TypeUserModel.fromMap(event.data());
          String nameBuyer = typeUserModel.name;
          OrderModel orderModel = OrderModel(
            uidBuyer: uidBuyer,
            nameBuyer: nameBuyer,
            nameProducts: 
          );
        });
      });
    });
  }

  Container buildHead() {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[300]),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: MyStyle().titleH3Dark('Product'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().titleH3Dark('Price'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().titleH3Dark('Amount'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().titleH3Dark('Sum'),
          ),
          Expanded(
            flex: 1,
            child: SizedBox(),
          ),
        ],
      ),
    );
  }

  ListView buildListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: sqliterModels.length,
      itemBuilder: (context, index) => Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(sqliterModels[index].nameProduct),
          ),
          Expanded(
            flex: 1,
            child: Text(sqliterModels[index].price),
          ),
          Expanded(
            flex: 1,
            child: Text(sqliterModels[index].amount),
          ),
          Expanded(
            flex: 1,
            child: Text(sqliterModels[index].sum),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  print("### delete id = ${sqliterModels[index].id}");
                  await SQLiteHelper()
                      .deleteSQLiteById(sqliterModels[index].id)
                      .then((value) => readSQLite());
                }),
          ),
        ],
      ),
    );
  }
}
