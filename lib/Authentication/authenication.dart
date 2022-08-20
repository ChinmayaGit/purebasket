//import 'dart:html';

import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
import 'package:purebasket/Config/config.dart';


class AuthenticScreen extends StatefulWidget {
  @override
  _AuthenticScreenState createState() => _AuthenticScreenState();
}

class _AuthenticScreenState extends State<AuthenticScreen> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(title: Text("data"),centerTitle: true,elevation: 0,bottom: TabBar(
          tabs: [
            Tab(
              icon: Icon(Icons.lock,color: Colors.white,),
              text: "Login",
            ),
            Tab(
              icon: Icon(Icons.perm_contact_calendar,color: Colors.white,),
              text: "Register",
            ),
          ],
        ),),
        body: Container(
          child: TabBarView(
            children: [
              Login(),
              Register(),
            ],
          ),
        ),
      ),
    );
  }
}
