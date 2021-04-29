import 'package:browniesuppermall/bodies/show_cart_user.dart';
import 'package:browniesuppermall/bodies/show_order_user.dart';
import 'package:browniesuppermall/bodies/show_shop_user.dart';
import 'package:browniesuppermall/utility/my_style.dart';
import 'package:flutter/material.dart';

class MyServiceBuyer extends StatefulWidget {
  @override
  _MyServiceBuyerState createState() => _MyServiceBuyerState();
}

class _MyServiceBuyerState extends State<MyServiceBuyer> {
  List<Widget> widgets = [
    ShowShopUser(),
    ShowCartUser(),
    ShowOrderUser(),
  ];
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: MyStyle().primaryColor,
        title: Text('Buyer'),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            MyStyle().buildSignOut(context),
            Column(
              children: [
                buildUserAccountsDrawerHeader(),
                buildMenuShowShop(context),
                buildMenuShowCart(context),
                buildMenuShowOrder(context)
              ],
            ),
          ],
        ),
      ),
      body: widgets[index],
    );
  }

  ListTile buildMenuShowShop(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.filter_1),
      title: Text('Show shop'),
      subtitle: Text('แสดงร้านค้า ทั้งหมด'),
      onTap: () {
        setState(() {
          index = 0;
        });
        Navigator.pop(context);
      },
    );
  }

  ListTile buildMenuShowCart(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.filter_2),
      title: Text('Show Cart'),
      subtitle: Text('แสดงสินค้า ใน ตะกร้า'),
      onTap: () {
        setState(() {
          index = 1;
        });
        Navigator.pop(context);
      },
    );
  }

  ListTile buildMenuShowOrder(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.filter_3),
      title: Text('Show Order'),
      subtitle: Text('แสดงรายการสินค้า ที่ order'),
      onTap: () {
        setState(() {
          index = 2;
        });
        Navigator.pop(context);
      },
    );
  }

  UserAccountsDrawerHeader buildUserAccountsDrawerHeader() {
    return UserAccountsDrawerHeader(
      accountName: null,
      accountEmail: null,
    );
  }
}
