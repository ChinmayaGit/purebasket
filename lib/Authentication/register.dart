import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:purebasket/Widgets/customTextField.dart';
import 'package:purebasket/DialogBox/errorDialog.dart';
import 'package:purebasket/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:purebasket/Store/storehome.dart';
import 'package:purebasket/Config/config.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final TextEditingController _cPasswordTextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userImageUrl;
  File _imageFile;

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _scrrenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green, Colors.lightGreenAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: _selectAndPickImage,
              child: CircleAvatar(
                radius: _screenWidth * 0.15,
                backgroundColor: Colors.white,
                backgroundImage:
                    _imageFile == null ? null : FileImage(_imageFile),
                child: _imageFile == null ? Icon(Icons.add_a_photo) : null,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nameTextEditingController,
                    ico: Icons.person,
                    hintText: "Name",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _emailTextEditingController,
                    ico: Icons.email,
                    hintText: "Email",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _passwordTextEditingController,
                    ico: Icons.person,
                    hintText: "Password",
                    isObsecure: true,
//                    subIcon: Icons.remove_red_eye,
                  ),
                  CustomTextField(
                    controller: _cPasswordTextEditingController,
                    ico: Icons.person,
                    hintText: "Confirm Password",
                    isObsecure: false,
                  ),
                ],
              ),
            ),
            RaisedButton(
              onPressed: () {
                uploadAndSaveImage();
              },
              color: Colors.pink,
              child: Text("Sign Up"),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 4,
              width: _screenWidth * 0.8,
              color: Colors.pink,
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectAndPickImage() async {
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<void> uploadAndSaveImage() async {
    if (_imageFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: "Please select an image file.",
            );
          });
    } else {
      _passwordTextEditingController.text ==
              _cPasswordTextEditingController.text
          ? _emailTextEditingController.text.isNotEmpty &&
                  _passwordTextEditingController.text.isNotEmpty &&
                  _cPasswordTextEditingController.text.isNotEmpty &&
                  _nameTextEditingController.text.isNotEmpty
              ? uploadToStorage()
              : displayDialog("please fill up the registration complete form.")
          : displayDialog("Password do not match");
    }
  }



  uploadToStorage() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: "Authenticating, Please Wait.......",
          );
        });
    String imageFileName = "${_nameTextEditingController.text}"+DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageReference =
        FirebaseStorage.instance.ref().child(imageFileName);
    UploadTask storageUploadTask = storageReference.putFile(_imageFile);
    TaskSnapshot taskSnapshot = await storageUploadTask;
    await taskSnapshot.ref.getDownloadURL().then((urlImage) {
      userImageUrl = urlImage;
      _registerUsed();
    });
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  void _registerUsed() async {
    User firebaseUser;
    await _auth
        .createUserWithEmailAndPassword(
      email: _emailTextEditingController.text.trim(),
      password: _passwordTextEditingController.text.trim(),
    )
        .then((auth) {
      firebaseUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });
    if (firebaseUser != null) {
      saveUserInfoToFireStore(firebaseUser).then((value) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (_) => StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future saveUserInfoToFireStore(User fUser) async {
    final DateTime timestamp = DateTime.now();
    FirebaseFirestore.instance.collection("user").doc(fUser.uid).set({
      "uid": fUser.uid,
      "email": fUser.email,
      "name": _nameTextEditingController.text.trim(),
      "url": userImageUrl,
      "pass":_passwordTextEditingController.text.trim(),
      "timestamp": timestamp,
      EApp.userCartList:["garbageValue"],
    });
    await EApp.sharedPreferences.setString("uid", fUser.uid);
    await EApp.sharedPreferences.setString(EApp.userEmail, fUser.email);
    await EApp.sharedPreferences.setString(EApp.userName, _nameTextEditingController.text);
    await EApp.sharedPreferences.setString(EApp.userAvatarUrl, userImageUrl);
    await EApp.sharedPreferences.setStringList(EApp.userCartList, ["garbageValue"]);
  }
  displayDialog(String msg) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: msg,
          );
        });
  }
}
