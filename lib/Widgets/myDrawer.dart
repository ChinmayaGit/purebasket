import 'package:purebasket/Authentication/authenication.dart';
import 'package:purebasket/Config/config.dart';
import 'package:purebasket/Address/addAddress.dart';
import 'package:purebasket/Store/Search.dart';
import 'package:purebasket/Store/cart.dart';
import 'package:purebasket/Orders/myOrders.dart';
import 'package:purebasket/Store/storehome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 1.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.deepOrange, Colors.deepPurpleAccent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  tileMode: TileMode.clamp),
            ),
            child: Column(
              children: [
                Material(
                  borderRadius: BorderRadius.all(Radius.circular(80)),
                  elevation: 8,
                  child: Container(
                    height: 160,
                    width: 160,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          EApp.sharedPreferences.getString(EApp.userAvatarUrl)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  EApp.sharedPreferences.getString(EApp.userEmail),
                ),
                SizedBox(
                  height: 12.0,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  EApp.sharedPreferences.getString(EApp.userName),
                ),
                SizedBox(
                  height: 12.0,
                ),
                Container(
                  padding: const EdgeInsets.only(top: 1.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.green, Colors.lightGreenAccent],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        tileMode: TileMode.clamp),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.home,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Home",
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Route route =
                              MaterialPageRoute(builder: (_) => StoreHome());
                          Navigator.pushReplacement(context, route);
                        },
                      ),
                      Divider(
                        height: 10.0,
                        thickness: 6.0,
                        color: Colors.white,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                        title: Text(
                          "My Orders",
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Route route =
                              MaterialPageRoute(builder: (_) => MyOrders());
                          Navigator.pushReplacement(context, route);
                        },
                      ),
                      Divider(
                        height: 10.0,
                        thickness: 6.0,
                        color: Colors.white,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        title: Text(
                          "My Cart",
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Route route =
                              MaterialPageRoute(builder: (_) => CartPage());
                          Navigator.pushReplacement(context, route);
                        },
                      ),
                      Divider(
                        height: 10.0,
                        thickness: 6.0,
                        color: Colors.white,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.home,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Search",
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Route route = MaterialPageRoute(
                              builder: (_) => SearchProduct());
                          Navigator.pushReplacement(context, route);
                        },
                      ),
                      Divider(
                        height: 10.0,
                        thickness: 6.0,
                        color: Colors.white,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.add_location,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Add New Address",
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Route route =
                              MaterialPageRoute(builder: (_) => AddAddress());
                          Navigator.pushReplacement(context, route);
                        },
                      ),
                      Divider(
                        height: 10.0,
                        thickness: 6.0,
                        color: Colors.white,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.exit_to_app,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Logout",
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          EApp.auth.signOut().then((c) {
                            Route route = MaterialPageRoute(
                                builder: (_) => AuthenticScreen());
                            Navigator.pushReplacement(context, route);
                          });
                        },
                      ),
                      Divider(
                        height: 10.0,
                        thickness: 6.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
