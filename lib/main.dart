import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:purebasket/Counters/ItemQuantity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Authentication/authenication.dart';
import 'package:purebasket/Config/config.dart';
import 'Counters/cartitemcounter.dart';
import 'Counters/changeAddresss.dart';
import 'Counters/totalMoney.dart';
import 'Store/storehome.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  EApp.auth = FirebaseAuth.instance;
  EApp.sharedPreferences =await SharedPreferences.getInstance();
  EApp.firestore =FirebaseFirestore.instance;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (c)=>CartItemCounter()),
            ChangeNotifierProvider(create: (c)=>CartItemCounter()),
            ChangeNotifierProvider(create: (c)=>AddressChanger()),
            ChangeNotifierProvider(create: (c)=>TotalAmount()),
          ],
      child: MaterialApp(
          title: 'e-Shop',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.green,
          ),
          home: SplashScreen()),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    displaySplash();
  }

  displaySplash() {
    Timer(Duration(seconds: 5), () async {
//      if (EApp.auth.currentUser() != null) {
      if (EApp.auth.currentUser != null) {
        Route route = MaterialPageRoute(builder: (_) => StoreHome());
        Navigator.pushReplacement(context, route);
      } else {
        Route route = MaterialPageRoute(builder: (_) => AuthenticScreen());
        Navigator.pushReplacement(context, route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightGreenAccent, Colors.greenAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/purebasket.png"),
            SizedBox(
              height: 20,
            ),
            Text(
              "Welcome to Purebasket.",
              style: TextStyle(color: Colors.white, fontSize: 25.0),
              textAlign: TextAlign.center,
            ),
          ],

        ),
      ),
    );
  }
}
