import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:purebasket/Admin/adminShiftOrders.dart';
import 'package:purebasket/Widgets/loadingWidget.dart';
import 'package:purebasket/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ImD;

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  bool get wantKeepAlive => true;
  File file;
  final TextEditingController _descriptionTextEditingController =
  TextEditingController();
  final TextEditingController _priceTextEditingController =
  TextEditingController();
  final TextEditingController _titleTextEditingController =
  TextEditingController();
  final TextEditingController _shortInfoTextEditingController =
  TextEditingController();
  String productId = DateTime
      .now()
      .millisecondsSinceEpoch
      .toString();
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    return file == null
        ? displayAdminHomeScreen()
        : displayAdminUploadFormScreen();
  }

  displayAdminHomeScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text("AdminPage"),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.border_color,
              color: Colors.white,
            ),
            onPressed: () {
              Route route =
              MaterialPageRoute(builder: (_) => AdminShiftOrders());
              Navigator.pushReplacement(context, route);
            }),
        actions: [
          FlatButton(
            onPressed: () {
              Route route = MaterialPageRoute(builder: (_) => SplashScreen());
              Navigator.pushReplacement(context, route);
            },
            child: Text(
              "Logout",
              style: TextStyle(
                  color: Colors.pink,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      body: getAdminHomeScreenBody(),
    );
  }

  getAdminHomeScreenBody() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green, Colors.lightGreenAccent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.shop_two,
              color: Colors.white,
              size: 200.0,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: RaisedButton(
                  color: Colors.amber,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.0)),
                  child: Text(
                    "Add New Items",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  onPressed: () => takeImage(context)),
            )
          ],
        ),
      ),
    );
  }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (com) {
          return SimpleDialog(
            title: Text(
              "Item Image",
              style: TextStyle(
                  color: Colors.blueAccent, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            children: [
              SimpleDialogOption(
                child: Text(
                  "Capture with Camera",
                  style: TextStyle(
                    color: Colors.blueAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
                onPressed: capturePhotoWithCamera,
              ),
              SimpleDialogOption(
                child: Text(
                  "Select From Gallery",
                  style: TextStyle(
                    color: Colors.blueAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
                onPressed: pickPhotoFromGallery,
              ),
              SimpleDialogOption(
                child: Text(
                  "Close",
                  style: TextStyle(
                    color: Colors.blueAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  capturePhotoWithCamera() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 680.0, maxWidth: 970.0);
    setState(() {
      file = imageFile;
    });
  }

  pickPhotoFromGallery() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      file = imageFile;
    });
  }

  displayAdminUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Product"),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Route route =
              MaterialPageRoute(builder: (_) => AdminShiftOrders());
              Navigator.pushReplacement(context, route);
            }),
        actions: [
          FlatButton(
            onPressed: uploading?null:()=>UploadImageAndSaveItemInfo(),
            child: Text(
              "Add",
              style: TextStyle(
                  color: Colors.pink,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          uploading ? linearProgress() : Text(""),
          Container(
            height: 230.0,
            width: MediaQuery
                .of(context)
                .size
                .width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(file), fit: BoxFit.cover)),
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 12.0)),
          ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: Colors.pink,
            ),
            title: Container(
              width: 250.0,
              child: TextFormField(
                style: TextStyle(
                  color: Colors.deepPurpleAccent,
                ),
                controller: _shortInfoTextEditingController,
                decoration: InputDecoration(
                  hintText: "Short Info",
                  hintStyle: TextStyle(
                    color: Colors.deepPurpleAccent,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.pink,
          ),
          ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: Colors.pink,
            ),
            title: Container(
              width: 250.0,
              child: TextFormField(
                style: TextStyle(
                  color: Colors.deepPurpleAccent,
                ),
                controller: _titleTextEditingController,
                decoration: InputDecoration(
                  hintText: "Title",
                  hintStyle: TextStyle(
                    color: Colors.deepPurpleAccent,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.pink,
          ),
          ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: Colors.pink,
            ),
            title: Container(
              width: 250.0,
              child: TextFormField(
                style: TextStyle(
                  color: Colors.deepPurpleAccent,
                ),
                controller: _descriptionTextEditingController,
                decoration: InputDecoration(
                  hintText: "Description",
                  hintStyle: TextStyle(
                    color: Colors.deepPurpleAccent,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.pink,
          ),
          ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: Colors.pink,
            ),
            title: Container(
              width: 250.0,
              child: TextFormField(
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color: Colors.deepPurpleAccent,
                ),
                controller: _priceTextEditingController,
                decoration: InputDecoration(
                  hintText: "Price",
                  hintStyle: TextStyle(
                    color: Colors.deepPurpleAccent,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.pink,
          ),
        ],
      ),
    );
  }

  clearFormInfo() {
    setState(() {
      file = null;
      _descriptionTextEditingController.clear();
      _priceTextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _titleTextEditingController.clear();
    });
  }

  UploadImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });
    String imageDownloadUrl = await uploadItemImage(file);
    saveItemInfo(imageDownloadUrl);
  }

  Future<String> uploadItemImage(mFileImage) async {
    final Reference storageReference = FirebaseStorage.instance.ref().child("items");
    UploadTask uploadTask = storageReference.child("product_$productId.jpg").putFile(mFileImage);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  saveItemInfo(String downloadUrl){
    final itemRef = FirebaseFirestore.instance.collection("items");
    itemRef.doc(productId).setData({
      "shortInfo":_shortInfoTextEditingController.text.trim(),
      "longDescription":_descriptionTextEditingController.text.trim(),
      "price":int.parse(_priceTextEditingController.text),
      "publishedDate":DateTime.now(),
      "status":"available",
      "thumbnailUrl":downloadUrl,
      "title":_titleTextEditingController.text.trim(),
    });
    setState(() {
      file=null;
      uploading=false;
      productId=DateTime.now().millisecondsSinceEpoch.toString();
      _descriptionTextEditingController.clear();
      _titleTextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _priceTextEditingController.clear();
    });
  }
}
