import 'dart:io';
import 'dart:math';

import 'package:browniesuppermall/models/typeuser.dart';
import 'package:browniesuppermall/utility/my_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddInformatin extends StatefulWidget {
  @override
  _AddInformatinState createState() => _AddInformatinState();
}

class _AddInformatinState extends State<AddInformatin> {
  double screen;
  List<String> name = ['', ''];
  TypeUserModel typeUserModel;
  File file;
  String uid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readInitialValue();
  }

  Future<Null> readInitialValue() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        uid = event.uid;
        FirebaseFirestore.instance
            .collection('typeuser')
            .doc(event.uid)
            .snapshots()
            .listen((event) {
          setState(() {
            typeUserModel = TypeUserModel.fromMap(event.data());
            name[0] = typeUserModel.name;
            print('name = $name[0]');
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
        title: MyStyle().titleH3Button('Add of Edit Information'),
      ),
      body: name[0].isEmpty ? CircularProgressIndicator() : buildContent(),
    );
  }

  Widget buildContent() {
    return SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildRowImage(),
          buildName(),
          buildUploadData(),
        ],
      ),
    );
  }

  Future<Null> uploadImageToFirebase() async {
    int i = Random().nextInt(100000);
    String fileName = 'shop$i.jpg';

    await Firebase.initializeApp().then((value) async {
      UploadTask task = FirebaseStorage.instance
          .ref()
          .child('shopper/$fileName')
          .putFile(file);
      await task.whenComplete(() async {
        String urlPath = await FirebaseStorage.instance
            .ref()
            .child('shopper/$fileName')
            .getDownloadURL();
        print('urlPath => $urlPath');
        if (name[1].isEmpty) {
          //update urlimage only
          Map<String, dynamic> data = Map();
          data['urlshopper'] = urlPath;
          await FirebaseFirestore.instance
              .collection('typeuser')
              .doc(uid)
              .update(data)
              .then((value) => Navigator.pop(context));
        } else {
          //update aboute
        }
      });
    });
  }

  ElevatedButton buildUploadData() {
    return ElevatedButton.icon(
      onPressed: () {
        if ((file == null) && (name[1].isEmpty)) {
          Navigator.pop(context);
        } else {
          if (file == null) {
            //change display only

          } else {
            //upload image to firestore
            uploadImageToFirebase();
          }
        }
      },
      icon: Icon(Icons.cloud_upload),
      label: Text('Upload Data'),
    );
  }

  Container buildName() {
    return Container(
      width: screen * 0.6,
      child: TextFormField(
        onChanged: (value) => name[1] = value.trim(),
        initialValue: name[0],
        decoration: InputDecoration(
          border: OutlineInputBorder(),
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

  Container buildImage() {
    return Container(
      width: screen * 0.5,
      height: screen * 0.5,
      child: file == null
          ? typeUserModel.urlshopper == null
              ? MyStyle().showImage()
              : Image.network(typeUserModel.urlshopper)
          : Image(image: FileImage(file)),
    );
  }
}
