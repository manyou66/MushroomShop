import 'package:browniesuppermall/models/typeuser.dart';
import 'package:browniesuppermall/utility/api.dart';
import 'package:browniesuppermall/utility/dialog.dart';
import 'package:browniesuppermall/utility/my_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  double screen;
  String typeUser, name, user, password;

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyStyle().primaryColor,
        title: Text('Create Account'),
      ),
      body: Stack(
        children: [
          MyStyle().buildBackGround(context),
          buildContent(),
        ],
      ),
    );
  }

  Container buildDisplayName() {
    return Container(
      margin: EdgeInsets.only(top: 18),
      width: screen * 0.6,
      child: TextField(
        onChanged: (value) => name = value.trim(),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.fingerprint,
            color: MyStyle().darkColor,
          ),
          labelStyle: TextStyle(
            color: MyStyle().darkColor,
          ),
          labelText: 'DisplayName :',
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
            Icons.lock_open_outlined,
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

  Center buildContent() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildDisplayName(),
            Card(
              child: Container(
                width: screen * 0.6,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          MyStyle().titleH2Dark('Type User'),
                        ],
                      ),
                      RadioListTile(
                        value: 'buyer',
                        groupValue: typeUser,
                        onChanged: (value) {
                          setState(() {
                            typeUser = value;
                          });
                        },
                        title: MyStyle().titleH3Dark('User'),
                      ),
                      Container(
                        width: screen * 0.6,
                        child: RadioListTile(
                          value: 'shopper',
                          groupValue: typeUser,
                          onChanged: (value) {
                            setState(() {
                              typeUser = value;
                            });
                          },
                          title: MyStyle().titleH3Dark('Shopper'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            buildUser(),
            buildPassword(),
            buildButtonCreateAccount()
          ],
        ),
      ),
    );
  }

  Future<Null> createSingInAndInsertData() async {
    await Firebase.initializeApp().then(
      (value) async {
        print('Firebase Initalize Success');
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: user, password: password)
            .then((value) async {
          String uid = value.user.uid;
          print('uid ==> $uid');
          //update Display Name
          await value.user
              .updateProfile(displayName: name)
              .then((value) => print('display name success'));
          //Insert Value to /cloud Firestore
          TypeUserModel model = TypeUserModel(name: name, typeuser: typeUser);
          Map<String, dynamic> data = model.toMap();
          print('map ==> ${data.toString()}');
          await FirebaseFirestore.instance
              .collection('typeuser')
              .doc(uid)
              .set(data)
              .then((value) {
            String result = Api().findKeyByTypeUser(typeUser);
            print('result = $result');
            Navigator.pushNamedAndRemoveUntil(
                context, result, (route) => false);
          });
        }).catchError((onError) =>
                normalDialog(context, onError.code, onError.message));
      },
    );
  }

  Container buildButtonCreateAccount() {
    return Container(
      margin: EdgeInsets.only(top: 8),
      width: screen * 0.6,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(primary: MyStyle().primaryColor),
        onPressed: () {
          if ((name?.isEmpty ?? true) ||
              (user?.isEmpty ?? true) ||
              (password?.isEmpty ?? true)) {
            normalDialog(context, 'Have Space', 'Please Fill Every Blank');
          } else if (typeUser == null) {
            normalDialog(context, 'No TypeUser',
                'Please Choose Type User by Click Buyer or Shopper');
          } else {
            createSingInAndInsertData();
          }
        },
        icon: Icon(Icons.cloud_upload),
        label: Text('Create Account'),
      ),
    );
  }
}
