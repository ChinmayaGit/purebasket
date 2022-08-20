import 'package:purebasket/Store/cart.dart';
import 'package:purebasket/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final PreferredSizeWidget bottom;

  MyAppBar({this.bottom});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green, Colors.lightGreenAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            tileMode: TileMode.clamp,
          ),
        ),
      ),
      centerTitle: true,
      title: Text(
        "Purebasket",
        style: TextStyle(
            color: Colors.white, fontSize: 55.0, fontWeight: FontWeight.bold),
      ),
      bottom: bottom,
      actions: [
        Stack(
          children: [
            IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Route route =
                  MaterialPageRoute(builder: (_) => CartPage());
                  Navigator.pushReplacement(context, route);
                }),
            Positioned(
                child: Stack(
                  children: [
                    Icon(Icons.brightness_1, size: 20, color: Colors.amber),
                    Positioned(
                        top: 3.0,
                        bottom: 4.0,
                        left: 6.0,
                        child: Consumer<CartItemCounter>(
                            builder: (context, counter, _) {
                              return Text(
                                counter.count.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700),
                              );
                            }))
                  ],
                ))
          ],
        )
      ],
    );
  }

  Size get preferredSize => bottom == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}
