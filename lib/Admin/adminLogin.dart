import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:purebasket/Admin/uploadItems.dart';
import 'package:purebasket/Authentication/authenication.dart';
import 'package:purebasket/DialogBox/loadingDialog.dart';
import 'package:purebasket/Widgets/customTextField.dart';
import 'package:purebasket/DialogBox/errorDialog.dart';
import 'package:flutter/material.dart';




class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AdminPage"),centerTitle: true,elevation: 0,
      ),
      body: AdminSignInScreen(),
    );
  }
}


class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen>
{

  final TextEditingController _adminTextEditingController =
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
              child: Image.asset("images/admin.png",
                height: 240,
                width: 240,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Admin"),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _adminTextEditingController,
                    ico: Icons.person,
                    hintText: "Admin ID",
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
              _adminTextEditingController.text.isNotEmpty &&
                  _passwordTextEditingController.text.isNotEmpty ? loginAdmin() :
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
              height: 50,
            ),
            Container(
              height: 4,
              width: _screenWidth * 0.8,
              color: Colors.pink,
            ),
            SizedBox(
              height: 20,
            ),
            FlatButton.icon(onPressed: () =>
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AuthenticScreen())),
              icon: Icon(Icons.nature_people, color: Colors.pink,),
              label: Text("i'm not Admin"),

            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  loginAdmin(){
FirebaseFirestore.instance.collection("admins").get().then((snapshot) {
  snapshot.docs.forEach((result) {
    if(result["id"]!=_adminTextEditingController.text.trim())
      {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Your ID is not correct"),));
      }
    else if(result["password"]!=_passwordTextEditingController.text.trim())
      {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Password is not correct"),));
    }
    else{
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Welcome Dear Admin, "+result["name"]),));

      setState(() {
        _adminTextEditingController.text="";
        _passwordTextEditingController.text="";
      });

      Route route = MaterialPageRoute(builder: (_) => UploadPage());
      Navigator.pushReplacement(context, route);
    }
  });
});
  }


}
