import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:purebasket/Authentication/login.dart';
import 'package:purebasket/Authentication/register.dart';
import 'package:purebasket/Store/cart.dart';
import 'package:purebasket/Store/product_page.dart';
import 'package:purebasket/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:purebasket/Config/config.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';
import '../Widgets/searchBox.dart';
import '../Models/item.dart';

double width;

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Purebasket"),
          centerTitle: true,
          elevation: 0,
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
        ),
        drawer: MyDrawer(),
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(pinned: true, delegate: SearchBoxDelegate()),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("items")
                    .limit(15)
                    .orderBy("publishedDate", descending: true)
                    .snapshots(),
                builder: (context, dataSnapshot) {
                  return !dataSnapshot.hasData
                      ? SliverToBoxAdapter(
                          child: Center(
                            child: circularProgress(),
                          ),
                        )
                      : SliverStaggeredGrid.countBuilder(
                          crossAxisCount: 1,
                          staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                          itemBuilder: (context, index) {
                            ItemModel model = ItemModel.fromJson(
                                dataSnapshot.data.docs[index].data());
                            return sourceInfo(model, context);
                          },
                          itemCount: dataSnapshot.data.docs.length,
                        );
                }),
          ],
        ),
      ),
    );
  }
}

Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell(
    onTap: (){
      Route route = MaterialPageRoute(builder: (_) => ProductPage(itemModel:model));
      Navigator.pushReplacement(context, route);
    },
    splashColor: Colors.pink,
    child: Padding(
      padding: EdgeInsets.all(6.0),
      child: Container(
        height: 190.0,
        width: width,
        child: Row(
          children: [
            Image.network(
              model.thumbnailUrl,
              width: 140.0,
              height: 140.0,
            ),
            SizedBox(
              width: 4.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                            child: Text(
                          model.title,
                          style: TextStyle(color: Colors.black, fontSize: 14.0),
                        ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            model.shortInfo,
                            style:
                                TextStyle(color: Colors.black, fontSize: 12.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.pink,
                        ),
                        alignment: Alignment.topLeft,
                        width: 40.0,
                        height: 43.0,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "50%",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.normal),
                              ),
                              Text(
                                "OFF",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 0.0),
                            child: Row(
                              children: [
                                Text(
                                  r"  Origional Price: ₹ ",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  (model.price + model.price).toString(),
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Row(
                              children: [
                                Text(
                                  r"  New Price:",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  " ₹ ",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.red,
                                  ),
                                ),
                                Text(
                                  (model.price).toString(),
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                Flexible(child: Container(

                ))
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container();
}

void checkItemInCart(String productID, BuildContext context) {}
