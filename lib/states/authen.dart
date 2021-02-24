import 'package:browniesuppermall/models/typeuser.dart';
import 'package:browniesuppermall/utility/api.dart';
import 'package:browniesuppermall/utility/dialog.dart';
import 'package:browniesuppermall/utility/my_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  double screen;
  String user, password;

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width; //adjust size
    return Scaffold(
      body: SafeArea(
        //stay in area is correctly
        child: Stack(
          children: [
            MyStyle().buildBackGround(context),
            buildCreatAccount(),
            buildContent(),
          ],
        ),
      ),
    );
  }

  Column buildCreatAccount() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyStyle().titleH3Dark('Non Account ?'),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/createAccount'),
              child: MyStyle().titleH3Button('Create Button'),
            )
          ],
        ),
      ],
    );
  }

  Center buildContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildLogo(),
          MyStyle().titleH1('Mushroomshop'),
          buildUser(),
          buildPassword(),
          buildLogin()
        ],
      ),
    );
  }

  Container buildLogin() {
    return Container(
      margin: EdgeInsets.only(top: 8),
      width: screen * 0.6,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: MyStyle().primaryColor,
        ),
        onPressed: () {
          if ((user?.isEmpty ?? true) || (password?.isEmpty ?? true)) {
            normalDialog(context, 'Have Space', 'Please Fill Every Blank');
          } else {
            checkAuthen();
          }
        },
        child: Text('Login'),
      ),
    );
  }

  Future<Null> checkAuthen() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: user, password: password)
          .then((value) async {
        await FirebaseFirestore.instance
            .collection('typeuser')
            .doc(value.user.uid)
            .snapshots()
            .listen((event) {
          TypeUserModel model = TypeUserModel.fromMap(event.data());
          Navigator.pushNamedAndRemoveUntil(context,
              Api().findKeyByTypeUser(model.typeuser), (route) => false);
        });
      }).catchError((onError) =>
              normalDialog(context, onError.code, onError.message));
    });
  }

  Container buildUser() {
    return Container(
      margin: EdgeInsets.only(top: 18),
      width: screen * 0.6,
      child: TextField(
        onChanged: (value) => user = value.trim(),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.perm_identity,
            color: MyStyle().darkColor,
          ),
          labelStyle: TextStyle(
            color: MyStyle().darkColor,
          ),
          labelText: 'User :',
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

  Container buildPassword() {
    return Container(
      margin: EdgeInsets.only(top: 18),
      width: screen * 0.6,
      child: TextField(
        onChanged: (value) => password = value.trim(),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock_outline,
            color: MyStyle().darkColor,
          ),
          labelStyle: TextStyle(
            color: MyStyle().darkColor,
          ),
          labelText: 'Password :',
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

  Container buildLogo() {
    return Container(
      width: screen * 0.3,
      child: MyStyle().showLogo(),
    );
  }
}
