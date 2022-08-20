import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:purebasket/Admin/adminLogin.dart';
import 'package:purebasket/Widgets/customTextField.dart';
import 'package:purebasket/DialogBox/errorDialog.dart';
import 'package:purebasket/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';
import 'package:purebasket/Config/config.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailTextEditingController =
  TextEditingController();
  final TextEditingController _passwordTextEditingController =
  TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery
        .of(context)
        .size
        .width,
        _scrrenHeight = MediaQuery
            .of(context)
            .size
            .height;

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
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset("images/login.png",
                height: 240,
                width: 240,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Login to your account"),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
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
                  ),
                ],
              ),
            ),
            RaisedButton(onPressed: () {
              _emailTextEditingController.text.isNotEmpty &&
                  _passwordTextEditingController.text.isNotEmpty ? loginUser() :
              showDialog(
                context: context,
                builder: (c) {
                  return LoadingAlertDialog(
                    message: "Please write email and password",
                  );
                },);
            },
              color: Colors.green,
              child: Text("Login"),
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
            FlatButton.icon(onPressed: () =>
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AdminSignInPage())),
              icon: Icon(Icons.nature_people, color: Colors.pink,),
              label: Text("i'm Admin"),

            ),

          ],
        ),
      ),
    );
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  void loginUser() async {
    showDialog(
      context: context,
      builder: (c) {
        return LoadingAlertDialog(
          message: "Authenticating, Please Wait.......",
        );
      },);

    User firebaseUser;
    await _auth.signInWithEmailAndPassword(
      email: _emailTextEditingController.text.trim(),
      password: _passwordTextEditingController.text.trim(),
    ).then((authUser) {
      firebaseUser = authUser.user;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.message.toString(),);
          });

    });
    if(firebaseUser!=null){
      readData(firebaseUser).then((s){
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (_) => StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
  }
  Future readData(User fUser)async{
    FirebaseFirestore.instance.collection("user").doc(fUser.uid).get().then((dataSnapshot)async{
      await EApp.sharedPreferences.setString("uid",dataSnapshot[EApp.userUID]);
      await EApp.sharedPreferences.setString(EApp.userEmail, dataSnapshot[EApp.userEmail]);
      await EApp.sharedPreferences.setString(EApp.userName, dataSnapshot[EApp.userName]);
      await EApp.sharedPreferences.setString(EApp.userAvatarUrl, dataSnapshot[EApp.userAvatarUrl]);

      List<String> cartList = dataSnapshot[EApp.userCartList].cast<String>();
      await EApp.sharedPreferences.setStringList(EApp.userCartList, ["garbageValue"]);
    });
  }
}
